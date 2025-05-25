import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _imageFile;
  String? _downloadURL;
  final picker = ImagePicker();
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadProfilePhoto();
  }

  Future<void> _loadProfilePhoto() async {
    if (user?.photoURL != null) {
      setState(() {
        _downloadURL = user!.photoURL;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      await _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    try {
      if (user != null && _imageFile != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_pictures')
            .child('${user!.uid}.jpg');

        await storageRef.putFile(_imageFile!);
        final downloadURL = await storageRef.getDownloadURL();

        setState(() {
          _downloadURL = downloadURL;
        });

        await user!.updatePhotoURL(downloadURL);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .update({'photoURL': downloadURL});
      }
    } catch (e) {
      print('Erro ao fazer upload da imagem: $e');
    }
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: CircleAvatar(
            radius: 50,
            backgroundImage: _downloadURL != null
                ? NetworkImage(_downloadURL!)
                : const AssetImage('assets/avatar_placeholder.png')
                    as ImageProvider,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          user?.displayName ?? 'Usuário',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          user?.email ?? '',
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.camera_alt),
          label: const Text('Alterar Foto de Perfil'),
        ),
      ],
    );
  }

  Widget _buildTravelHistory() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('travel_history')
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Erro ao carregar histórico.'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final trips = snapshot.data!.docs;

        if (trips.isEmpty) {
          return const Center(child: Text('Nenhuma viagem encontrada.'));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: trips.length,
          itemBuilder: (context, index) {
            final trip = trips[index];
            return ListTile(
              leading: const Icon(Icons.flight),
              title: Text(trip['destination']),
              subtitle: Text(trip['date']),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: const Color(0xFF094067),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Histórico de Viagens',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF094067),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildTravelHistory(),
          ],
        ),
      ),
    );
  }
}
