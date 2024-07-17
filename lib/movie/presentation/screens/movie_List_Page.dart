import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/app/assets.dart';
import 'package:movie_app/movie/presentation/widgets/movieList.dart';
import 'package:go_router/go_router.dart';
import '../../../core/injection.dart';
import '../movies_view_model.dart';
import '../widgets/outInCinema.dart';

class MovieListPage extends ConsumerWidget {
  MovieListPage({super.key});

  final viewModel = getIt<MoviesViewModel>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outinCinProv = ref.watch(outInCinemaProvider);
    final allMovieProv = ref.watch(allMovieFavoriteProvider);
    final toggleActionProv = ref.watch(toggleFavMovieProvider as ProviderListenable);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFE41F2D),
        leading: Container(
          child: GestureDetector(
            onTap: () {
              // viewModel.logout();
              // context.goNamed('login');
            },
            child: Image.asset(Assets.loginLogo),
          ),
        ),
        actions: [
          GestureDetector(
              onTap: () {
                context.goNamed('favorites');
              },
              child: Stack(
                // alignment: AlignmentDirectional.center,
                children: const [
                  Icon(Icons.favorite_border, size: 30),
                  // Positioned(
                  //   top: 0,
                  //   left: 0,
                  //   child: Consumer<FavoritesModel>(
                  //       builder: (context, value, child) {
                  //     return Container(
                  //         width: 16,
                  //         height: 16,
                  //         decoration: BoxDecoration(
                  //             shape: BoxShape.circle, color: Colors.blue),
                  //         child: Text(
                  //           value.favoritesMovies.length.toString(),
                  //           textAlign: TextAlign.center,
                  //           style: TextStyle(fontSize: 10),
                  //         ));
                  //   }),
                  // )
                ],
              )),
          const SizedBox(
            width: 8,
          ),
          GestureDetector(
            onTap: () => print('tapped'),
            child: const Icon(
              Icons.search,
              size: 30,
            ),
          ),
          const SizedBox(
            width: 8,
          )
        ],
      ),
      body: ListView(
        children: [
          outinCinProv.when(
              data: (movie) {
                return OutInCinema(title: 'Out in Cinema', movies: movie);
              },
              error: (error, StackTrace stacktrace) => Text(error.toString()),
              loading: () => const Center(child: CircularProgressIndicator())),
          allMovieProv.when(
              data: (movie) {
                return MovieList(
                    title: 'Popular',
                    movies: movie,
                    toggleFavorite: toggleActionProv);
              },
              error: (error, StackTrace stacktrace) => Text(error.toString()),
              loading: () => const Center(child: CircularProgressIndicator())),
          // Observer(builder: (context) {
          //   return viewModel.outInCinema.map(
          //       initial: (_) => Center(child: CircularProgressIndicator()),
          //       loading: (_) => Center(child: CircularProgressIndicator()),
          //       error: (value) => Text(value.error.toString()),
          //       success: (value) =>
          //           OutInCinema(title: 'Out in Cinema', movies: value.data));
          // }),
          // Stars(title: 'Stars'),
          // Observer(builder: (context) {
          //   return viewModel.topRatedMovies.map(
          //       initial: (_) => Center(child: CircularProgressIndicator()),
          //       loading: (_) => Center(child: CircularProgressIndicator()),
          //       error: (value) => Text(value.error),
          //       success: (value) =>
          //           MovieList(title: 'Top Rated Movies', movies: value.data, toggleFavorite: (int movieId) {  },));
          // }),
          // Observer(builder: (context) {
          //   return viewModel.allMovies.map(
          //       initial: (_) => Center(child: CircularProgressIndicator()),
          //       loading: (_) => Center(child: CircularProgressIndicator()),
          //       error: (value) => Text(value.error.toString()),
          //       success: (value) => MovieList(
          //           title: 'Popular',
          //           movies: value.data,
          //           toggleFavorite: viewModel.toggleFavorite));
          // }),
          // StreamBuilder<List<Movie>>(
          //     stream: _getMovieList,
          //     builder: (context, snapshot) {
          //       if (snapshot.hasError)
          //         return Text('There is an error');
          //       else if (snapshot.connectionState == ConnectionState.waiting)
          //         return CircularProgressIndicator();
          //       return MovieList(
          //           title: 'Get popular movies',
          //           movies: snapshot.requireData); //widget
          //     }),
          // Observer(builder: (context) {
          //   return viewModel.nowPlayingMovies.map(
          //       initial: (_) => Center(child: CircularProgressIndicator()),
          //       loading: (_) => Center(child: CircularProgressIndicator()),
          //       error: (value) => Text(value.error),
          //       // success: (value) =>
          //           // MovieList(title: 'Airing Today', movies: value.data));
          // }),
        ],
      ),
    );
  }
}
