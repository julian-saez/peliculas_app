import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:peliculas_app/helpers/debouncer.dart';
import 'package:peliculas_app/models/models.dart';
import 'package:peliculas_app/models/search_movie_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class MoviesProvider extends ChangeNotifier {
  final String _baseURL = dotenv.env['FLUTTER_HOSTNAME'].toString();
  final String _apiKey = dotenv.env['FLUTTER_API_KEY'].toString();
  final String _lang = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];
  Map<int, List<Cast>> moviesCast = {};

  int _popularPage = 0;

  final debouncer = Debouncer(
      duration: const Duration( milliseconds: 500 ),
  );

  final StreamController<List<Movie>> _suggestionsStreamController = StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream => _suggestionsStreamController.stream;

  MoviesProvider() {
    getOnDisplayMovies();
    getPopularMovies();
  }

  Future _getJsonData( String endpoint, [ int? pageIndex = 1 ] ) async {
    final url = Uri.https(_baseURL, endpoint,
        {
          'api_key': _apiKey,
          'language': _lang,
          'page': '$pageIndex',
        }
    );

    final response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies() async {
    final jsonData = await _getJsonData('3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson( jsonData );

    onDisplayMovies = nowPlayingResponse.results;

    notifyListeners();
  }

  getPopularMovies() async {
    _popularPage++;

    final jsonData = await _getJsonData('3/movie/popular', _popularPage );
    final popularResponse = PopularResponse.fromJson( jsonData );

    popularMovies = [ ...popularMovies, ...popularResponse.results ];

    notifyListeners();
  }

  Future<List<Cast>> getMovieCast( int movieId ) async {
    if( moviesCast.containsKey( movieId ) ){
      return moviesCast[movieId]!;
    };

    final jsonData = await _getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson( jsonData );

    moviesCast[movieId] = creditsResponse.cast;

    return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovie( String query ) async {
    final url = Uri.https(_baseURL, '3/search/movie',
        {
          'api_key': _apiKey,
          'language': _lang,
          'query': query,
        }
    );

    final response = await http.get(url);
    final SearchMovieResponse searchMovieResponse = SearchMovieResponse.fromJson( response.body );

    return searchMovieResponse.results;
  }

  void getSuggestionByQuery( String searchTerm ) {
    debouncer.value = '';

    debouncer.onValue = ( value ) async {
      final results = await searchMovie( value );
      _suggestionsStreamController.add( results );
    };

    final timer = Timer.periodic( const Duration( milliseconds: 300 ), ( _ ) {
      debouncer.value = searchTerm;
    });
    
    Future.delayed( const Duration( milliseconds: 301 ) ).then( (_) => timer.cancel() );
  }
}