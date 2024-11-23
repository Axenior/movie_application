class Movie {
  final String id;
  final String title;
  final String plot;
  final String genre;
  final String director;
  final String rated;
  final String poster;
  final String runTime;
  final List<String> imageUrls;
  double rating;
  int votes;
  int watchlist;
  bool isWatchlist;

  Movie({
    required this.id,
    required this.title,
    required this.plot,
    required this.genre,
    required this.director,
    required this.rated,
    required this.poster,
    required this.runTime,
    required this.imageUrls,
    required this.rating,
    required this.votes,
    required this.watchlist,
    this.isWatchlist = false,
  });
}
