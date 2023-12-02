import 'dart:convert';
import 'package:ddasigae_flutter/widgets/home/location_drawer.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ddasigae_flutter/utils/district_utils.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _currentLocation = '현 위치를 찾는 중...';
  String _locationTitle = '서대문구 신촌동';
  String _formatTodayDate() {
    return DateFormat('MM월 dd일').format(DateTime.now());
  }

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
          position.latitude, position.longitude, jsonData, 4);

      setState(() {
        _currentLocation = administrativeDistrict;
        _locationTitle = administrativeDistrict; // AppBar title 업데이트
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
      backgroundColor: const Color(0xffFFF9E5),
      body: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 40.0, left: 20.0),
                    padding: const EdgeInsets.all(6.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showLocationDrawer(context);
                          },
                          child: Text(
                            _locationTitle,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        GestureDetector(
                          onTap: () {
                            _showLocationDrawer(context);
                          },
                          child: const Icon(
                            Icons.keyboard_arrow_down,
                            size: 30.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.only(
                        left: 6.0,
                        right: 6.0,
                      ),
                      margin: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        _formatTodayDate(),
                        style: Theme.of(context).textTheme.displaySmall,
                      )),
                ],
              ),
            ],
          ),
          // 추가적인 자식 위젯들을 여기에 추가할 수 있습니다.
        ],
      ),
    );
  }

  void _showLocationDrawer(BuildContext context) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    double appBarHeight = kToolbarHeight;
    double fromTop =
        renderBox.localToGlobal(const Offset(0, 0)).dy + appBarHeight + 15;

    showLocationDialog(
      context,
      _locationTitle,
      _currentLocation,
      _selectLocation,
    );
  }

  Future<Object?> showLocationDialog(
    BuildContext context,
    String appBarTitle,
    String currentLocation,
    void Function(String location) selectLocation,
  ) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (
        BuildContext buildContext,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return LocationDrawer(
          appBarTitle: appBarTitle,
          currentLocation: currentLocation,
          selectLocation: selectLocation,
          selectedLocation: appBarTitle,
        );
      },
    );
  }

  void _selectLocation(String location) {
    setState(() {
      _locationTitle = location;
      // 선택한 위치에 따라 필요한 업데이트 수행
    });
  }
}
