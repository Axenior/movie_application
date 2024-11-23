import 'package:get/get.dart';
import 'package:movie_application/data/movie_data.dart';
import 'package:movie_application/models/movie.dart';

class MovieController extends GetxController {
  Rx<Movie> activeMovie = movieList[0].obs;
  Rx<Movie> detailMovie = movieList[0].obs;

  void setActiveMovie(Movie movie) {
    activeMovie.value = movie;
  }

  void setDetailMovie(Movie movie) {
    detailMovie.value = movie;
  }
}
