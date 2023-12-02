import 'package:flutter/material.dart';

import '../../screens/search_location_screen.dart';

class LocationDrawer extends StatefulWidget {
  final String appBarTitle;
  final String currentLocation;
  final Function(String) selectLocation;
  final String selectedLocation;

  const LocationDrawer({
    Key? key,
    required this.appBarTitle,
    required this.currentLocation,
    required this.selectLocation,
    required this.selectedLocation,
  }) : super(key: key);

  @override
  _LocationDrawerState createState() => _LocationDrawerState();
}

class _LocationDrawerState extends State<LocationDrawer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: Alignment.topLeft,
        child: Container(
          margin: const EdgeInsets.only(top: 30, left: 10),
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
                padding: const EdgeInsets.all(16.0),
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
                    Navigator.pop(context);
                  },
                ),
              ),
              // 삭제 버튼이 있는 위치 목록
              for (String location in ['서대문구 신촌동', '강동구 상일동'])
                Container(
                  margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                  padding: EdgeInsets.zero,
                  decoration: BoxDecoration(
                    color: location == widget.selectedLocation
                        ? const Color(0xffF7F0D7)
                        : null,
                    borderRadius: BorderRadius.circular(200),
                  ),
                  child: ListTile(
                    dense: true,
                    title: Text(
                      location,
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.do_disturb_on_outlined),
                      color: const Color(0xff4C4838),
                      onPressed: () {
                        // 해당 위치 삭제 동작 추가
                      },
                    ),
                    onTap: () {
                      widget.selectLocation(location);
                      Navigator.pop(context);
                    },
                  ),
                ),
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
                        icon: const Icon(Icons.add),
                        color: const Color(0xff4C4838),
                        onPressed: () {
                          // 추가 주소 입력 동작 추가
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const SearchLocationScreen(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const begin = Offset(1.0, 0.0);
                                const end = Offset.zero;
                                const curve = Curves.easeInOutQuart;

                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));

                                var offsetAnimation = animation.drive(tween);

                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                );
                              },
                            ),
                          );
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
