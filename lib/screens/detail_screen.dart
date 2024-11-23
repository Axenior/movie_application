import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie_application/models/movie.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DetailScreen extends StatelessWidget {
  final Movie movie;
  const DetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Film"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const Divider(thickness: 0.2),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Poster Film
                        Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.shade200,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: movie.poster,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) =>
                                  const FaIcon(Icons.error),
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
                                movie.title,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 85,
                                    child: Text(
                                      "Genre",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      movie.genre,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 85,
                                    child: Text(
                                      "Durasi",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      movie.runTime,
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
                                  SizedBox(
                                    width: 85,
                                    child: Text(
                                      "Sutradara",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      movie.director,
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
                                  SizedBox(
                                    width: 85,
                                    child: Text(
                                      "Rating Usia",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      movie.rated,
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
                  const Divider(
                    thickness: 0.2,
                  ),
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
                                      movie.rating.toStringAsFixed(1),
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
                                      rating: movie.rating / 2,
                                      direction: Axis.horizontal,
                                      itemCount: 5,
                                      itemSize: 18,
                                      itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 1),
                                      itemBuilder: (context, index) =>
                                          const FaIcon(
                                        FontAwesomeIcons.solidStar,
                                        color: Colors.amber,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${movie.votes} Vote",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_right_sharp,
                                      color: Colors.grey.shade800,
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
                        Flexible(
                          child: GestureDetector(
                            onTap: () {},
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                  "${movie.watchlist} Orang",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade800,
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
                  const Divider(
                    thickness: 0.2,
                  ),
                  // Sinopsis
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Sinopsis",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      movie.plot,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
