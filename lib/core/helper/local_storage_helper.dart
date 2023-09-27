import 'package:hive_flutter/hive_flutter.dart';

class LocalStorageHelper {
  LocalStorageHelper._internal();
  static final LocalStorageHelper _instance = LocalStorageHelper._internal();

  factory LocalStorageHelper() {
    return _instance;
  }

  Box<dynamic>? hiveBox;

  static initLocalStorageHelper() async {
    _instance.hiveBox = await Hive.openBox('App');
  }

  static dynamic getValue(String key) {
    return _instance.hiveBox?.get(key);
  }

  static setValue(String key, dynamic val) {
    _instance.hiveBox?.put(key, val);
  }
}
