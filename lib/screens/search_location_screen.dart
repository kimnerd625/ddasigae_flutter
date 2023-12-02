import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Logger _logger = Logger('_SearchLocationScreenState');
final prefs = SharedPreferences.getInstance();

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
    } catch (e, stacktrace) {
      _logger.severe('파일 로딩 중 오류 발생: $e', e, stacktrace);
    }
  }

  Future<List<String>> _loadFromSharedPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      const key = 'savedLocation';

      // 저장된 데이터 가져오기
      List<String> savedLocations = prefs.getStringList(key) ?? [];

      // 가져온 데이터 출력
      for (String location in savedLocations) {
        final decodedLocation = jsonDecode(location);
        print('Saved Location: $decodedLocation');
      }

      return savedLocations;
    } catch (e) {
      _logger.severe('SharedPreferences 로딩 중 오류 발생: $e');
      return [];
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
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

  Future<void> _saveToSharedPreferences(Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      const key = 'savedLocation';

      // 기존에 저장된 데이터 가져오기
      List<String> savedLocations = prefs.getStringList(key) ?? [];

      // 현재 데이터를 String으로 변환하여 추가
      savedLocations.add(jsonEncode(data));

      // 변환한 데이터를 SharedPreferences에 저장
      prefs.setStringList(key, savedLocations);
    } catch (e) {
      _logger.severe('SharedPreferences 저장 중 오류 발생: $e');
    }
  }

  void _addToSharedPreferences(Map<String, dynamic> data) {
    _loadFromSharedPreferences().then((savedLocations) {
      if (savedLocations.length < 2) {
        _saveToSharedPreferences(data);

        // Navigator가 pop될 때 SearchLocationScreen과 함께 LocationDrawer도 pop
        Navigator.pop(context, true); // true는 새로 고침이 필요하다는 플래그
      } else {
        // 최대 두 개까지만 저장 가능하므로 추가할 수 없음을 사용자에게 알림
        _showSnackBar('최대 두 개의 위치만 저장할 수 있습니다.');
      }
    });
  }

  Future<void> clearSavedLocations() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'savedLocation';

    // 해당 키에 저장된 데이터 모두 삭제
    await prefs.remove(key);
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
            trailing: IconButton(
              icon: const Icon(Icons.add_circle_outline,
                  color: Color(0xff4C4838)),
              onPressed: () {
                _addToSharedPreferences(result);
              },
            ),
          ),
        ),
      );
    }).toList();
  }
}
