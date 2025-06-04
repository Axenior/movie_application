import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_application/models/movie.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_application/services/api_service.dart';
import 'package:movie_application/services/watchlist_service.dart';

class DetailScreen extends StatefulWidget {
  final int movieId;
  const DetailScreen({super.key, required this.movieId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final ApiService _apiService = ApiService();
  final WatchlistService _watchlistService = WatchlistService();
  bool _isInWatchlist = false;

  late Movie _movie;

  bool _isLoading = true;

  Future<void> _loadMovie() async {
    final Map<String, dynamic> movieData =
        await _apiService.getMovieDetail(widget.movieId);
    setState(() {
      _movie = Movie.fromJson(movieData);
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadMovie();
    _checkWatchlistStatus();
  }

  Future<void> _checkWatchlistStatus() async {
    if (!mounted) return;

    setState(() {});

    try {
      _isInWatchlist =
          await _watchlistService.isMovieInWatchlist(widget.movieId.toString());
    } catch (e) {
      print('Gagal mengecek status watchlist: $e');
      _showSnackBar(
          'Gagal mengecek status watchlist: ${e.toString().split(':')[1].trim()}',
          isError: true);
    } finally {
      if (mounted) {
        setState(() {});
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Film"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(thickness: 0.2),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Poster Film
                          SizedBox(
                            width: 125,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl:
                                    'https://image.tmdb.org/t/p/w500${_movie.poster_path}',
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),

                          // Detail Film
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _movie.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      width: 85,
                                      child: Text(
                                        "Genre",
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        _movie.genres
                                            .map((genre) => genre.name)
                                            .join(', '),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      width: 85,
                                      child: Text(
                                        "Durasi",
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "${_movie.runtime} menit",
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      width: 85,
                                      child: Text(
                                        "Bahasa",
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        _movie.original_language,
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      width: 85,
                                      child: Text(
                                        "Tanggal Rilis",
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        _movie.release_date.toString(),
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(thickness: 0.2),
                    // Divider with color
                    SizedBox(
                      height: 60,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: GestureDetector(
                              onTap: () {},
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _movie.vote_average.toStringAsFixed(1),
                                        style: const TextStyle(
                                          fontSize: 22,
                                          color: Colors.amber,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      RatingBarIndicator(
                                        rating: _movie.vote_average / 2,
                                        direction: Axis.horizontal,
                                        itemCount: 5,
                                        itemSize: 18,
                                        itemPadding: const EdgeInsets.symmetric(
                                            horizontal: 1),
                                        itemBuilder: (context, index) =>
                                            const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${_movie.vote_count} Vote",
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_right_sharp,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                            child: VerticalDivider(
                              thickness: 0.2,
                              width: 20,
                            ),
                          ),
                          _isInWatchlist
                              ? Flexible(
                                  child: InkWell(
                                    onTap: () {
                                      setState(
                                        () {
                                          _watchlistService
                                              .removeMovieFromWatchlist(
                                                  _movie.id.toString());
                                          _isInWatchlist = false;
                                        },
                                      );
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.favorite,
                                              color: Colors.pink,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "Masukkan watchlist",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          "Popularity : ${_movie.popularity}",
                                          style: const TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Flexible(
                                  child: InkWell(
                                    onTap: () {
                                      setState(
                                        () {
                                          _watchlistService.addMovieToWatchlist(
                                              _movie.id.toString());
                                          _isInWatchlist = true;
                                        },
                                      );
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.favorite_outline,
                                              color: Colors.pink,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "Masukkan watchlist",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          "Popularity : ${_movie.popularity}",
                                          style: const TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                    const Divider(thickness: 0.2),
                    // Sinopsis
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "Sinopsis",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        _movie.overview,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
