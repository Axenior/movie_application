import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WatchlistService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addMovieToWatchlist(String movieId) async {
    User? user = _auth.currentUser;
    if (user == null) {
      print('Error: Pengguna tidak login.');
      throw Exception('User not logged in');
    }
    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('watchlist')
          .doc(movieId)
          .set({
        'timestampAdded': Timestamp.now(),
      });
      print('Film berhasil ditambahkan ke watchlist!');
    } catch (e) {
      print('Error menambahkan film ke watchlist: $e');
      rethrow;
    }
  }

  Future<void> removeMovieFromWatchlist(String movieId) async {
    User? user = _auth.currentUser;
    if (user == null) {
      print('Error: Pengguna tidak login.');
      throw Exception('User not logged in');
    }
    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('watchlist')
          .doc(movieId)
          .delete();
      print('Film dengan ID $movieId berhasil dihapus dari watchlist!');
    } catch (e) {
      print('Error menghapus film dari watchlist: $e');
      rethrow;
    }
  }

  Future<bool> isMovieInWatchlist(String movieId) async {
    User? user = _auth.currentUser;
    if (user == null) {
      return false;
    }
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('watchlist')
          .doc(movieId)
          .get();
      return doc.exists;
    } catch (e) {
      print('Error memeriksa watchlist: $e');
      return false;
    }
  }

  Future<List<String>> getWatchlist() async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) {
        return [];
      }

      QuerySnapshot watchlistSnapshot = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('watchlist')
          .get();

      return watchlistSnapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print('Error getting watchlist: $e');
      return [];
    }
  }
}
