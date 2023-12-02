import 'package:flutter/material.dart';
import 'package:ddasigae_flutter/screens/community_screen.dart';
import 'package:ddasigae_flutter/screens/notification_screen.dart';
import 'package:ddasigae_flutter/screens/profile_screen.dart';
import 'package:ddasigae_flutter/screens/home_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const HomeScreen(),
    const CommunityScreen(),
    const NotificationScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '따시개',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        textTheme: const TextTheme(
          // 여기서 fontFamily를 지정해줘야 합니다.
          bodyLarge: TextStyle(fontFamily: 'koPubWorldDotum'), // 추가
          bodyMedium: TextStyle(fontFamily: 'koPubWorldDotum'), // 추가
          displayLarge: TextStyle(fontFamily: 'koPubWorldDotum'), // 추가
          displaySmall: TextStyle(fontFamily: 'koPubWorldDotum'),
          headlineMedium: TextStyle(fontFamily: 'koPubWorldDotum'),
          headlineSmall: TextStyle(fontFamily: 'koPubWorldDotum'),
          titleLarge: TextStyle(
            fontFamily: 'koPubWorldDotum',
            color: Color(0xff4C4838),
            fontWeight: FontWeight.w700,
            fontSize: 24,
            letterSpacing: -1.0,
          ),
          displayMedium: TextStyle(
            fontFamily: 'koPubWorldDotum',
            color: Color(0xff4C4838),
            fontWeight: FontWeight.w700,
            fontSize: 17,
            letterSpacing: -1.0,
          ),
        ),
      ),
      home: Scaffold(
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index) {
            if (mounted) {
              setState(() {
                _currentIndex = index;
              });
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message_rounded),
              label: '커뮤니티',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.access_alarm),
              label: '알림',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: '프로필',
            ),
          ],
          selectedItemColor: Colors.blue,
          showSelectedLabels: true,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
        ),
      ),
    );
  }
}
