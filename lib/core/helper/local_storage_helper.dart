import 'package:hive_flutter/hive_flutter.dart';

class LocalStorageHelper {
  LocalStorageHelper._internal();
  static final LocalStorageHelper _instance = LocalStorageHelper._internal();

  factory LocalStorageHelper() {
    return _instance;
  }

  Box<dynamic>? hiveBox;

  // get danh sách SearchHistory
  // Kiểm tra xem searchHistory có tồn tại trong hiveBox không với key là searchHistory
  // nếu có thì nó trả về danh sách dữ liệu as List<String>
  // nếu searchHistory == nul thì nó return []
  static List<String> getSearchHistory() {
    final List<String>? searchHistory =
        _instance.hiveBox?.get('searchHistory') as List<String>?;
    return searchHistory ?? [];
  }

  // thêm 1 mục tìm kiếm mới vào SearchHistory trong hive
  // getSearchHistory để lấy danh sách lịch sử tìm kiếm
  // sau đó nó thêm searchTerm vào đầu danh sách của SearchHistory
  // sau đó put nó vào key searchHistory
  static void addToSearchHistory(String searchTerm) {
    List<String> searchHistory = getSearchHistory();
    searchHistory.insert(0, searchTerm);
    _instance.hiveBox?.put('searchHistory', searchHistory);
  }

  static void clearSearchHistory() {
    _instance.hiveBox?.delete('searchHistory');
  }

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
