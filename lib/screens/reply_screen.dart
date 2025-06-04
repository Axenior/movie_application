import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ReplyScreen extends StatefulWidget {
  final String postId;

  const ReplyScreen({super.key, required this.postId});

  @override
  State<ReplyScreen> createState() => _ReplyScreenState();
}

class _ReplyScreenState extends State<ReplyScreen> {
  final TextEditingController _replyController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool _isSendingReply = false;

  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('dd MMMyyyy, HH:mm').format(dateTime);
  }

  Future<void> _sendReply() async {
    if (_replyController.text.trim().isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Balasan tidak boleh kosong.')));
      }
      return;
    }

    setState(() {
      _isSendingReply = true;
    });

    try {
      final User? currentUser = _firebaseAuth.currentUser;
      if (currentUser == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Anda harus login untuk membalas.')));
        }
        setState(() {
          _isSendingReply = false;
        });
        return;
      }

      String? usernameToUse;
      try {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(currentUser.uid).get();
        if (userDoc.exists && userDoc.data() != null) {
          Map<String, dynamic> userData =
              userDoc.data() as Map<String, dynamic>;
          usernameToUse = userData['username'] as String;
        }
      } catch (e) {
        print('Error fetching custom username for reply: $e');
      }
      usernameToUse ??= 'Anonymous';

      await _firestore
          .collection('posts')
          .doc(widget.postId)
          .collection('replies')
          .add({
        'userId': currentUser.uid,
        'username': usernameToUse,
        'replyText': _replyController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      await _firestore.collection('posts').doc(widget.postId).update({
        'repliesCount': FieldValue.increment(1),
      });

      _replyController.clear();
      if (mounted) {
        setState(() {
          _isSendingReply = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSendingReply = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal mengirim balasan: $e')));
        print('Reply Error: $e');
      }
    }
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Balasan Postingan'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('posts')
                  .doc(widget.postId)
                  .collection('replies')
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
                  return const Center(child: Text('Belum ada balasan.'));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot replyDoc = snapshot.data!.docs[index];
                    Map<String, dynamic> reply =
                        replyDoc.data() as Map<String, dynamic>;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 14,
                                  child: Icon(Icons.person, size: 16),
                                ),
                                const SizedBox(width: 8),
                                FutureBuilder<DocumentSnapshot>(
                                  future: _firestore
                                      .collection('users')
                                      .doc(reply['userId'])
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
                                          reply['username'] as String? ??
                                              'Pengguna';
                                      print(
                                          'Error fetching user for reply: ${userSnapshot.error}');
                                    } else if (userSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      displayedUsername = '';
                                    }
                                    return Text(
                                      displayedUsername,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    );
                                  },
                                ),
                                const SizedBox(width: 8),
                                if (reply['timestamp'] != null)
                                  Text(
                                    _formatTimestamp(reply['timestamp']),
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 11),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(reply['replyText'] ?? ''),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _replyController,
                    decoration: InputDecoration(
                      hintText: 'Tulis balasan Anda...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                    ),
                    minLines: 1,
                    maxLines: 5,
                  ),
                ),
                const SizedBox(width: 8),
                _isSendingReply
                    ? const CircularProgressIndicator()
                    : FloatingActionButton(
                        onPressed: _sendReply,
                        mini: true,
                        child: const Icon(Icons.send),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
