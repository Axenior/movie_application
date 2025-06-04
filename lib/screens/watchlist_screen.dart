import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_application/models/movie_list.dart';
import 'package:movie_application/services/api_service.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  final ApiService _apiService = ApiService();

  List<MovieList> _movieWatchlist = [];

  Future<void> _loadWatchlist() async {
    final List<Map<String, dynamic>> movieData =
        await _apiService.getMoviesWatchlist();
    setState(() {
      _movieWatchlist = movieData.map((e) => MovieList.fromJson(e)).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadWatchlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Watchlist"),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(thickness: 0.2),
        ),
      ),
      body: _movieWatchlist.isEmpty
          ? Center(
              child: Text(
                "Kamu belum memiliki movie favorit.",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                ),
              ),
            )
          : SingleChildScrollView(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _movieWatchlist.length,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 20,
                      childAspectRatio: 2 / 3.8,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/detail-movie',
                                  arguments: _movieWatchlist[index].id)
                              .then(
                            (value) => setState(
                              () {
                                _loadWatchlist();
                              },
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              alignment: Alignment.topRight,
                              children: [
                                AspectRatio(
                                  aspectRatio: 2 / 3,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          'https://image.tmdb.org/t/p/w500${_movieWatchlist[index].poster_path}',
                                      fit: BoxFit.cover,
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _movieWatchlist[index].title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating:
                                      _movieWatchlist[index].vote_average / 2,
                                  direction: Axis.horizontal,
                                  itemCount: 5,
                                  itemSize: 12,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _movieWatchlist[index]
                                      .vote_average
                                      .toStringAsFixed(1),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
    );
  }
}
