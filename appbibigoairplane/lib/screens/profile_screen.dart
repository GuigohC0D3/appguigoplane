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
      setState(() => _imageFile = File(pickedFile.path));
      await _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    try {
      if (user != null && _imageFile != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_pictures/${user!.uid}.jpg');

        await storageRef.putFile(_imageFile!);
        final downloadURL = await storageRef.getDownloadURL();

        if (!mounted) return;
        setState(() => _downloadURL = downloadURL);

        await user!.updatePhotoURL(downloadURL);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .update({'photoURL': downloadURL});
      }
    } catch (e) {
      debugPrint('Erro ao fazer upload da imagem: $e');
    }
  }

  Future<void> _changeDisplayName() async {
    final nameController = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Editar nome'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: 'Novo nome'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newName = nameController.text.trim();
              final currentUser = FirebaseAuth.instance.currentUser;

              if (newName.isNotEmpty && currentUser != null) {
                try {
                  await currentUser.updateDisplayName(newName);
                  await currentUser.reload();

                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(currentUser.uid)
                      .update({'displayName': newName});

                  if (!mounted) return;
                  setState(() {});
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Sucesso'),
                      content: const Text('Seu nome foi alterado com sucesso.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                } catch (e) {
                  debugPrint('Erro ao atualizar o nome: $e');
                  if (!mounted) return;
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Erro'),
                      content: Text('Erro: $e'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _resetPassword() async {
    if (user?.email != null) {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: user!.email!);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email de redefinição de senha enviado.'),
        ),
      );
    }
  }

  String _getDisplayName() {
    if (user?.displayName != null && user!.displayName!.isNotEmpty) {
      return user!.displayName!;
    } else if (user?.email != null) {
      return user!.email!.split('@').first;
    } else {
      return 'Usuário';
    }
  }

  @override
  Widget build(BuildContext context) {
    const themeColor = Color(0xFF094067);
    const backgroundColor = Color(0xFFd8eefe);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        backgroundColor: themeColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: _downloadURL != null
                        ? NetworkImage(_downloadURL!)
                        : const AssetImage('assets/avatar_placeholder.png')
                    as ImageProvider,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _getDisplayName(),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF094067),
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              user?.email ?? '',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildButton(
              onPressed: _changeDisplayName,
              label: 'Editar Nome',
              icon: Icons.edit,
              color: themeColor,
            ),
            const SizedBox(height: 16),
            _buildButton(
              onPressed: _resetPassword,
              label: 'Redefinir Senha',
              icon: Icons.lock_reset,
              color: Colors.orange,
            ),
            const SizedBox(height: 16),
            _buildButton(
              onPressed: _signOut,
              label: 'Sair da Conta',
              icon: Icons.logout,
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required VoidCallback onPressed,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
