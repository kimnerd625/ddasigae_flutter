import 'dart:math' show sin, cos, sqrt, atan2, pi;

double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
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
