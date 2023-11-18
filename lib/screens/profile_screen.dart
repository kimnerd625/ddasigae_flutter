import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Screen'),
      ),
      body: const Center(
        child: Text('안녕하세요! 프로필 화면입니다.'),
      ),
    );
  }
}
