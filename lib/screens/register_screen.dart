import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_application/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/bg_login.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Text(
                "Buat Akun Baru",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: "Username",
                        hintText: "Masukkan username Anda",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                        ),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Username tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        hintText: "xxx@gmail.com",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                        ),
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !_isValidEmail(value)) {
                          return 'Masukkan email yang valid';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: "Password",
                        hintText: "Masukkan password",
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                        ),
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password tidak boleh kosong';
                        }
                        if (value.length < 6) {
                          return 'Password minimal 6 karakter';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        labelText: "Konfirmasi Password",
                        hintText: "Masukkan kembali password",
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                        ),
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Konfirmasi password tidak boleh kosong';
                        }
                        if (value != _passwordController.text) {
                          return 'Password tidak cocok';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _isLoading
                        ? const SizedBox(
                            width: 30,
                            height: 30,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _registerUser,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade100,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text(
                                "Daftar",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Sudah punya akun? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _registerUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    setState(() => _isLoading = true);

    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'username': username,
        'email': email,
        'createdAt': Timestamp.now(),
      });

      _showSuccessMessage(
          'Registrasi berhasil! Silakan login untuk melanjutkan.');

      await FirebaseAuth.instance.signOut();

      if (mounted) {
        setState(() => _isLoading = false);
      }

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (error) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      _showErrorMessage(_getAuthErrorMessage(error.code));
    } catch (error) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
      _showErrorMessage('Terjadi kesalahan: $error');
    }
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  bool _isValidEmail(String email) {
    String emailRegex =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$";
    return RegExp(emailRegex).hasMatch(email);
  }

  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'weak-password':
        return 'Password terlalu lemah. Harap gunakan kombinasi yang lebih kuat.';
      case 'email-already-in-use':
        return 'Email ini sudah terdaftar. Silakan gunakan email lain atau login.';
      case 'invalid-email':
        return 'Format alamat email tidak valid.';
      case 'operation-not-allowed':
        return 'Pendaftaran email/password tidak diaktifkan. Hubungi administrator.';
      default:
        return 'Terjadi kesalahan saat mendaftar. Silakan coba lagi.';
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
