import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ddasigae_flutter/utils/district_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _currentLocation = '현 위치를 찾는 중...';
  String _appBarTitle = '서대문구 신촌동';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('위치 권한이 거부되었습니다.');
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // JSON 파일 로드 및 행정구 추출
      String jsonString = await DefaultAssetBundle.of(context)
          .loadString('assets/json/address.json');
      Map<String, dynamic> jsonData = json.decode(jsonString);
      String administrativeDistrict = findAdministrativeDistrict(
          position.latitude, position.longitude, jsonData);

      setState(() {
        _currentLocation =
            '현재 위치: ${position.latitude}, ${position.longitude}\n행정구: $administrativeDistrict';
        _appBarTitle = administrativeDistrict; // AppBar title 업데이트
      });
    } catch (e) {
      print('위치를 가져오는 데 문제가 발생했습니다: $e');
      setState(() {
        _currentLocation = '현 위치를 찾을 수 없습니다.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitle, style: const TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Text(_currentLocation),
      ),
    );
  }
}
