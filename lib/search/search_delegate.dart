import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:peliculas_app/models/models.dart';
import 'package:peliculas_app/providers/movies_provider.dart';

class SearchMovieDelegate extends SearchDelegate {
  @override
  String get searchFieldLabel => 'Buscar pelicula';
  List<Movie> lastSearchList = [];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon( Icons.clear ),
        onPressed: () => query = '',
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close( context, null ),
        icon: const Icon( Icons.arrow_back ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions( context );
  }

  Widget _NoResultsContainer() {
    return Container(
      child: const Center(
        child: Icon( Icons.movie_creation_outlined, color: Colors.black12, size: 100 ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if( query.isEmpty ) {
      return _NoResultsContainer();
    }

    final moviesProvider = Provider.of<MoviesProvider>( context, listen: false );
    moviesProvider.getSuggestionByQuery( query );

    return StreamBuilder(
      stream: moviesProvider.suggestionStream,
      builder: ( _, AsyncSnapshot<List<Movie>> snapshot ) {
        if( !snapshot.hasData ) {
          return _NoResultsContainer();
        }

        lastSearchList = snapshot.data!;
        final movies = snapshot.data!;

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: ( _, int index ) => _SuggestionCard(movie: movies[index]),
        );
      }
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  final Movie movie;
  const _SuggestionCard({
    Key? key,
    required this.movie
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    movie.heroId = 'search-${ movie.id }';

    return ListTile(
      leading: Hero(
        tag: movie.heroId!,
        child: FadeInImage(
          placeholder: const AssetImage('assets/no-image.jpg'),
          image: NetworkImage( movie.fullPosterImg ),
          width: 50,
          fit: BoxFit.contain,
        ),
      ),
      title: Text( movie.title ),
      subtitle: Text( movie.originalTitle ),
      onTap: () => Navigator.pushNamed(context, 'details', arguments: movie ),
    );
  }
}
