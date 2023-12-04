import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:ddasigae_flutter/services/weather.dart';
import 'package:ddasigae_flutter/utils/current_location_utils.dart';
import 'package:ddasigae_flutter/widgets/home/location_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _currentLocation = '현 위치를 찾는 중...';
  String _locationTitle = '서대문구 신촌동';
  int _temperatureValue = 0;
  int _maxTemperatureValue = 0;
  int _minTemperatureValue = 0;
  String _temperature = '10°';
  Widget? _weatherCarousel;

  String _formatTodayDate() {
    return DateFormat('MM월 dd일').format(DateTime.now());
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadInitialLocationTitle();
    _loadWeather();
    _loadHourlyWeather();
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
        _temperatureValue = weatherData['main']['temp'].toInt();
        _maxTemperatureValue = weatherData['main']['temp_max'].toInt();
        _minTemperatureValue = weatherData['main']['temp_min'].toInt();
        _temperature = '$_temperatureValue°';
      } catch (e) {
        print('날씨 정보를 가져오는 데 문제가 발생했습니다: $e');
      }
    }
  }

  IconData _getWeatherIcon(String weatherMain) {
    switch (weatherMain.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny_outlined;
      case 'clouds':
        return Icons.cloud_outlined;
      case 'rain':
        return Icons
            .beach_access_outlined; // You can replace this with a rain icon
      case 'snow':
        return Icons.ac_unit_outlined;
      default:
        return Icons
            .wb_sunny_outlined; // Default to sun icon if weather is unknown
    }
  }

  Future<void> _loadHourlyWeather() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double latitude = prefs.getDouble('latitude') ?? 0.0;
    double longitude = prefs.getDouble('longitude') ?? 0.0;

    if (latitude != 0.0 && longitude != 0.0) {
      try {
        var weatherData =
            await OpenWeatherService().getHourlyWeather(latitude, longitude);
        print(weatherData);

        // 로컬 타임존으로 변환하기 위한 formatter
        var formatter = DateFormat('yyyy-MM-dd HH:mm:ss');

        // 현재 날짜와 시간을 가져옴
        DateTime now = DateTime.now();
        String todayDate = DateFormat('yyyy-MM-dd').format(now);
        String currentTime = DateFormat('HH:mm:ss').format(now);

        // Filter hourly data for today and tomorrow, and sort by time
        List hourlyDataForTodayAndTomorrow =
            weatherData['list'].where((hourlyData) {
          String dataDate = hourlyData['dt_txt'].toString().substring(0, 10);
          return dataDate == todayDate ||
              dataDate ==
                  DateFormat('yyyy-MM-dd')
                      .format(DateTime.now().add(const Duration(days: 1)));
        }).toList();

        hourlyDataForTodayAndTomorrow.sort((a, b) {
          // Sort by time
          return a['dt_txt'].compareTo(b['dt_txt']);
        });

        // Display hourly data for today and tomorrow
        List<Widget> carouselItems = [];

        for (var hourlyData in hourlyDataForTodayAndTomorrow) {
          DateTime localTime = formatter.parse(hourlyData['dt_txt']);
          String formattedTime = DateFormat('ha').format(localTime);
          String weatherMain = hourlyData['weather'][0]['main'];

          // Highlight current time
          bool isCurrentTime =
              todayDate == DateFormat('yyyy-MM-dd').format(localTime) &&
                  currentTime.compareTo(hourlyData['dt_txt'].toString()) < 0;

          carouselItems.add(
            Container(
              margin: const EdgeInsets.only(
                  top: 8.0, bottom: 8.0, left: 0.0, right: 0.0),
              padding: const EdgeInsets.only(
                  top: 4.0, bottom: 4.0, left: 16.0, right: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.7),
                    spreadRadius: 0,
                    blurRadius: 5,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(formattedTime,
                      style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 3.0),
                  Icon(
                    _getWeatherIcon(weatherMain),
                    color: const Color(0xff656253),
                    size: 22.0,
                  ),
                  const SizedBox(height: 3.0),
                  Text(
                    '${hourlyData['main']['temp'].toInt()}°',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ],
              ),
            ),
          );
        }

        // 캐러셀 생성
        Widget weatherCarousel = CarouselSlider(
          items: carouselItems,
          options: CarouselOptions(
            initialPage: 2,
            height: 120.0,
            enlargeCenterPage: false,
            aspectRatio: 16 / 9,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 2),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            viewportFraction: 0.18,
            enableInfiniteScroll: false,
          ),
        );

        // UI 업데이트
        setState(() {
          _weatherCarousel = weatherCarousel;
        });
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
                    padding: const EdgeInsets.only(
                      left: 6.0,
                    ),
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
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                margin: const EdgeInsets.only(top: 40.0, right: 26.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _temperature,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(_maxTemperatureValue.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    color: const Color(0xffF16565),
                                  ),
                              textAlign: TextAlign.right),
                          Text(_minTemperatureValue.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    color: const Color(0xff6FA2D1),
                                  ),
                              textAlign: TextAlign.right),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          _weatherCarousel ?? Container(), // 추가적인 자식 위젯들을 여기에 추가할 수 있습니다.
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
