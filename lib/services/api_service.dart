import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_application/models/genre.dart';
import 'package:movie_application/services/watchlist_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "https://api.themoviedb.org/3";
  static const String apiKey = "53be5525b136752893a2aa6ca333da6e";

  Future<List<Map<String, dynamic>>> getListGenre() async {
    final response =
        await http.get(Uri.parse("$baseUrl/genre/movie/list?api_key=$apiKey"));
    final data = json.decode(response.body);
    return List<Map<String, dynamic>>.from(data['genres']);
  }

  Future<List<Map<String, dynamic>>> getTrendingMovies() async {
    final response = await http
        .get(Uri.parse("$baseUrl/trending/movie/week?api_key=$apiKey"));
    final data = json.decode(response.body);
    return List<Map<String, dynamic>>.from(data['results']);
  }

  Future<List<Map<String, dynamic>>> getMoviesByCategory(int genreId) async {
    final response = await http.get(Uri.parse(
        "$baseUrl/discover/movie?api_key=$apiKey&with_genres=$genreId"));
    final data = json.decode(response.body);
    return List<Map<String, dynamic>>.from(data['results']);
  }

  Future<Map<String, dynamic>> getMovieDetail(int movieId) async {
    final response =
        await http.get(Uri.parse("$baseUrl/movie/$movieId?api_key=$apiKey"));
    final data = json.decode(response.body);
    return Map<String, dynamic>.from(data);
  }

  Future<List<Map<String, dynamic>>> searchMovie(String title) async {
    final response = await http
        .get(Uri.parse("$baseUrl/search/movie?api_key=$apiKey&query=$title"));
    final data = json.decode(response.body);
    return List<Map<String, dynamic>>.from(data["results"]);
  }

  Future<List<Map<String, dynamic>>> getMoviesWatchlist() async {
    WatchlistService _watchlistService = WatchlistService();
    final List<String> watchlist = await _watchlistService.getWatchlist() ?? [];

    List<Map<String, dynamic>> movies = [];

    for (String id in watchlist) {
      final response =
          await http.get(Uri.parse("$baseUrl/movie/$id?api_key=$apiKey"));
      final data = json.decode(response.body);
      movies.add(data);
    }

    return movies;
  }
}
