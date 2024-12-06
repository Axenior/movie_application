import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_application/data/movie_data.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:movie_application/models/movie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Movie> data = [];
  late List<Movie> sortedMovie;
  late Movie activeMovie;

  final List<String> buttonLabels = [
    "Aksi",
    "Petualangan",
    "Fiksi Ilmiah",
    "Keluarga",
    "Komedi",
    "Animasi",
  ];

  String selectedButton = "Aksi";

  @override
  void initState() {
    super.initState();
    sortedMovie = movieList.toList();
    sortedMovie.sort((a, b) => b.rating.compareTo(a.rating));
    sortedMovie = sortedMovie.take(5).toList();
    activeMovie = sortedMovie[0];

    _setData(selectedButton);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Movieku"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications,
              size: 25,
              color: Theme.of(context).colorScheme.primary,
            ),
            padding: EdgeInsets.zero,
          ),
          const SizedBox(width: 10)
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(thickness: 0.2),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Text(
                  "Daftar Film",
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        minimumSize: Size.zero,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/list-movie');
                      },
                      child: Text(
                        "Semua Film",
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        minimumSize: Size.zero,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/watchlist-movie');
                      },
                      icon: const Icon(
                        Icons.favorite_outline,
                        size: 15,
                        color: Colors.pink,
                      ),
                      label: Text(
                        "Watchlist Saya",
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  bottom: 10,
                ),
                child: Text(
                  "Rekomendasi Kami",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              CarouselSlider.builder(
                itemCount: sortedMovie.length,
                options: CarouselOptions(
                  enlargeCenterPage: true,
                  viewportFraction: 0.5,
                  autoPlay: true,
                  height: 300,
                  onPageChanged: (index, reason) {
                    setState(() {
                      activeMovie = sortedMovie[index]; // Update active movie
                    });
                  },
                ),
                itemBuilder: (context, index, realIdx) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/detail-movie',
                            arguments: sortedMovie[index]);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: sortedMovie[index].poster,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 220, 218, 241),
                        Colors.white
                      ], // Warna gradasi
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        Text(
                          activeMovie.title.toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        Text.rich(
                          textAlign: TextAlign.center,
                          TextSpan(
                            style: Theme.of(context).textTheme.bodySmall,
                            children: [
                              const TextSpan(
                                text: "Rating film ini ",
                              ),
                              const WidgetSpan(
                                child: Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 15, // Icon size
                                ),
                              ),
                              TextSpan(
                                text: activeMovie.rating.toStringAsFixed(1),
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              const TextSpan(
                                text: " lho, penasaran ngga sebagus apa?",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
                child: Text(
                  "Kategori Genre",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 5,
                  right: 5,
                  bottom: 10,
                ),
                child: SizedBox(
                  height: 30,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: buttonLabels.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor:
                                (selectedButton == buttonLabels[index]
                                    ? const Color.fromARGB(255, 220, 218, 241)
                                    : null),
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 10,
                            ),
                            minimumSize: Size.zero,
                          ),
                          onPressed: () {
                            _setData(buttonLabels[index]);
                          },
                          child: Text(
                            buttonLabels[index],
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: data.length,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/detail-movie',
                            arguments: data[index],
                          );
                        },
                        child: Container(
                          width: 135,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: data[index].poster,
                                  fit: BoxFit.cover,
                                  height: 200,
                                  width: 135,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                data[index].title.toUpperCase(),
                                textAlign: TextAlign.start,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _setData(String query) {
    setState(() {
      selectedButton = query;
      data = movieList
          .where((Movie movie) => movie.genre.contains(query))
          .toList();
    });
  }
}
