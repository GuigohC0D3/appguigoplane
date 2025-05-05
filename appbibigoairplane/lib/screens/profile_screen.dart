import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  File? _profileImage;
  File? _bannerImage;

  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();

  String? name;
  String? email;
  String? uid;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      uid = user.uid;
      email = user.email;

      try {
        final doc = await _firestore.collection('users').doc(uid).get();
        final data = doc.data();

        if (data != null) {
          name = data['name'] ?? 'Sem nome';
          _addressController.text = data['address'] ?? '';
        } else {
          name = 'Usuário';
        }
      } catch (e) {
        print('Erro ao carregar dados do usuário: $e');
        name = 'Erro ao carregar';
      }

      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  Future<void> _saveAddress() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _firestore.collection('users').doc(uid).update({
          'address': _addressController.text.trim(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Endereço atualizado com sucesso!")),
        );
      } catch (e) {
        print('Erro ao salvar endereço: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erro ao salvar endereço")),
        );
      }
    }
  }

  Future<void> _pickImage(bool isBanner) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        setState(() {
          if (isBanner) {
            _bannerImage = File(picked.path);
          } else {
            _profileImage = File(picked.path);
          }
        });
      }
    } catch (e) {
      print('Erro ao selecionar imagem: $e');
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF00A896),
        title: const Text('Perfil'),
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        children: [
          // Banner
          GestureDetector(
            onTap: () => _pickImage(true),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.grey[300]),
                  child: _bannerImage != null
                      ? Image.file(_bannerImage!, fit: BoxFit.cover)
                      : const Center(
                    child: Text(
                      "Toque para adicionar banner",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ),
                const Positioned(
                  bottom: 8,
                  right: 8,
                  child: Icon(Icons.edit, color: Colors.white),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Foto de Perfil
          Center(
            child: GestureDetector(
              onTap: () => _pickImage(false),
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[400],
                backgroundImage:
                _profileImage != null ? FileImage(_profileImage!) : null,
                child: _profileImage == null
                    ? const Icon(Icons.person, size: 50, color: Colors.white)
                    : null,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Nome e Email
          Center(
            child: Column(
              children: [
                Text(
                  name ?? '',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Endereço
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Endereço",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      hintText: "Digite seu endereço...",
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'O endereço não pode estar vazio.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      onPressed: _saveAddress,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00A896),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      label: const Text(
                        "Salvar Endereço",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
