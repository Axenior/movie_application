import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase_sdk;
import 'package:flutter/foundation.dart' show kIsWeb;

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _captionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  dynamic _displayImage; // File untuk mobile, Uint8List untuk web
  File? _imageFileForUpload; // Hanya untuk mobile
  Uint8List? _imageBytesForUpload; // Hanya untuk web

  Position? _currentPosition;
  bool _isLoading = false;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final supabase_sdk.SupabaseClient supabase =
      supabase_sdk.Supabase.instance.client;

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _displayImage = bytes;
          _imageBytesForUpload = bytes;
          _imageFileForUpload = null;
        });
      } else {
        setState(() {
          _displayImage = File(pickedFile.path);
          _imageFileForUpload = File(pickedFile.path);
          _imageBytesForUpload = null;
        });
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true; // Set loading for location
    });
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Layanan lokasi dinonaktifkan.')));
      }
      setState(() {
        _isLoading = false;
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Izin lokasi ditolak.')));
        }
        setState(() {
          _isLoading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Izin lokasi ditolak secara permanen, kami tidak dapat meminta izin.')));
      }
      setState(() {
        _isLoading = false;
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
      _isLoading = false; // Stop loading for location
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Lokasi ditemukan: ${_currentPosition!.latitude.toStringAsFixed(4)}, ${_currentPosition!.longitude.toStringAsFixed(4)}')));
    }
  }

  Future<String?> _uploadImageToStorage() async {
    if (_imageFileForUpload == null && _imageBytesForUpload == null)
      return null;

    final String userId = _firebaseAuth.currentUser?.uid ?? 'anonymous';
    final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final String path = '$userId/$fileName';

    try {
      if (kIsWeb && _imageBytesForUpload != null) {
        await supabase.storage.from('postimages').uploadBinary(
              path,
              _imageBytesForUpload!,
              fileOptions: const supabase_sdk.FileOptions(upsert: false),
            );
      } else if (_imageFileForUpload != null) {
        await supabase.storage.from('postimages').upload(
              path,
              _imageFileForUpload!,
              fileOptions: const supabase_sdk.FileOptions(upsert: false),
            );
      } else {
        return null;
      }

      final String publicUrl =
          supabase.storage.from('postimages').getPublicUrl(path);
      return publicUrl;
    } catch (e) {
      print('Supabase Storage Upload Error: $e');
      rethrow;
    }
  }

  Future<void> _uploadPost() async {
    if (_captionController.text.trim().isEmpty && _displayImage == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Caption atau gambar harus diisi.')));
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String? imageUrl;
      if (_displayImage != null) {
        try {
          imageUrl = await _uploadImageToStorage();
        } catch (e) {
          print('Error uploading image to Supabase Storage: $e');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(
                    'Gagal mengunggah gambar. Postingan akan dibuat tanpa gambar.')));
          }
          imageUrl = null;
        }
      }

      final User? currentUser =
          _firebaseAuth.currentUser; // Gunakan Firebase Auth
      if (currentUser == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Anda harus login untuk mengunggah.')));
        }
        setState(() {
          _isLoading = false;
        });
        return;
      }

      await _firestore.collection('posts').add({
        'userId': currentUser.uid,
        'imageUrl': imageUrl,
        'caption': _captionController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
        'latitude': _currentPosition?.latitude,
        'longitude': _currentPosition?.longitude,
        'repliesCount': 0,
      });

      if (mounted) {
        _captionController.clear();
        setState(() {
          _displayImage = null;
          _imageFileForUpload = null;
          _imageBytesForUpload = null;
          _currentPosition = null;
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Postingan berhasil diunggah!')));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal mengunggah postingan: $e')));
        print('Upload Post Error: $e');
      }
    }
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Postingan Baru'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _displayImage != null
                      ? kIsWeb
                          ? Image.memory(
                              _displayImage!,
                              height: 200,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              _displayImage!,
                              height: 200,
                              fit: BoxFit.cover,
                            )
                      : Container(
                          height: 200,
                          color: Colors.grey[200],
                          child: Center(
                            child: Text(
                              'Pilih gambar untuk postingan Anda',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ),
                        ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.gallery),
                        icon: const Icon(Icons.photo_library),
                        label: const Text('Galeri'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _pickImage(ImageSource.camera),
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Kamera'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _captionController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Caption',
                      hintText: 'Tuliskan sesuatu tentang postingan Anda...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _getCurrentLocation,
                    icon: const Icon(Icons.location_on),
                    label: Text(
                      _currentPosition == null
                          ? 'Tambahkan Lokasi'
                          : 'Lokasi: ${_currentPosition!.latitude.toStringAsFixed(4)}, ${_currentPosition!.longitude.toStringAsFixed(4)}',
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _uploadPost,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Unggah Postingan',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
