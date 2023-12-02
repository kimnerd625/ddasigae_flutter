import 'package:flutter/material.dart';

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
                child: GestureDetector(
                  onTap: () {
                    // Title을 눌렀을 때의 동작 추가
                  },
                  child: Text(
                    widget.appBarTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              // 현재 위치를 나타내는 리스트 아이템
              ListTile(
                title: Text(
                  widget.currentLocation,
                ),
              ),
              // 삭제 버튼이 있는 리스트 아이템
              for (String location in ['서대문구 신촌동', '종로구 인사동', '강동구 상일동'])
                ListTile(
                  title: Text(
                    location,
                    style: TextStyle(
                      color: location == widget.selectedLocation
                          ? Colors.blue
                          : null,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      // 해당 위치 삭제 동작 추가
                    },
                  ),
                  onTap: () {
                    widget.selectLocation(location);
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
