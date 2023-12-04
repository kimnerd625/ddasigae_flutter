import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../screens/search_location_screen.dart';

class LocationDrawer extends StatefulWidget {
  final String appBarTitle;
  final String currentLocation;
  final Function(String) selectLocation;
  final String selectedLocation;
  final Future<void> Function() loadWeather;

  const LocationDrawer({
    Key? key,
    required this.appBarTitle,
    required this.currentLocation,
    required this.selectLocation,
    required this.selectedLocation,
    required this.loadWeather,
  }) : super(key: key);

  @override
  _LocationDrawerState createState() => _LocationDrawerState();
}

class _LocationDrawerState extends State<LocationDrawer> {
  List<Map<String, dynamic>> savedLocationsData = [];
  double currentLocationLatitude = 0.0;
  double currentLocationLongitude = 0.0;

  @override
  void initState() {
    super.initState();
    _loadSavedLocations();
    _loadCurrentLocation();
  }

  void _selectLocation(String location) async {
    // Save the selected location in prefs
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedLocation', location);
  }

  Future<void> _loadCurrentLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double currentLatitude = prefs.getDouble('currentLatitude') ?? 0.0;
    double currentLongitude = prefs.getDouble('currentLongitude') ?? 0.0;

    setState(() {
      currentLocationLatitude = currentLatitude;
      currentLocationLongitude = currentLongitude;
    });
  }

  Future<void> _loadSavedLocations() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'savedLocation';

    // 저장된 데이터 가져오기
    List<String> savedLocations = prefs.getStringList(key) ?? [];

    // 가져온 데이터를 Map<String, dynamic>으로 디코딩하여 저장
    setState(() {
      savedLocationsData = savedLocations
          .map<Map<String, dynamic>>((location) => jsonDecode(location))
          .toList();
    });
  }

  Future<void> _openSearchLocationScreen() async {
    await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SearchLocationScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutQuart;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    ).then((result) {
      if (result != null && result as bool) {
        // result가 true인 경우, SearchLocationScreen에서 새로 고침이 필요함
        _loadSavedLocations();
      }
    });
  }

  Future<void> _removeLocation(Map<String, dynamic> locationData) async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'savedLocation';

    // 저장된 데이터 가져오기
    List<String> savedLocations = prefs.getStringList(key) ?? [];

    // 해당 위치 정보 제거
    savedLocations.remove(jsonEncode(locationData));

    // 업데이트된 데이터를 SharedPreferences에 저장
    prefs.setStringList(key, savedLocations);

    // UI 업데이트
    _loadSavedLocations();

    // If the selected location is removed, update _locationTitle
    String selectedLocation = '${locationData['시군구']} ${locationData['읍면동/구']}';
    if (widget.appBarTitle == selectedLocation) {
      _selectLocation(''); // Set to an empty string or any default value
    }
  }

  Future<void> _saveLatitudeLongitude(double latitude, double longitude) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('latitude', latitude);
    prefs.setDouble('longitude', longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: Alignment.topLeft,
        child: Container(
          margin: const EdgeInsets.only(top: 40, left: 10),
          padding: const EdgeInsets.only(
            bottom: 20,
          ),
          width: MediaQuery.of(context).size.width * 0.8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(0),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(top: 13.0, left: 16.0, bottom: 10.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Title을 눌렀을 때의 동작 추가
                      },
                      child: Text(
                        widget.appBarTitle,
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.keyboard_arrow_up,
                        size: 30.0,
                      ),
                    ),
                  ],
                ),
              ),
              // 현재 위치를 나타내는 부분
              Container(
                margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: widget.currentLocation == widget.selectedLocation
                      ? const Color(0xffF7F0D7)
                      : null,
                  borderRadius: BorderRadius.circular(200),
                ),
                child: ListTile(
                  dense: true,
                  title: Text(
                    '현재 위치',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                  onTap: () {
                    widget.selectLocation(widget.currentLocation);
                    _saveLatitudeLongitude(
                        currentLocationLatitude, currentLocationLongitude);
                    widget.loadWeather();
                    Navigator.pop(context);
                  },
                ),
              ),
              // 삭제 버튼이 있는 위치 목록
              for (Map<String, dynamic> locationData in savedLocationsData)
                Container(
                  margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: '${locationData['시군구']} ${locationData['읍면동/구']}' ==
                            widget.selectedLocation
                        ? const Color(0xffF7F0D7)
                        : null,
                    borderRadius: BorderRadius.circular(200),
                  ),
                  child: ListTile(
                    dense: true,
                    title: Text(
                      '${locationData['시군구']} ${locationData['읍면동/구']}',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.do_disturb_on_outlined),
                      color: const Color(0xff4C4838),
                      onPressed: () {
                        // 해당 위치 삭제 동작 추가
                        _removeLocation(locationData);
                      },
                    ),
                    onTap: () {
                      widget.selectLocation(
                          '${locationData['시군구']} ${locationData['읍면동/구']}');
                      _saveLatitudeLongitude(
                          locationData['위도'], locationData['경도']);
                      widget.loadWeather();
                      Navigator.pop(context);
                    },
                  ),
                ),
              if (savedLocationsData.length < 2)
                Container(
                  margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(200),
                  ),
                  child: ListTile(
                    dense: true,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero, // 여백 제거
                          constraints: const BoxConstraints(),
                          icon: const Icon(Icons.add),
                          color: const Color(0xff4C4838),
                          onPressed: () {
                            // 추가 주소 입력 동작 추가
                            _openSearchLocationScreen();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
