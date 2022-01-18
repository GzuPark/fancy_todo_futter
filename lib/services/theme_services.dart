import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  // load data - key: isDarkMode, value: boolean
  // if isDarkMode is not exist, initial value set false
  bool _loadThemeFromBox() => _box.read(_key) ?? false;
  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  // save isDarkMode data to the storage
  void _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  void switchTheme() {
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    // update recent isDarkMode data
    _saveThemeToBox(!_loadThemeFromBox());
  }
}
