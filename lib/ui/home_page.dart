import 'package:fancy_todo_flutter/services/notification_services.dart';
import 'package:fancy_todo_flutter/services/theme_services.dart';
import 'package:fancy_todo_flutter/ui/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
        children: [
          // top layer
          Row(
            children: [
              // today's date
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // intl helps to convert date's type to show
                    Text(DateFormat.yMMMMd().format(DateTime.now()), style: subHeadingStyle),
                    Text('Today', style: headingStyle),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        child: Icon(
          Get.isDarkMode ? Icons.wb_sunny_rounded : Icons.nightlight_round,
          color: Get.isDarkMode ? Colors.white : Colors.black,
          size: 20,
        ),
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
        CircleAvatar(backgroundImage: AssetImage('assets/img/profile.png')),
        SizedBox(width: 20),
      ],
    );
  }
}
