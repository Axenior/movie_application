import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_application/data/movie_data.dart';
import 'package:movie_application/models/movie.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Movie> data = [];
  final SearchController _controller = SearchController();
  String _searchQuery = '';
  bool isSubmited = false;

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
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
                child: SizedBox(
                  height: 30,
                  child: Expanded(
                    child: SearchBar(
                      controller: _controller,
                      onTap: _onTap,
                      onChanged: _onSearchChanged,
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
              isSubmited && data.isEmpty
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
                  itemCount: data.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 20,
                    childAspectRatio: 2 / 4.2,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/detail-movie',
                                arguments: data[index])
                            .then((value) => setState(() {}));
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
                                    imageUrl: data[index].poster,
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    data[index].isWatchlist =
                                        !data[index].isWatchlist;
                                    data[index].watchlist =
                                        data[index].isWatchlist
                                            ? data[index].watchlist + 1
                                            : data[index].watchlist - 1;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white),
                                      shape: BoxShape.circle,
                                      color:
                                          Colors.grey.shade900.withOpacity(0.4),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Icon(
                                        Icons.favorite,
                                        color: data[index].isWatchlist
                                            ? Colors.pink
                                            : Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            data[index].title,
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
                              Container(
                                color: Colors.grey.shade400,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  data[index].rated,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  data[index].genre,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              RatingBarIndicator(
                                rating: data[index].rating / 2,
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
                                data[index].rating.toStringAsFixed(1),
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

  // This function handles text changes in the search bar
  void _onSearchChanged(String query) {
    setState(() {
      data = movieList
          .where((Movie movie) =>
              movie.title.toLowerCase().contains(query.toLowerCase()))
          .toList();
      if (query == '') {
        data = [];
      }
    });
  }

  void _onSubmitted(String query) {
    setState(() {
      isSubmited = true;
    });
  }
}
