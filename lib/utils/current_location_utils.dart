import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ddasigae_flutter/utils/district_utils.dart';

class CurrentLocationUtils {
  static Future<void> getCurrentLocation(
      BuildContext context, Function(String) setLocation) async {
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
        desiredAccuracy: LocationAccuracy.high,
      );

      String jsonString = await DefaultAssetBundle.of(context)
          .loadString('assets/json/address.json');
      Map<String, dynamic> jsonData = json.decode(jsonString);
      String administrativeDistrict = findAdministrativeDistrict(
          position.latitude, position.longitude, jsonData, 4);

      // locationName: 시군구와 읍면동/구를 공백으로 구분하여 하나의 문자열로 만든 값
      String locationName = administrativeDistrict.replaceAll('/', ' ');

      setLocation(administrativeDistrict);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setDouble('latitude', position.latitude);
      prefs.setDouble('longitude', position.longitude);
      prefs.setDouble('currentLatitude', position.latitude);
      prefs.setDouble('currentLongitude', position.longitude);

      // 저장된 위치 정보를 prefs에 추가합니다.
      prefs.setString('currentLocation', locationName);
      prefs.setString('selectedLocation', locationName);
    } catch (e) {
      setLocation('현 위치를 찾을 수 없습니다.');
    }
  }
}
