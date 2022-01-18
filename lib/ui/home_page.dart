import 'package:fancy_todo_flutter/services/notification_services.dart';
import 'package:fancy_todo_flutter/services/theme_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NotifyHelper notifyHelper = NotifyHelper();

  @override
  void initState() {
    super.initState();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [Text('Theme Data', style: TextStyle(fontSize: 30))],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      leading: GestureDetector(
        child: const Icon(Icons.nightlight_round, size: 20),
        onTap: () {
          ThemeService().switchTheme();
          notifyHelper.instantNotification(
            title: 'Theme changed',
            body: 'Activated ${Get.isDarkMode ? 'Light' : 'Dark'} Theme',
          );
          notifyHelper.scheduledNotification();
        },
      ), // beginning of the appbar
      actions: const [
        Icon(Icons.person, size: 20),
        SizedBox(width: 20),
      ],
    );
  }
}
