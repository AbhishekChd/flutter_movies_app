import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_movies_app/bloc/movie_bloc.dart';
import 'package:flutter_movies_app/common_widgets/common_widgets.dart';
import 'package:flutter_movies_app/constants/strings.dart';
import 'package:flutter_movies_app/data/network/tmdb_api.dart';
import 'package:flutter_movies_app/models/models.dart';
import 'movie_detail_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late MovieBloc _bloc;
  bool filterPopularSelected = true;

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
                        return Text("Error: ${response.message}", style: Theme.of(context).textTheme.bodyLarge);
                    }
                  }
                  return Container();
                },
              );
            case Status.loading:
              return const Center(child: CircularProgressIndicator());
            case Status.error:
              return Text("Error: ${genreSnapshot.data!.exception}", style: Theme.of(context).textTheme.bodyLarge);
          }
        }
        if (genreSnapshot.hasData && genreSnapshot.data!.status == Status.completed) {}
        return Container();
      },
    );
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
}
