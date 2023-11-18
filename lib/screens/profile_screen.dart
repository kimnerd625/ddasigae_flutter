import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 사용자 정보 카드
            SizedBox(
              width: double.infinity,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 0,
                child: Material(
                  color: const Color.fromARGB(255, 220, 220, 220),
                  borderRadius: BorderRadius.circular(16.0),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('따시개', style: TextStyle(fontSize: 20.0)),
                        SizedBox(height: 8.0),
                        Text('ddasigae@gmail.com / Google 계정'),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // 각 버튼들
            const SizedBox(height: 16.0),
            const Divider(height: 16.0, thickness: 1.0, color: Colors.black),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // 버튼이 클릭되었을 때의 동작
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                child: const Row(
                  children: [
                    Icon(Icons.article, color: Colors.black),
                    SizedBox(width: 8.0),
                    Text(
                      '내 게시글',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 16.0, thickness: 1.0, color: Colors.black),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // 버튼이 클릭되었을 때의 동작
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                child: const Row(
                  children: [
                    Icon(Icons.chat, color: Colors.black),
                    SizedBox(width: 8.0),
                    Text(
                      '문의하기',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 16.0, thickness: 1.0, color: Colors.black),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // 버튼이 클릭되었을 때의 동작
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                child: const Row(
                  children: [
                    Icon(Icons.notifications, color: Colors.black),
                    SizedBox(width: 8.0),
                    Text(
                      '공지사항',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 16.0, thickness: 1.0, color: Colors.black),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // 버튼이 클릭되었을 때의 동작
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                child: const Row(
                  children: [
                    Icon(Icons.exit_to_app, color: Colors.black),
                    SizedBox(width: 8.0),
                    Text(
                      '탈퇴하기',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 16.0, thickness: 1.0, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
