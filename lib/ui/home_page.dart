import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:fancy_todo_flutter/services/notification_services.dart';
import 'package:fancy_todo_flutter/services/theme_services.dart';
import 'package:fancy_todo_flutter/ui/add_task_bar.dart';
import 'package:fancy_todo_flutter/ui/theme.dart';
import 'package:fancy_todo_flutter/ui/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NotifyHelper notifyHelper = NotifyHelper();
  DateTime _selectedDate = DateTime.now();

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
          _addTaskBar(), // top first layer - date & add task button
          _addDateBar(), // top second layer - date picker timeline
        ],
      ),
    );
  }

  Container _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // today's date
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // intl helps to convert date's type to show
              Text(DateFormat.yMMMMd().format(DateTime.now()), style: subHeadingStyle),
              Text('Today', style: headingStyle),
            ],
          ),
          // add task button
          MyButton(label: '+ Add Task', onTap: () => Get.to(AddTaskPage())),
        ],
      ),
    );
  }

  Container _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, top: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryColor,
        selectedTextColor: Colors.white,
        dateTextStyle: _datePickerStyle(20),
        dayTextStyle: _datePickerStyle(16),
        monthTextStyle: _datePickerStyle(14),
        onDateChange: (date) {
          _selectedDate = date;
        },
      ),
    );
  }

  TextStyle _datePickerStyle(double size) {
    return GoogleFonts.lato(
      textStyle: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.w600,
        color: Colors.grey,
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
