import 'package:ddasigae_flutter/utils/distance_utils.dart';

String findAdministrativeDistrict(double latitude, double longitude,
    Map<String, dynamic> jsonData, int attempt) {
  bool foundMatch = false;

  for (var province in jsonData.keys) {
    if (province == '서울특별시') {
      for (int i = 1; i <= attempt; i++) {
        for (var districtData in jsonData[province]) {
          if (districtData['시도'] != null &&
              districtData['위도'] != null &&
              districtData['경도'] != null) {
            double districtLatitude = districtData['위도'];
            double districtLongitude = districtData['경도'];

            double distance = calculateDistance(
                latitude, longitude, districtLatitude, districtLongitude);

            // 일정 거리 이내에 위치하면 해당 행정구 반환
            if (distance < 1.0 * i) {
              foundMatch = true;

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
              return result.isNotEmpty ? result : '위치 찾기 오류';
            }
          }
        }
      }
    }
  }

  // 이미 결과를 찾았는지 확인
  if (foundMatch) {
    return '더 이상 값이 안 올라가게 할 수 있습니다.';
  }

  return '위치 찾기 오류';
}
