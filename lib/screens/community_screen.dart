import 'package:flutter/material.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Community Screen'),
      ),
      body: const Center(
        child: Text('안녕하세요! 커뮤니티 화면입니다.'),
      ),
    );
  }
}
