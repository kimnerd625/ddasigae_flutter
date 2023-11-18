import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('알림', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: const NotificationList(),
    );
  }
}

class NotificationList extends StatelessWidget {
  const NotificationList({super.key});

  @override
  Widget build(BuildContext context) {
    // 가상의 알림 데이터 목록
    List<NotificationData> notifications = [
      NotificationData(
        type: NotificationType.comment,
        title: '댓글 등록 알림',
        content: '누군가가 회원님의 글에 댓글을 등록했습니다.',
        date: DateTime.now(),
      ),
      NotificationData(
        type: NotificationType.push,
        title: '푸시 알림 기록',
        content: '회원님의 푸시 알림 기록이 갱신되었습니다.',
        date: DateTime.now().add(const Duration(days: 1)),
      ),
      NotificationData(
        type: NotificationType.popularPost,
        title: '인기 게시글 등록 알림',
        content: '회원님의 글이 인기를 얻어 게시판에 올라갔습니다.',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      NotificationData(
        type: NotificationType.report,
        title: '신고 접수 안내',
        content: '회원님의 게시글이 신고를 받았습니다. 자세한 내용은 확인하세요.',
        date: DateTime.now().add(const Duration(days: 3)),
      ),
      // ... 추가적인 알림 데이터
    ];

    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return NotificationCard(data: notifications[index]);
      },
    );
  }
}

// 알림 유형을 나타내는 열거형
enum NotificationType {
  comment,
  push,
  popularPost,
  report,
  // ... 추가적인 알림 유형
}

// 알림 데이터 클래스
class NotificationData {
  final NotificationType type;
  final String title;
  final String content;
  final DateTime date;

  NotificationData({
    required this.type,
    required this.title,
    required this.content,
    required this.date,
  });
}

class NotificationCard extends StatelessWidget {
  final NotificationData data;

  const NotificationCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    switch (data.type) {
      case NotificationType.comment:
        iconData = Icons.chat_bubble;
        break;
      case NotificationType.push:
        iconData = Icons.bookmark;
        break;
      case NotificationType.popularPost:
        iconData = Icons.thumb_up_alt_rounded;
        break;
      case NotificationType.report:
        iconData = Icons.report;
        break;
    }

    return Card(
      elevation: 0.0,
      margin: const EdgeInsets.all(12.0),
      color: const Color.fromARGB(255, 234, 234, 234),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 왼쪽 아이콘
            Icon(iconData, size: 40.0, color: Colors.grey),
            const SizedBox(width: 16.0),
            // 중앙 컬럼 (제목, 내용)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: const TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    data.content,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16.0),
            // 오른쪽 상단 날짜
            Text(
              DateFormat('MM/dd HH:mm').format(data.date),
              style: const TextStyle(fontSize: 12.0, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
