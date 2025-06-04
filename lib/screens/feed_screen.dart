import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:movie_application/screens/login_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:movie_application/screens/add_post_screen.dart';
import 'package:movie_application/screens/reply_screen.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('dd MMMyyyy, HH:mm').format(dateTime);
  }

  Future<void> _openMap(double latitude, double longitude) async {
    final uri = Uri.parse(
      'http://maps.google.com/?q=$latitude,$longitude',
    );

    if (!mounted) return;

    try {
      final success =
          await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tidak bisa membuka Google Maps')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error membuka peta: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed Postingan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('posts')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
                child: Text('Belum ada postingan. Ayo buat satu!'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot postDoc = snapshot.data!.docs[index];
              Map<String, dynamic> post =
                  postDoc.data() as Map<String, dynamic>;

              final double? lat = post['latitude'] as double?;
              final double? lon = post['longitude'] as double?;

              return Card(
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FutureBuilder<DocumentSnapshot>(
                                future: _firestore
                                    .collection('users')
                                    .doc(post['userId'])
                                    .get(),
                                builder: (context, userSnapshot) {
                                  String displayedUsername = 'Pengguna';
                                  if (userSnapshot.connectionState ==
                                          ConnectionState.done &&
                                      userSnapshot.hasData &&
                                      userSnapshot.data!.exists) {
                                    final userData = userSnapshot.data!.data()
                                        as Map<String, dynamic>;
                                    displayedUsername =
                                        userData['username'] as String? ??
                                            userData['email'] as String? ??
                                            'Pengguna';
                                  } else if (userSnapshot.hasError) {
                                    displayedUsername =
                                        post['username'] as String? ??
                                            'Pengguna';
                                    print(
                                        'Error fetching user for post: ${userSnapshot.error}');
                                  } else if (userSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    displayedUsername = 'Memuat...';
                                  }
                                  return Text(
                                    displayedUsername,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  );
                                },
                              ),
                              if (post['timestamp'] != null)
                                Text(
                                  _formatTimestamp(post['timestamp']),
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (post['imageUrl'] != null &&
                          post['imageUrl'].isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Image.network(
                            post['imageUrl'],
                            fit: BoxFit.contain,
                            width: double.infinity,
                            height: 250.0,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                      Text(
                        post['caption'] ?? '',
                        style: const TextStyle(fontSize: 15),
                      ),
                      const SizedBox(height: 8),
                      if (lat != null && lon != null)
                        TextButton.icon(
                          onPressed: () => _openMap(lat, lon),
                          icon: const Icon(Icons.location_on, size: 16),
                          label: const Text(
                            'Lokasi',
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 12,
                                decoration: TextDecoration.underline),
                          ),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            alignment: Alignment.centerLeft,
                          ),
                        ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Replies: ${post['repliesCount'] ?? 0}'),
                          TextButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ReplyScreen(postId: postDoc.id),
                                ),
                              );
                            },
                            icon: const Icon(Icons.reply),
                            label: const Text('Reply'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPostScreen()),
          );
        },
        tooltip: 'Tambah Postingan',
        child: const Icon(Icons.add),
      ),
    );
  }
}
