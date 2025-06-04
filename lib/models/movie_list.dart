class MovieList {
  final int id;
  final String title;
  final String poster_path;
  final double vote_average;
  final List<dynamic> genre_ids;

  MovieList({
    required this.id,
    required this.title,
    required this.poster_path,
    required this.vote_average,
    required this.genre_ids,
  });

  factory MovieList.fromJson(Map<String, dynamic> json) {
    return MovieList(
      id: json['id'] ?? 0,
      title: json['title'] ?? "",
      poster_path: json['poster_path'] ?? '',
      vote_average: json['vote_average'] ?? 0,
      genre_ids: json['genre_ids'] ?? [],
    );
  }
}
