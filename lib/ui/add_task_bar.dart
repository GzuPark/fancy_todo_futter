import 'package:fancy_todo_flutter/ui/theme.dart';
import 'package:fancy_todo_flutter/ui/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddTaskPage extends StatelessWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      backgroundColor: context.theme.backgroundColor,
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add Task', style: headingStyle),
              InputField(title: 'Title', hint: 'Enter your title'),
              InputField(title: 'Note', hint: 'Enter your note '),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.backgroundColor,
      leading: GestureDetector(
        onTap: () => Get.back(),
        child: Icon(
          Icons.arrow_back_ios,
          color: Get.isDarkMode ? Colors.white : Colors.black,
          size: 20,
        ),
      ),
      actions: const [
        CircleAvatar(backgroundImage: AssetImage('assets/img/profile.png')),
        SizedBox(width: 20),
      ],
    );
  }
}
