import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_application/models/genre.dart';
import 'package:movie_application/models/movie_list.dart';
import 'package:movie_application/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();

  List<Genre> _genres = [];
  List<MovieList> _trendingMovies = [];
  List<MovieList> _moviesByCategory = [];

  bool _isLoadingTrendingMovies = true;

  MovieList? activeMovie;
  Genre? selectedButton;

  Future<void> _loadData() async {
    final List<Map<String, dynamic>> genresData =
        await _apiService.getListGenre();
    final List<Map<String, dynamic>> trendingMoviesData =
        await _apiService.getTrendingMovies();

    setState(() {
      _isLoadingTrendingMovies = false;
      _genres = genresData.map((e) => Genre.fromJson(e)).toList();
      _trendingMovies =
          trendingMoviesData.map((e) => MovieList.fromJson(e)).toList();
    });
    activeMovie = _trendingMovies[0];
    selectedButton = _genres[0];

    final List<Map<String, dynamic>> moviesByCategoryData =
        await _apiService.getMoviesByCategory(selectedButton!.id);
    setState(() {
      _moviesByCategory =
          moviesByCategoryData.map((e) => MovieList.fromJson(e)).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CineMate"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications,
              size: 25,
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
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color.fromARGB(255, 97, 96, 96),
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
                      label: const Text(
                        "Watchlist Saya",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 15,
                  right: 15,
                  bottom: 10,
                ),
                child: Text(
                  "Rekomendasi Kami",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _isLoadingTrendingMovies
                  ? const Center(child: CircularProgressIndicator())
                  : CarouselSlider.builder(
                      itemCount: _trendingMovies.length,
                      options: CarouselOptions(
                        enlargeCenterPage: true,
                        viewportFraction: 0.5,
                        autoPlay: true,
                        height: 300,
                        onPageChanged: (index, reason) {
                          setState(() {
                            activeMovie = _trendingMovies[index];
                          });
                        },
                      ),
                      itemBuilder: (context, index, realIdx) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/detail-movie',
                                  arguments: _trendingMovies[index].id);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      'https://image.tmdb.org/t/p/w500${_trendingMovies[index].poster_path}',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
              _isLoadingTrendingMovies
                  ? const SizedBox.shrink()
                  : Container(
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 220, 218, 241),
                              Colors.white
                            ],
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
                                activeMovie!.title.toUpperCase(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 42, 41, 52),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text.rich(
                                textAlign: TextAlign.center,
                                TextSpan(
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 11, 3, 50),
                                    fontSize: 12,
                                  ),
                                  children: [
                                    const TextSpan(
                                      text: "Rating film ini ",
                                    ),
                                    const WidgetSpan(
                                      child: Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 15,
                                      ),
                                    ),
                                    TextSpan(
                                      text: activeMovie!.vote_average
                                          .toStringAsFixed(1),
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 11, 3, 50),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: ", lagi trending akhir-akhir ini.",
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
                child: Text(
                  "Kategori Genre",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
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
                    itemCount: _genres.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: (selectedButton == _genres[index]
                                  ? Colors.amber
                                  : Colors.grey),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 10,
                            ),
                            minimumSize: Size.zero,
                          ),
                          onPressed: () {
                            _setData(_genres[index]);
                          },
                          child: Text(
                            _genres[index].name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
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
                  itemCount: _moviesByCategory.length,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/detail-movie',
                            arguments: _moviesByCategory[index].id,
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
                                  imageUrl:
                                      'https://image.tmdb.org/t/p/w500${_moviesByCategory[index].poster_path}',
                                  fit: BoxFit.cover,
                                  height: 200,
                                  width: 135,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                _moviesByCategory[index].title.toUpperCase(),
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

  void _setData(Genre query) async {
    final List<Map<String, dynamic>> moviesByCategoryData =
        await _apiService.getMoviesByCategory(query.id);
    setState(() {
      selectedButton = query;
      _moviesByCategory =
          moviesByCategoryData.map((e) => MovieList.fromJson(e)).toList();
    });
  }
}
