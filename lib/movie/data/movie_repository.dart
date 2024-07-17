import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:movie_app/movie/data/movie_api.dart';
import 'package:movie_app/movie/data/movie_dao.dart';
import '../../core/storage/app_database.dart';
import '../../favorites_movie/data/favorites_movie_dao.dart';
import '../domain/movie.dart';
import '../domain/movie_details.dart';

@lazySingleton
class MovieRepository {
  final MoviesApi api;
  final MoviesDao _mDao;
  final FavoriteMoviesDao _fDao;
  MovieRepository( this.api,this._mDao, this._fDao);

  Future<int> loadPopularMovies({int page = 1}) async {
    final List<Movie> result = await api.getPopularMovies(page: page);
    await _mDao.replaceAll(result);
    return result.length;
    // await Future.delayed(const Duration(milliseconds: 10));
  }

  Future<List<Movie>> getTopRatedMovies({int page = 1}) async {
    return await api.getTopRatedMovies(page: page);
  }

  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    return await api.getNowPlayingMovies(page: page);
  }

  Future<List<Movie>> getOutInCinema({int page = 1}) async {
    return await api.getOutInCinema(page: page);
  }

  Future<MovieDetails> getMovieDetails(int movieId) async {
    return await api.getDetails(movieId);
  }

  Stream<List<Movie>> allPopularMovies() {
    return _mDao.watchAllMovies();
  }

  Stream<List<FavoriteMovie>> allFavoriteMovies() {
    return _fDao.watchAllFavoritesMovies();
  }
}

final movieRepositoryProvider = Provider((ref) => MovieRepository(ref.watch(movieApiProvider),ref.watch(movieDaoProvider),ref.watch(favoriteMovieDaoProvider)));
