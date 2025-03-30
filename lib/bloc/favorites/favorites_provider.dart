import 'package:flutter/material.dart';
import 'package:flutter_movies_app/bloc/favorites/favorites_bloc.dart';
import 'package:flutter_movies_app/data/repository/favorites_storage_interface.dart';

class FavoritesBlocProvider extends InheritedWidget {
  final FavoritesBloc bloc;

  const FavoritesBlocProvider({
    Key? key,
    required Widget child,
    required this.bloc,
  }) : super(key: key, child: child);

  static FavoritesBloc of(BuildContext context) {
    final FavoritesBlocProvider? provider = context.dependOnInheritedWidgetOfExactType<FavoritesBlocProvider>();
    if (provider == null) {
      throw Exception('No FavoritesBlocProvider found in the widget tree');
    }
    return provider.bloc;
  }

  @override
  bool updateShouldNotify(FavoritesBlocProvider oldWidget) {
    return bloc != oldWidget.bloc;
  }

  static Widget create({
    Key? key,
    required Widget child,
    required FavoritesStorageInterface storage,
  }) {
    return FavoritesBlocProvider(
      key: key,
      bloc: FavoritesBloc(storage),
      child: child,
    );
  }
}
