import 'package:flutter/material.dart';
import 'package:peliculas_app/models/models.dart';

class MovieSlider extends StatefulWidget {
  final List<Movie> popularMovieList;
  final String? title;
  final Function onNextPage;

  const MovieSlider({
    Key? key,
    required this.popularMovieList,
    required this.onNextPage,
    this.title,
  }) : super(key: key);

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      if( scrollController.position.pixels >= scrollController.position.maxScrollExtent - 500 ) {
        widget.onNextPage();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric( horizontal: 20, vertical: 10 ),
            child: Text(widget.title ?? 'Populares', style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600
            ),),
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.popularMovieList.length,
              itemBuilder: ( _, int index ) {
                final movie = widget.popularMovieList[index];
                return _MoviePoster(
                  movieData: movie,
                  imageURL: movie.fullPosterImg,
                  heroId: '${ widget.title }-$index-${ movie.id }',
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  final Movie movieData;
  final String? imageURL;
  final String heroId;

  const _MoviePoster({
    Key? key,
    required this.movieData,
    this.imageURL,
    required this.heroId
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    movieData.heroId = heroId;

    return Container(
      width: 240,
      height: 340,
      margin: const EdgeInsets.symmetric( horizontal: 5, vertical: 10 ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed( context, 'details', arguments: movieData ),
            child: Hero(
              tag: movieData.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular( 20 ),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(imageURL ?? 'assets/no-image.jpg'),
                  width: 205,
                  height: 280,
                  fit: BoxFit.cover,
                ),
              ),
            )
          ),
          const SizedBox(
            height: 5,
          ),
          Padding(
            padding: const EdgeInsets.symmetric( horizontal: 5, vertical: 5 ),
            child: Text(
              movieData.title,
              style: const TextStyle(
                fontSize: 17,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
