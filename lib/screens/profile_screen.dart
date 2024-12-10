import 'package:flutter/material.dart';
import 'package:movie_application/screens/login_screen.dart'; // Ganti dengan path layar login Anda

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = "John Doe";
  String email = "johndoe@example.com";

  void _editProfile() {
    TextEditingController nameController = TextEditingController(text: name);
    TextEditingController emailController = TextEditingController(text: email);

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
                  labelText: "Name",
                ),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Tutup dialog
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  name = nameController.text;
                  email = emailController.text;
                });
                Navigator.pop(context); // Tutup dialog
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  void _logout() {
    // Misalnya menghapus data pengguna atau token otentikasi
    // Contoh: await SharedPreferences.getInstance().then((prefs) => prefs.clear());

    // Setelah logout, arahkan pengguna ke layar login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()), // Pastikan Anda memiliki LoginScreen
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 170, 168, 156),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Foto Profil
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('images/profile.jpg'),
              ),
            ),
            // Nama Pengguna
            Text(
              name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Email Pengguna
            Text(
              email,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            // Informasi Lain
            const ListTile(
              leading: Icon(Icons.phone, color: Colors.black),
              title: Text('Phone Number'),
              subtitle: Text('+62 123 456 7890'),
            ),
            const ListTile(
              leading: Icon(Icons.location_on, color: Colors.black),
              title: Text('Address'),
              subtitle: Text('123 Main Street, Jakarta'),
            ),
            const Divider(),
            // Tombol Aksi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: _editProfile, // Fungsi edit profile
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Profile'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _logout, // Fungsi logout
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
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
