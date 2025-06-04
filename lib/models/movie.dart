import 'package:movie_application/models/genre.dart';

class Movie {
  final int id;
  final String title;
  final String overview;
  final List<Genre> genres;
  final String poster_path;
  final int runtime;
  final double vote_average;
  final int vote_count;
  final double popularity;
  final String release_date;
  final String original_language;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.genres,
    required this.poster_path,
    required this.runtime,
    required this.vote_average,
    required this.vote_count,
    required this.popularity,
    required this.release_date,
    required this.original_language,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      overview: json['overview'] ?? "",
      genres: (json['genres'] as List<dynamic>?) // Cast ke List<dynamic>?
              ?.map((e) => Genre.fromJson(
                  e as Map<String, dynamic>)) // Map setiap Map ke objek Genre
              .toList() // Konversi ke List<Genre>
          ??
          [],
      poster_path: json['poster_path'] ?? "",
      runtime: json['runtime'] ?? 0,
      vote_average: json['vote_average'] ?? 0,
      vote_count: json['vote_count'] ?? 0,
      popularity: json['popularity'] ?? 0,
      release_date: json['release_date'] ?? "Unknown",
      original_language: json['original_language'] ?? "Unknown",
    );
  }
}
