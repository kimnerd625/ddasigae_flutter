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
    _loadInitialLocationTitle();
    _loadWeather();
  }

  @override
  void dispose() {
    // 필요에 따라 위치 갱신 등의 정리 작업을 수행할 수 있음
    super.dispose();
  }

  Future<void> _loadInitialLocationTitle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String initialLocationTitle = prefs.getString('selectedLocation') ??
        prefs.getString('currentLocation') ??
        '서대문구 신촌동';
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

    if (latitude != 0.0 && longitude != 0.0) {
      try {
        var weatherData =
            await OpenWeatherService().getWeather(latitude, longitude);
        print(weatherData);
      } catch (e) {
        print('날씨 정보를 가져오는 데 문제가 발생했습니다: $e');
      }
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
    showGeneralDialog(
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
          appBarTitle: _locationTitle,
          currentLocation: _currentLocation,
          selectLocation: _selectLocation,
          selectedLocation: _locationTitle,
          loadWeather: _loadWeather,
        );
      },
    );
  }

  void _selectLocation(String location) async {
    setState(() {
      _locationTitle = location;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedLocation', location);
  }
}
