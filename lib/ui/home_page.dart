import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:fancy_todo_flutter/controllers/task_controller.dart';
import 'package:fancy_todo_flutter/models/task.dart';
import 'package:fancy_todo_flutter/services/notification_services.dart';
import 'package:fancy_todo_flutter/services/theme_services.dart';
import 'package:fancy_todo_flutter/ui/add_task_bar.dart';
import 'package:fancy_todo_flutter/ui/theme.dart';
import 'package:fancy_todo_flutter/ui/widgets/button.dart';
import 'package:fancy_todo_flutter/ui/widgets/task_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
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
  final _taskController = Get.put(TaskController());
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
      backgroundColor: context.theme.backgroundColor,
      body: Column(
        children: [
          _addTaskBar(), // top first layer - date & add task button
          _addDateBar(), // top second layer - date picker timeline
          const SizedBox(height: 10),
          _showTasks(), // middle layer - card list view
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
          MyButton(
            label: '+ Add Task',
            onTap: () async {
              await Get.to(() => AddTaskPage());
              _taskController.getTasks(); // refresh
            },
          ),
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
          setState(() {
            _selectedDate = date;
          });
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

  Expanded _showTasks() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
          itemCount: _taskController.taskList.length,
          itemBuilder: (_, int index) {
            Task task = _taskController.taskList[index];

            int _year = int.parse(task.date!.split('/')[2]);
            int _month = int.parse(task.date!.split('/')[0]);
            int _day = int.parse(task.date!.split('/')[1]);

            DateTime date = DateFormat.jm().parse(task.startTime.toString());
            String myTime = DateFormat('HH:mm').format(date).toString();

            int _hour = int.parse(myTime.split(':')[0]);
            int _minutes = int.parse(myTime.split(':')[1]);

            DateTime _taskDate = DateTime(_year, _month, _day, _hour, _minutes);

            if (task.date == DateFormat.yMd().format(_selectedDate)) {
              return _drawAnimationCards(task, index);
            }

            if (task.repeat != 'None' && _taskDate.isBefore(_selectedDate)) {
              DateTime _alertTime = _taskDate.subtract(Duration(minutes: task.remind!));

              notifyHelper.scheduledNotification(task, task.repeat!, _alertTime.hour, _alertTime.minute);

              if (task.repeat == 'Daily') {
                return _drawAnimationCards(task, index);
              } else if (task.repeat == 'Weekly' &&
                  DateFormat.E().format(_taskDate) == DateFormat.E().format(_selectedDate)) {
                return _drawAnimationCards(task, index);
              } else if (task.repeat == 'Monthly' && _taskDate.day == _selectedDate.day) {
                return _drawAnimationCards(task, index);
              } else {
                return Container();
              }
            } else {
              return Container();
            }
          },
        );
      }),
    );
  }

  _drawAnimationCards(Task task, int index) {
    return AnimationConfiguration.staggeredList(
      position: index,
      child: SlideAnimation(
        child: FadeInAnimation(
          child: Row(
            children: [
              GestureDetector(
                onTap: () => _showBottomSheet(context, task),
                child: TaskTile(task),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: MediaQuery.of(context).size.height * 0.40,
        color: Get.isDarkMode ? darkGreyColor : Colors.white,
        child: Column(
          children: [
            // close guide bar
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
              ),
            ),
            const Spacer(),
            _bottomSheetButton(
              context: context,
              label: task.isCompleted == 0 ? 'Task Completed' : 'Back Uncompleted',
              color: primaryColor,
              onTap: () {
                _taskController.markTaskCompleted(task.id!, task.isCompleted! == 0 ? 1 : 0);
                Get.back();
              },
            ),
            const SizedBox(height: 10),
            _bottomSheetButton(
              context: context,
              label: 'Edit Task',
              color: yellowColor,
              onTap: () async {
                await Get.to(() => AddTaskPage(task: task));
                Get.back();
              },
            ),
            const SizedBox(height: 10),
            _bottomSheetButton(
              context: context,
              label: 'Delete Task',
              color: Colors.red[300]!,
              onTap: () {
                _taskController.delete(task);
                Get.back();
              },
            ),
            const SizedBox(height: 30),
            _bottomSheetButton(
              context: context,
              label: 'Close',
              color: Colors.red[300]!,
              isClose: true,
              onTap: () => Get.back(),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  GestureDetector _bottomSheetButton({
    required context,
    required String label,
    required Color color,
    required Function()? onTap,
    bool isClose = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 45,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
              width: 2,
              color: isClose == true
                  ? Get.isDarkMode
                      ? Colors.grey[600]!
                      : Colors.grey[300]!
                  : color),
          borderRadius: BorderRadius.circular(20),
          color: isClose == true ? Colors.transparent : color,
        ),
        child: Center(
          child: Text(
            label,
            style: isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ),
        ),
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
        },
      ), // beginning of the appbar
      actions: const [
        CircleAvatar(backgroundImage: AssetImage('assets/img/profile.png')),
        SizedBox(width: 20),
      ],
    );
  }
}
