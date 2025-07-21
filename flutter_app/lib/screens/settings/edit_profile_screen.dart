import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadAvatar(File imageFile) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return null;

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('avatar')
          .child('$uid.jpg');

      await storageRef.putFile(imageFile);

      String downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Upload avatar failed: $e');
      return null;
    }
  }

  void _saveNameToFirestore(String name) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'name': name,
      });
    }
  }

  void _saveAvatarUrlToFirestore(String url) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'avatarUrl': url,
      });
    }
  }

  void _saveProfile() async {
    final name = _nameController.text.trim();
    File? imageFile = _selectedImage;

    if (name.isNotEmpty) {
      _saveNameToFirestore(name);
    }

    if (imageFile != null) {
      final avatarUrl = await _uploadAvatar(imageFile);
      if (avatarUrl != null) {
        _saveAvatarUrlToFirestore(avatarUrl);
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Cập nhật hồ sơ thành công')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh sửa hồ sơ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage:
                    _selectedImage != null ? FileImage(_selectedImage!) : null,
                child: _selectedImage == null
                    ? Icon(Icons.camera_alt, size: 50)
                    : null,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Tên người dùng'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveProfile,
              child: Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }
}
