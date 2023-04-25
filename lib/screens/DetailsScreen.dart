import 'package:flutter/material.dart';
import 'package:peliculas_app/models/models.dart';
import 'package:peliculas_app/widgets/CastingCard.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Movie movie = ModalRoute.of(context)!.settings.arguments as Movie;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _CustomAppBar(
              movie: movie
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              _PosterAndTitle(
                  movie: movie
              ),
              _Overview(
                  movie: movie
              ),
              CastingCard(
                movieId: movie.id,
              )
            ])
          )
        ],
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  final Movie movie;

  const _CustomAppBar({
    super.key,
    required this.movie
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.all(0),
        title: Container(
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          color: Colors.black26,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Text(
              movie.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
              ),
          ),
        ),
        background: FadeInImage(
          placeholder: const AssetImage('assets/loading.gif'),
          image: NetworkImage(movie.fullBackdropPath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  final Movie movie;

  const _PosterAndTitle({
    super.key,
    required this.movie
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only( top: 20 ),
      padding: const EdgeInsets.symmetric( horizontal: 20 ),
      child: Row(
        children: [
          Hero(
            tag: movie.heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                placeholder: const AssetImage('assets/no-image.jpg'),
                image: NetworkImage( movie.fullPosterImg ),
                height: 150,
              ),
            ),
          ),
          const SizedBox( width: 20 ),
          SizedBox(
            width: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.start,
                ),
                const SizedBox( height: 10 ),
                Text(
                  movie.originalTitle,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric( vertical: 10 ),
                    child: Row(
                      children: [
                        const Icon( Icons.star_outline, size: 20, color: Colors.grey ),
                        const SizedBox( width: 5 ),
                        Text(
                          '${movie.voteAverage} stars',
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    )
                )
              ],
            )
          ),
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  final Movie movie;

  const _Overview({
    super.key,
    required this.movie
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric( horizontal: 25, vertical: 20 ),
      child: Text(
        movie.overview,
        style: const TextStyle(
          fontSize: 15,
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }
}



