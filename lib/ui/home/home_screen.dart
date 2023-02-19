import 'package:flutter/material.dart';
import 'package:flutter_movies_app/bloc/movie_bloc.dart';
import 'package:flutter_movies_app/common_widgets/common_widgets.dart';
import 'package:flutter_movies_app/models/models.dart';
import 'package:flutter_movies_app/utils/image_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late MovieBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = MovieBloc();
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Resource<List<Movie>>>(
      stream: _bloc.movieListStream,
      builder: (context, AsyncSnapshot<Resource<List<Movie>>> snapshot) {
        if (snapshot.hasData) {
          Resource<List<Movie>> response = snapshot.data!;
          switch (response.status) {
            case Status.completed:
              return _fetchMovieGrid(response.data!);
            case Status.loading:
              return const Center(child: CircularProgressIndicator());
            case Status.error:
              return Text("Error: ${response.message}", style: Theme.of(context).textTheme.bodyLarge);
          }
        }
        return const Placeholder();
      },
    );
  }

  Widget _fetchMovieGrid(List<Movie> movies) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.49,
          mainAxisSpacing: 16,
          crossAxisSpacing: 4,
        ),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return MovieCard(
            name: movies[index].title,
            rating: movies[index].rating / 2,
            imageUrl: ImageUtils.getLargePosterUrl(movies[index].posterPath),
          );
        },
      ),
    );
  }
}
