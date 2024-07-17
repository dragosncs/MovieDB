import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:movie_app/movie/domain/movieModel.dart';
import 'package:movie_app/movie/domain/movie_details.dart';
import '../../app/assets.dart';
import '../../core/injection.dart';
// import '../../core/storage/app_database.dart';  ///
import '../../movie/domain/movie.dart';
import 'favorite_movie_view_model.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});
  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  late FavoriteViewModel favoriteViewModel;

  @override
  void initState() {
    super.initState();
    favoriteViewModel = getIt<FavoriteViewModel>();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Movie>>(
          stream: favoriteViewModel.getFavoriteMovies(),
          builder: (context, snapshot) {
            if (snapshot.hasError)
              return Text('There is an error');
            else if (snapshot.connectionState == ConnectionState.waiting)
              return CircularProgressIndicator();
            return FavoritesWidget(
              movies: snapshot.requireData,
              removeFavoriteMovie: favoriteViewModel.removeFavoriteMovie,
            ); //widget
          }),
    );
  }
}

class FavoritesWidget extends StatelessWidget {
  final List<Movie> movies;
  final Function(int movieId) removeFavoriteMovie;
  const FavoritesWidget(
      {super.key, required this.movies, required this.removeFavoriteMovie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Favorites'),
          backgroundColor: const Color(0xFFE41F2D),
        ),
        body: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.all(8),
            scrollDirection: Axis.vertical,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                          padding: EdgeInsets.all(5),
                          width: 104,
                          height: 180,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image:
                                    // AssetImage(Assets.avengers),
                                    CachedNetworkImageProvider(
                                        movies[index].posterPath),
                                fit: BoxFit.cover),
                          )),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                          child: Text(
                        movies[index].title,
                      )),
                      SizedBox(
                        width: 16,
                      ),
                      IconButton(
                          onPressed: () =>
                              removeFavoriteMovie(movies[index].id),
                          icon: const Icon(
                            Icons.favorite,
                            size: 28,
                            color: Colors.red,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  )
                ],
              );
            }));
  }
}
