import 'dart:async';

import 'package:flutter_movies_app/bloc/favorites/favorites_event.dart';
import 'package:flutter_movies_app/bloc/favorites/favorites_state.dart';
import 'package:flutter_movies_app/data/repository/favorites_repository.dart';
import 'package:flutter_movies_app/data/repository/favorites_storage_interface.dart';
import 'package:flutter_movies_app/models/app_exception.dart';
import 'package:rxdart/rxdart.dart';

/// FavoritesBloc is the main business logic component
class FavoritesBloc {
  final FavoritesRepository _repository;

  // Stream controllers
  final _favoritesStateController = StreamController<FavoritesState>.broadcast();
  final _favoriteStatusController = BehaviorSubject<Map<int, bool>>.seeded({});
  final _favoritesEventController = StreamController<FavoritesEvent>();

  // Stream getters
  Stream<FavoritesState> get favoritesState => _favoritesStateController.stream;

  Stream<Map<int, bool>> get favoriteStatus => _favoriteStatusController.stream;

  Sink<FavoritesEvent> get favoritesEventSink => _favoritesEventController.sink;

  // Sinks for internal use
  StreamSink<FavoritesState> get _inFavorites => _favoritesStateController.sink;

  StreamSink<Map<int, bool>> get _inFavoriteStatus => _favoriteStatusController.sink;

  // Current favorite status map
  Map<int, bool> get _currentFavoriteStatus => _favoriteStatusController.value;

  FavoritesBloc(FavoritesStorageInterface storage) : _repository = FavoritesRepository(storage) {
    _initialize();
    _favoritesEventController.stream.listen(_mapEventToState);
  }

  Future<void> _initialize() async {
    try {
      _inFavorites.add(FavoritesLoadingState());
      await _repository.initialize();
      final favorites = await _repository.getFavorites();

      // Emit initial favorites status
      final initialStatus = {for (var id in _repository.favoriteIds) id: true};
      _inFavoriteStatus.add(initialStatus);

      // Update the state with loaded favorites
      _inFavorites.add(FavoritesLoadedState(favorites));
    } catch (e) {
      _inFavorites.add(FavoritesErrorState(
        AppException(
          statusCode: -1,
          statusMessage: 'Failed to initialize favorites storage: $e',
          exceptionType: AppExceptionType.unknownException,
        ),
        'Failed to initialize favorites storage',
      ));
    }
  }

  Future<void> _mapEventToState(FavoritesEvent event) async {
    try {
      if (event is LoadFavoritesEvent) {
        await _handleLoadFavoritesEvent();
      } else if (event is AddToFavoritesEvent) {
        await _handleAddToFavoritesEvent(event);
      } else if (event is RemoveFromFavoritesEvent) {
        await _handleRemoveFromFavoritesEvent(event);
      } else if (event is ToggleFavoriteEvent) {
        await _handleToggleFavoriteEvent(event);
      }
    } catch (e) {
      _inFavorites.add(FavoritesErrorState(
        AppException(
          statusCode: -1,
          statusMessage: 'Error processing favorites event: $e',
          exceptionType: AppExceptionType.unknownException,
        ),
        'Error processing favorites event',
      ));
    }
  }

  Future<void> _handleLoadFavoritesEvent() async {
    _inFavorites.add(FavoritesLoadingState());
    try {
      final favorites = await _repository.getFavorites();

      // Update status stream
      final updatedStatus = {for (var id in _repository.favoriteIds) id: true};
      _inFavoriteStatus.add(updatedStatus);

      // Update state
      _inFavorites.add(FavoritesLoadedState(favorites));
    } catch (e) {
      _inFavorites.add(FavoritesErrorState(
        AppException(
          statusCode: -1,
          statusMessage: 'Failed to load favorites: $e',
          exceptionType: AppExceptionType.unknownException,
        ),
        'Failed to load favorites',
      ));
    }
  }

  Future<void> _handleAddToFavoritesEvent(AddToFavoritesEvent event) async {
    _inFavorites.add(FavoritesLoadingState());
    try {
      // Update status optimistically
      Map<int, bool> updatedStatus = Map.from(_currentFavoriteStatus);
      updatedStatus[event.movie.id] = true;
      _inFavoriteStatus.add(updatedStatus);

      // Perform storage operation
      await _repository.addFavorite(event.movie);

      // Refresh favorites
      final favorites = await _repository.getFavorites();
      _inFavorites.add(FavoritesLoadedState(favorites));
    } catch (e) {
      // Revert optimistic update
      Map<int, bool> updatedStatus = Map.from(_currentFavoriteStatus);
      updatedStatus.remove(event.movie.id);
      _inFavoriteStatus.add(updatedStatus);

      _inFavorites.add(FavoritesErrorState(
        AppException(
          statusCode: -1,
          statusMessage: 'Failed to add to favorites: $e',
          exceptionType: AppExceptionType.unknownException,
        ),
        'Failed to add to favorites',
      ));
    }
  }

  Future<void> _handleRemoveFromFavoritesEvent(RemoveFromFavoritesEvent event) async {
    _inFavorites.add(FavoritesLoadingState());
    try {
      // Update status optimistically
      Map<int, bool> updatedStatus = Map.from(_currentFavoriteStatus);
      updatedStatus.remove(event.movieId);
      _inFavoriteStatus.add(updatedStatus);

      // Perform storage operation
      await _repository.removeFavorite(event.movieId);

      // Refresh favorites
      final favorites = await _repository.getFavorites();
      _inFavorites.add(FavoritesLoadedState(favorites));
    } catch (e) {
      // Revert optimistic update
      Map<int, bool> updatedStatus = Map.from(_currentFavoriteStatus);
      updatedStatus[event.movieId] = true;
      _inFavoriteStatus.add(updatedStatus);

      _inFavorites.add(FavoritesErrorState(
        AppException(
          statusCode: -1,
          statusMessage: 'Failed to remove from favorites: $e',
          exceptionType: AppExceptionType.unknownException,
        ),
        'Failed to remove from favorites',
      ));
    }
  }

  Future<void> _handleToggleFavoriteEvent(ToggleFavoriteEvent event) async {
    try {
      final movieId = event.movie.id;
      final isCurrentlyFavorite = _repository.favoriteIds.contains(movieId);
      final newStatus = !isCurrentlyFavorite;

      // Update status optimistically
      Map<int, bool> updatedStatus = Map.from(_currentFavoriteStatus);
      if (newStatus) {
        updatedStatus[movieId] = true;
      } else {
        updatedStatus.remove(movieId);
      }
      _inFavoriteStatus.add(updatedStatus);

      // Perform storage operation
      if (newStatus) {
        await _repository.addFavorite(event.movie);
      } else {
        await _repository.removeFavorite(movieId);
      }

      // Refresh favorites list
      final favorites = await _repository.getFavorites();
      _inFavorites.add(FavoritesLoadedState(favorites));
    } catch (e) {
      _inFavorites.add(FavoritesErrorState(
        AppException(
          statusCode: -1,
          statusMessage: 'Failed to toggle favorite: $e',
          exceptionType: AppExceptionType.unknownException,
        ),
        'Failed to toggle favorite',
      ));

      // If an error occurred, reload favorites to ensure UI is in sync with storage
      try {
        final favorites = await _repository.getFavorites();

        // Update status
        final updatedStatus = {for (var id in _repository.favoriteIds) id: true};
        _inFavoriteStatus.add(updatedStatus);

        _inFavorites.add(FavoritesLoadedState(favorites));
      } catch (_) {
        // If refresh fails, just log the error
        _inFavorites.add(FavoritesErrorState(
          AppException(
            statusCode: -1,
            statusMessage: 'Failed to refresh favorites after error',
            exceptionType: AppExceptionType.unknownException,
          ),
          'Failed to refresh favorites after error',
        ));
      }
    }
  }

  // Helper method to check if a movie is favorite
  Stream<bool> getFavoriteStatus(int movieId) {
    // Get initial status
    final bool initialStatus = _repository.favoriteIds.contains(movieId);

    // Create a stream that starts with initial value and updates on changes
    return favoriteStatus.map((statusMap) => statusMap.containsKey(movieId)).startWith(initialStatus);
  }

  // Helper method for direct checking
  Future<bool> isFavorite(int movieId) async {
    return await _repository.isFavorite(movieId);
  }

  void dispose() {
    _favoritesStateController.close();
    _favoritesEventController.close();
    _favoriteStatusController.close();
    _repository.close();
  }
}
