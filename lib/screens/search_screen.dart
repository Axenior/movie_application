import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_application/models/movie_list.dart';
import 'package:movie_application/services/api_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ApiService _apiService = ApiService();
  List<MovieList> _moviesBySearch = [];

  final SearchController _controller = SearchController();
  bool isSubmited = false;

  Future<void> _loadWatchlist() async {
    setState(() {});
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
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
                child: SizedBox(
                  height: 30,
                  child: Expanded(
                    child: SearchBar(
                      controller: _controller,
                      onTap: _onTap,
                      onSubmitted: _onSubmitted,
                      backgroundColor: const WidgetStatePropertyAll(
                        Color.fromARGB(125, 197, 197, 199),
                      ),
                      shadowColor:
                          const WidgetStatePropertyAll(Colors.transparent),
                      leading: Icon(
                        Icons.search,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      hintText: "Cari Film Favoritmu",
                      hintStyle: const WidgetStatePropertyAll(
                        TextStyle(
                          color: Color.fromARGB(255, 101, 100, 100),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              isSubmited && _moviesBySearch.isEmpty
                  ? Center(
                      child: Text(
                        "Movienya gak ada nih",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    )
                  : Container(),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _moviesBySearch.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 20,
                    childAspectRatio: 2 / 3.8,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/detail-movie',
                                arguments: _moviesBySearch[index].id)
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
                                        'https://image.tmdb.org/t/p/w500${_moviesBySearch[index].poster_path}',
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
                            _moviesBySearch[index].title,
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
                                rating: _moviesBySearch[index].vote_average / 2,
                                direction: Axis.horizontal,
                                itemCount: 5,
                                itemSize: 18,
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _moviesBySearch[index]
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
            ],
          ),
        ),
      ),
    );
  }

  void _onTap() {
    setState(() {
      isSubmited = false;
    });
  }

  void _onSubmitted(String title) async {
    final List<Map<String, dynamic>> moviesBySeacrh =
        await _apiService.searchMovie(title);
    setState(() {
      _moviesBySearch =
          moviesBySeacrh.map((e) => MovieList.fromJson(e)).toList();
    });

    setState(() {
      isSubmited = true;
    });
  }
}
