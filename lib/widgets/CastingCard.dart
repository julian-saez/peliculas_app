import 'package:flutter/material.dart';
import 'package:peliculas_app/models/credits_response.dart';
import 'package:peliculas_app/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class CastingCard extends StatelessWidget {
  final int movieId;

  const CastingCard({
    Key? key,
    required this.movieId
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final moviesProvider = Provider.of<MoviesProvider>( context, listen: false );
    
    return FutureBuilder(
      future: moviesProvider.getMovieCast( movieId ),
      builder: ( _, AsyncSnapshot<List<Cast>> snapshot ) {

        if( !snapshot.hasData ) {
          return Container(
            constraints: const BoxConstraints(
              maxWidth: 150
            ),
            height: 180,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final cast = snapshot.data!;

        return Container(
          margin: const EdgeInsets.only( bottom: 30 ),
          width: double.infinity,
          height: 180,
          child: ListView.builder(
            itemCount: cast.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: ( _, int index ) {
              final actor = cast[ index ];
              return _CastCard(
                actor: actor,
              );
            }
          ),
        );
      }
    );
  }
}

class _CastCard extends StatelessWidget {
  final Cast actor;

  const _CastCard({
    super.key,
    required this.actor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric( horizontal: 10 ),
      width: 110,
      height: 140,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: const AssetImage('assets/no-image.jpg'),
              image: NetworkImage( actor.fullProfileImg ),
              height: 120,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox( height: 10 ),
          Text(
            actor.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}

