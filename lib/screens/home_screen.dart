import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:ddasigae_flutter/utils/current_location_utils.dart';
import 'package:ddasigae_flutter/services/weather.dart';
import 'package:ddasigae_flutter/widgets/home/location_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    _loadWeather();
    _loadInitialLocationTitle();
  }

  @override
  void dispose() {
    // 필요에 따라 위치 갱신 등의 정리 작업을 수행할 수 있음
    super.dispose();
  }

  Future<void> _loadInitialLocationTitle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String initialLocationTitle =
        prefs.getString('selectedLocation') ?? '서대문구 신촌동';
    setState(() {
      _locationTitle = initialLocationTitle;
    });
  }

  Future<void> _getCurrentLocation() async {
    await CurrentLocationUtils.getCurrentLocation(context, (String location) {
      setState(() {
        _currentLocation = location;
      });
    });
  }

  Future<void> _loadWeather() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double latitude = prefs.getDouble('latitude') ?? 0.0;
    double longitude = prefs.getDouble('longitude') ?? 0.0;

    // 이전 위치 정보를 가져옵니다.
    double previousLatitude = prefs.getDouble('currentLatitude') ?? 0.0;
    double previousLongitude = prefs.getDouble('currentLongitude') ?? 0.0;

    // 이전 위치와 현재 위치를 비교하여 변경되었는지 확인합니다.
    if (latitude != 0.0 &&
        longitude != 0.0 &&
        (latitude != previousLatitude || longitude != previousLongitude)) {
      // 위도와 경도가 유효하고 이전 위치와 다를 경우에만 날씨 정보 로드
      await _getWeather(latitude, longitude);

      // 위치 정보를 preference에 저장 (현재 위치가 이전 위치로 업데이트됨)
      prefs.setDouble('currentLatitude', latitude);
      prefs.setDouble('currentLongitude', longitude);
    }
  }

  // 추가된 메서드: 현재 위치에 대한 날씨 정보 가져오기
  Future<dynamic> _getWeather(double latitude, double longitude) async {
    try {
      var weatherData =
          await OpenWeatherService().getWeather(latitude, longitude);
      print(weatherData);
    } catch (e) {
      print('날씨 정보를 가져오는 데 문제가 발생했습니다: $e');
      // 날씨 정보를 가져오는 동안 에러가 발생한 경우 처리할 코드
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

  void _selectLocation(String location) async {
    setState(() {
      _locationTitle = location;
      // 필요한 경우 추가 업데이트 수행
    });

    // Save the selected location in prefs
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedLocation', location);
  }
}
