import 'package:flutter/material.dart';
import 'package:peliculas_app/providers/movies_provider.dart';
import 'package:peliculas_app/search/search_delegate.dart';
import 'package:peliculas_app/widgets/CardSwiper.dart';
import 'package:peliculas_app/widgets/MovieSlider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>( context, listen: true );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Homeflix'),
        actions: [
          IconButton(
              onPressed: () => showSearch(
                context: context,
                delegate: SearchMovieDelegate(),
              ),
              icon: const Icon( Icons.search_outlined )
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Swipper
            CardSwiper(
              movieList: moviesProvider.onDisplayMovies,
            ),
            MovieSlider(
              title: 'Populares',
              popularMovieList: moviesProvider.popularMovies,
              onNextPage: () => moviesProvider.getPopularMovies(),
            )
          ],
        ),
      )
    );
  }
}
