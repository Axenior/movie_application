import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:movie_application/components/BottomNavigationBarComponent.dart';
import 'package:movie_application/controllers/movie_controller.dart';
import 'package:movie_application/controllers/navigation_controller.dart';
import 'package:movie_application/data/movie_data.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final MovieController mc = Get.find();
  final NavigationController nc = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Movieku",
        ),
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
          const SizedBox(
            width: 10,
          )
        ],
      ),
      bottomNavigationBar: const BottomNavigationBarComponent(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(
                thickness: 0.2,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
                child: SizedBox(
                  height: 30,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SearchBar(
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
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Text(
                  "Daftar Film",
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 8, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        padding: const EdgeInsets.all(12),
                        minimumSize: Size.zero,
                      ),
                      onPressed: () {},
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
                        padding: const EdgeInsets.all(12),
                        minimumSize: Size.zero,
                      ),
                      onPressed: () {},
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
              const Divider(
                thickness: 0.2,
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
                itemCount: movieList.length,
                options: CarouselOptions(
                  viewportFraction: 0.5,
                  autoPlay: true,
                  height: 300,
                  onPageChanged: (index, reason) {
                    mc.setActiveMovie(movieList[index]);
                  },
                ),
                itemBuilder: (context, index, realIdx) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed("/detail-movie",
                            arguments: movieList[index]);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: movieList[index].poster,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              Obx(
                () {
                  return Container(
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
                              mc.activeMovie.value.title.toUpperCase(),
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
                                    text: mc.activeMovie.value.rating
                                        .toStringAsFixed(1),
                                    style:
                                        Theme.of(context).textTheme.labelSmall,
                                  ),
                                  const TextSpan(
                                    text: " lho, penasaran ngga sebagus apa?",
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
