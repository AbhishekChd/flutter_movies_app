import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_movies_app/bloc/movie_bloc.dart';
import 'package:flutter_movies_app/common_widgets/common_widgets.dart';
import 'package:flutter_movies_app/constants/strings.dart';
import 'package:flutter_movies_app/data/network/tmdb_api.dart';
import 'package:flutter_movies_app/models/models.dart';
import 'package:google_fonts/google_fonts.dart';
import 'movie_detail_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late MovieBloc _bloc;
  bool filterPopularSelected = true;
  bool isErrorState = false;
  AppException? exception;

  @override
  void initState() {
    super.initState();
    _bloc = MovieBloc(filterPopularSelected ? MovieSortingCriteria.popular : MovieSortingCriteria.topRated);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isErrorState) {
      return _errorScreen(exception!);
    }
    return StreamBuilder<Resource<Map<int, String>>>(
      stream: _bloc.movieGenreStream,
      builder: (context, AsyncSnapshot<Resource<Map<int, String>>> genreSnapshot) {
        if (genreSnapshot.hasData) {
          switch (genreSnapshot.data!.status) {
            case Status.completed:
              return StreamBuilder<Resource<List<Movie>>>(
                stream: _bloc.movieListStream,
                builder: (context, AsyncSnapshot<Resource<List<Movie>>> movieListSnapshot) {
                  if (movieListSnapshot.hasData) {
                    Resource<List<Movie>> response = movieListSnapshot.data!;
                    switch (response.status) {
                      case Status.completed:
                        return _fetchMovieGrid(response.data!, genreSnapshot.data!.data!);
                      case Status.loading:
                        return const Center(child: CircularProgressIndicator());
                      case Status.error:
                        _sendErrorState(response.exception!);
                    }
                  }
                  return Container();
                },
              );
            case Status.loading:
              return const Center(child: CircularProgressIndicator());
            case Status.error:
              _sendErrorState(genreSnapshot.data!.exception!);
          }
        }
        if (genreSnapshot.hasData && genreSnapshot.data!.status == Status.completed) {}
        return Container();
      },
    );
  }

  void _sendErrorState(AppException ex) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isErrorState = true;
        exception = ex;
      });
    });
  }

  Widget _fetchMovieGrid(List<Movie> movies, Map<int, String> genres) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Row(
              children: [
                FilterChip(
                  label: const Text(Strings.movieFilterPopular),
                  avatar: Icon(Icons.local_fire_department, color: Theme.of(context).iconTheme.color),
                  onSelected: (value) => setState(() {
                    if (!filterPopularSelected) {
                      _bloc.fetchMovieList(MovieSortingCriteria.popular);
                    }
                    filterPopularSelected = !filterPopularSelected;
                  }),
                  selected: filterPopularSelected,
                  showCheckmark: false,
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text(Strings.movieFilterTopRated),
                  avatar: Icon(Icons.trending_up, color: Theme.of(context).iconTheme.color),
                  onSelected: (value) => setState(() {
                    if (filterPopularSelected) {
                      _bloc.fetchMovieList(MovieSortingCriteria.topRated);
                    }
                    filterPopularSelected = !filterPopularSelected;
                  }),
                  showCheckmark: false,
                  selected: !filterPopularSelected,
                ),
              ],
            ),
            const SizedBox(height: 8),
            LayoutGrid(
              columnSizes: [1.fr, 1.fr],
              rowSizes: List.generate(movies.length ~/ 2, (int index) => auto),
              rowGap: 16,
              columnGap: 8,
              children: _generateMovieCards(movies, genres),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _generateMovieCards(List<Movie> movies, Map<int, String> genres) {
    List<Widget> widgets = [];
    for (var movie in movies) {
      widgets.add(MovieCard(
        name: movie.title,
        rating: movie.rating / 2,
        imageUrl: movie.getPosterImageUrl(),
        genres: Genre.toNameList(genres, movie.genreIds),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MovieDetail(
              movie: movie,
              genres: Genre.toNameList(genres, movie.genreIds),
            ),
          ));
        },
      ));
    }
    return widgets;
  }

  Widget _errorScreen(AppException exception) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.dangerous_outlined, color: Colors.red, size: 32),
                  const SizedBox(width: 8),
                  Text("Error",
                      style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                            fontFamily: GoogleFonts.robotoMono().fontFamily,
                          )),
                ],
              ),
            ),
            Text(
              exception.exceptionType.name,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(fontFamily: GoogleFonts.robotoMono().fontFamily),
            ),
            const SizedBox(height: 8),
            Text(exception.statusMessage),
            const SizedBox(height: 64),
            FilledButton(
              onPressed: () => WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  _bloc =
                      MovieBloc(filterPopularSelected ? MovieSortingCriteria.popular : MovieSortingCriteria.topRated);
                  isErrorState = false;
                  _bloc.fetchMovieGenres();
                });
              }),
              style: const ButtonStyle(
                shape: MaterialStatePropertyAll(
                    RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8)))),
                padding: MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 32)),
              ),
              child: const Text("Try again", style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
