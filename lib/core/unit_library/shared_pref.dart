import 'package:shared_preferences/shared_preferences.dart';

import '../../home/app_feature.dart';

const featureOrderKey = 'feature_order';

Future<void> saveFeatureOrder(List<AppFeature> features) async {
  final prefs = await SharedPreferences.getInstance();
  final orderList = features.map((f) => f.type.name).toList();
  await prefs.setStringList(featureOrderKey, orderList);
}

Future<List<String>?> loadFeatureOrder() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getStringList(featureOrderKey);
}
