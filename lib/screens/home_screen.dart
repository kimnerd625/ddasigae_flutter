import 'dart:convert';
import 'dart:math' show sin, cos, sqrt, atan2, pi;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

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

  String findAdministrativeDistrict(
      double latitude, double longitude, Map<String, dynamic> jsonData) {
    for (var province in jsonData.keys) {
      if (province == '서울특별시') {
        for (var districtData in jsonData[province]) {
          if (districtData['시도'] != null &&
              districtData['위도'] != null &&
              districtData['경도'] != null) {
            double districtLatitude = districtData['위도'];
            double districtLongitude = districtData['경도'];

            double distance = calculateDistance(
                latitude, longitude, districtLatitude, districtLongitude);

            // 일정 거리 이내에 위치하면 해당 행정구 반환
            if (distance < 0.5) {
              String result = '';
              if (districtData['시군구'] != null) {
                result += districtData['시군구']!;
              }
              if (districtData['읍면동/구'] != null) {
                if (result.isNotEmpty) {
                  result += ' '; // 시군구가 있으면 구분을 위해 공백 추가
                }
                result += districtData['읍면동/구']!;
              }
              return result.isNotEmpty ? result : '행정구를 찾을 수 없습니다.';
            }
          }
        }
      }
    }
    return '행정구를 찾을 수 없습니다.';
  }

  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    // 간단한 위도, 경도 간 거리 계산 로직
    const R = 6371.0; // 지구 반지름 (단위: km)

    double dLat = radians(lat2 - lat1);
    double dLon = radians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(radians(lat1)) * cos(radians(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    double distance = R * c;
    return distance;
  }

  double radians(double degree) {
    return degree * (pi / 180.0);
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
