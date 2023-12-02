import 'dart:convert';
import 'package:flutter/material.dart';

class SearchLocationScreen extends StatefulWidget {
  const SearchLocationScreen({Key? key}) : super(key: key);

  @override
  _SearchLocationScreenState createState() => _SearchLocationScreenState();
}

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  List<Map<String, dynamic>> _jsonData = [];
  List<Map<String, dynamic>> _searchResults = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadJsonData();
  }

  Future<void> _loadJsonData() async {
    try {
      String jsonString = await DefaultAssetBundle.of(context)
          .loadString('assets/json/address.json');

      // JSON 디코딩할 때 Map<String, dynamic>으로 캐스팅하여 사용합니다.
      Map<String, dynamic> jsonData = json.decode(jsonString);

      // 서울특별시에 해당하는 데이터만 추출합니다.
      List<Map<String, dynamic>> seoulData =
          List<Map<String, dynamic>>.from(jsonData['서울특별시']);

      setState(() {
        _jsonData = seoulData;
        _searchResults = []; // 초기에는 전체 데이터를 보여줍니다.
      });
    } catch (e) {
      print('파일 로딩 중 오류 발생: $e');
    }
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      // 검색어가 비어있을 때 아무 동작도 하지 않습니다.
      return;
    }

    List<Map<String, dynamic>> results = _jsonData
        .where((data) =>
            (data['시군구'] != null && data['시군구'].toString().contains(query)) ||
            (data['읍면동/구'] != null && data['읍면동/구'].toString().contains(query)))
        .toList();

    setState(() {
      _searchResults = results.take(4).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFF9E5),
      body: Container(
        margin: const EdgeInsets.only(top: 40.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    padding: EdgeInsets.zero, // 여백 제거
                    constraints: const BoxConstraints(),
                    iconSize: 24.0, // 아이콘 크기 조절
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: TextField(
                                controller: _searchController,
                                onChanged: (query) {
                                  _performSearch(query);
                                },
                                decoration: const InputDecoration(
                                  hintText: '검색어를 입력하세요',
                                  border: InputBorder.none,
                                ),
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.search_rounded),
                            onPressed: () {
                              // 검색 아이콘 클릭 시 동작 추가
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 45.0,
            ),
            Expanded(
              child: Container(
                child: ListView(
                  children: _buildSearchResults(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSearchResults() {
    return _searchResults.asMap().entries.map((entry) {
      final index = entry.key;
      final result = entry.value;

      return Container(
        decoration: BoxDecoration(
          border: Border(
            top: index == 0
                ? const BorderSide(color: Color(0xffE9dd80), width: 1.0)
                : BorderSide.none,
            bottom: const BorderSide(color: Color(0xffE9dd80), width: 1.0),
          ),
        ),
        child: SizedBox(
          height: 50,
          child: ListTile(
            contentPadding: const EdgeInsets.only(left: 50, right: 30),
            title: Text(
              '${result['시도'] ?? ''} ${result['시군구'] ?? ''} ${result['읍면동/구'] ?? ''}',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            trailing:
                const Icon(Icons.add_circle_outline, color: Color(0xff4C4838)),
          ),
        ),
      );
    }).toList();
  }
}
