import 'package:fancy_todo_flutter/services/theme_services.dart';
import 'package:fancy_todo_flutter/ui/home_page.dart';
import 'package:fancy_todo_flutter/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Replace from MaterialApp to GetMaterialApp
    return GetMaterialApp(
      title: 'Fancy TODOs Application',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeService().theme,
      theme: Themes.light,
      darkTheme: Themes.dark,
      home: HomePage(),
    );
  }
}
