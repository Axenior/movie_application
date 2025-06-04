import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_application/screens/login_screen.dart';
import 'package:movie_application/theme_notifier.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _name = "Memuat...";
  String _email = "Memuat...";
  String _phoneNumber = "Tidak ada nomor";
  String _address = "Tidak ada alamat";

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final User? currentUser = _firebaseAuth.currentUser;

    if (currentUser == null) {
      if (mounted) {
        setState(() {
          _name = "Guest User";
          _email = "Tidak login";
          _phoneNumber = "Tidak ada nomor";
          _address = "Tidak ada alamat";
        });
      }
      return;
    }

    String fetchedEmail = currentUser.email ?? "Email tidak tersedia";
    String fetchedName = "Pengguna";
    String fetchedPhoneNumber = "Tidak ada nomor";
    String fetchedAddress = "Tidak ada alamat";

    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();
      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        fetchedName = userData['username'] as String? ?? fetchedName;
        fetchedPhoneNumber =
            userData['phoneNumber'] as String? ?? fetchedPhoneNumber;
        fetchedAddress = userData['address'] as String? ?? fetchedAddress;
      }
    } catch (e) {
      print('Error fetching user profile from Firestore: $e');
    }

    if (mounted) {
      setState(() {
        _name = fetchedName;
        _email = fetchedEmail;
        _phoneNumber = fetchedPhoneNumber;
        _address = fetchedAddress;
      });
    }
  }

  void _editProfile() {
    TextEditingController nameController = TextEditingController(text: _name);
    TextEditingController phoneController =
        TextEditingController(text: _phoneNumber);
    TextEditingController addressController =
        TextEditingController(text: _address);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Profile"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Username",
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: "Address",
                ),
                maxLines: 2,
                keyboardType: TextInputType.streetAddress,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!mounted) return;

                String newName = nameController.text.trim();
                String newPhoneNumber = phoneController.text.trim();
                String newAddress = addressController.text.trim();

                if (newName.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Username tidak boleh kosong.')),
                  );
                  return;
                }

                setState(() {
                  _name = newName;
                  _phoneNumber = newPhoneNumber;
                  _address = newAddress;
                });

                final User? currentUser = _firebaseAuth.currentUser;
                if (currentUser != null) {
                  try {
                    await _firestore
                        .collection('users')
                        .doc(currentUser.uid)
                        .set(
                      {
                        'username': newName,
                        'email': currentUser.email,
                        'phoneNumber': newPhoneNumber,
                        'address': newAddress,
                      },
                      SetOptions(merge: true),
                    );
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Profil berhasil diperbarui!')),
                      );
                    }
                  } catch (e) {
                    print('Error updating profile: $e');
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Gagal memperbarui profil: $e')),
                      );
                    }
                  }
                }

                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _logout() async {
    try {
      await _firebaseAuth.signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      print('Error logging out: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal logout: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkMode = themeNotifier.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircleAvatar(
                radius: 60,
                child: Icon(Icons.person, size: 60),
              ),
            ),
            Text(
              _name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _email,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.color
                    ?.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(
                isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
                color: isDarkMode ? Colors.yellow : Colors.black,
              ),
              title: const Text('Dark Mode'),
              trailing: Switch(
                value: isDarkMode,
                onChanged: (value) {
                  themeNotifier.toggleTheme(value);
                },
                activeColor: Theme.of(context).primaryColor,
              ),
              tileColor: Theme.of(context).cardColor,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.phone_outlined),
              title: const Text('Phone Number'),
              subtitle: Text(_phoneNumber),
            ),
            ListTile(
              leading: const Icon(Icons.location_on_outlined),
              title: const Text('Address'),
              subtitle: Text(_address),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton.icon(
                    onPressed: _editProfile,
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Profile'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).cardColor,
                      foregroundColor:
                          Theme.of(context).textTheme.bodyLarge?.color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
