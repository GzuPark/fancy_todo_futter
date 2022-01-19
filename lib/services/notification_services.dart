import 'package:fancy_todo_flutter/models/task.dart';
import 'package:fancy_todo_flutter/ui/notified_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotifyHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void initializeNotification() async {
    _configureLocalTimezone();

    final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
        requestSoundPermission: false,
        requestBadgePermission: false,
        requestAlertPermission: false,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('appicon');

    final InitializationSettings initializationSettings = InitializationSettings(
      iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: selectNotification,
    );
  }

  Future<void> _configureLocalTimezone() async {
    tz.initializeTimeZones();
    final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) async {
    Get.dialog(Text('Welcome to flutter'));
  }

  Future<void> selectNotification(String? payload) async {
    if (payload != 'Theme changed') {
      Get.to(() => NotifiedPage(label: payload));
    }
  }

  void instantNotification({required String title, required String body}) async {
    const iOSPlatformChannelSpecifics = IOSNotificationDetails();
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'fancy_todo_flutter',
      'Fancy TODOs Application',
      importance: Importance.max,
      priority: Priority.high,
    );

    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: title,
    );
  }

  void scheduledNotification(Task task, int hour, int minutes) async {
    const iOSPlatformChannelSpecifics = IOSNotificationDetails();
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'fancy_todo_flutter',
      'Fancy TODOs Application',
      importance: Importance.max,
      priority: Priority.high,
    );

    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.id!.toInt(),
      task.title,
      task.note,
      _convertTime(hour, minutes),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: '${task.title}|${task.note}',
    );
  }

  tz.TZDateTime _convertTime(int hour, int minutes) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }
}
