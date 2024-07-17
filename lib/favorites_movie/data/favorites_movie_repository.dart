import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:movie_app/favorites_movie/data/favorites_movie_dao.dart';

import '../../movie/domain/movie.dart';

@lazySingleton
class FavoritesMovieRepository {
  final FavoriteMoviesDao _fDao;
  FavoritesMovieRepository(this._fDao);

  //Add favorite movie
  Future<void> addFavouriteMovie(int id) async {
    await _fDao.insertFavouriteMovie(id);
  }

  Stream<Set<int>> favoritesMovies() {
    return _fDao
        .watchAllFavoritesMovies()
        .map((list) => list.map((e) => e.id).toSet());
  }

  Future<void> removeFavoriteMovie(int id) async {
    await _fDao.deleteFavoriteMovie(id);
  }

  Stream<bool> isFavorite(int id) {
    return _fDao.getFavouriteMovieById(id);
  }

  Stream<List<Movie>> getFavoriteMovies() {
    return _fDao.getAllFavoriteMovies();
  }

  Future<void> toggleFavorite(int movieId, bool favorite) async {
    if (favorite) {
      await addFavouriteMovie(movieId);
    } else {
      await removeFavoriteMovie(movieId);
    }
  }
}

final favoriteMovieRepositoryProvider = Provider((ref) => FavoritesMovieRepository(ref.watch(favoriteMovieDaoProvider)));
