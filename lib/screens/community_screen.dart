import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('서대문구 신촌동', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: const CommunityPostList(), // 지역 게시글 목록 위젯 추가
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 글 작성 버튼 클릭 시 동작
          // 여기에 글 작성 화면으로 이동하는 코드를 추가하세요.
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class CommunityPostList extends StatelessWidget {
  const CommunityPostList({super.key});

  @override
  Widget build(BuildContext context) {
    // 가상의 게시글 데이터 목록
    List<CommunityPostData> posts = [
      CommunityPostData(
        author: '사용자1',
        content: '안녕하세요! 신촌동에서 만날 친구 구해요.',
        date: DateTime.now(),
      ),
      CommunityPostData(
        author: '사용자2',
        content: '주변 맛집 추천해주세요!',
        date: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      CommunityPostData(
        author: '사용자3',
        content: '오늘은 날씨가 좋네요. 같이 산책할 사람 구해요!',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      CommunityPostData(
        author: '사용자4',
        content: '오늘은 날씨가 좋네요. 같이 산책할 사람 구해요!',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      // ... 추가적인 게시글 데이터
    ];

    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return CommunityPostCard(data: posts[index]);
      },
    );
  }
}

class CommunityPostData {
  final String author;
  final String content;
  final DateTime date;

  CommunityPostData({
    required this.author,
    required this.content,
    required this.date,
  });
}

class CommunityPostCard extends StatelessWidget {
  final CommunityPostData data;

  const CommunityPostCard({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data.author,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '날짜: ${DateFormat('MM/dd HH:mm').format(data.date)}',
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // 첫 번째 버튼(날씨 정보 버튼)을 눌렀을 때의 동작
                  },
                  child: const Text('날씨 정보'),
                ),
                const SizedBox(width: 8.0),
                ElevatedButton(
                  onPressed: () {
                    // 두 번째 버튼(더 많은 정보 버튼)을 눌렀을 때의 동작
                  },
                  child: const Text('더 많은 정보'),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(data.content),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.thumb_up),
                  onPressed: () {
                    // 좋아요 버튼을 눌렀을 때의 동작
                  },
                ),
                const SizedBox(width: 4.0),
                const Text('24 좋아요'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
