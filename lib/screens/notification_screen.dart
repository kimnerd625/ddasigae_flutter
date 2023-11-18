import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Screen'),
      ),
      body: const Center(
        child: Text('안녕하세요! 알람 화면입니다.'),
      ),
    );
  }
}
