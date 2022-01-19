import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotifiedPage extends StatelessWidget {
  final String? label;

  const NotifiedPage({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Get.isDarkMode ? Colors.grey[600] : Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Get.isDarkMode ? Colors.white : Colors.grey),
          onPressed: () => Get.back(),
        ),
        title: Text(
          label.toString().split('|')[0],
          style: TextStyle(color: Get.isDarkMode ? Colors.white : Colors.black),
        ),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          height: 400,
          width: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Get.isDarkMode ? Colors.white : Colors.grey[400],
          ),
          child: Center(
            child: Text(
              label.toString().split('|')[1],
              style: TextStyle(
                fontSize: 30,
                color: Get.isDarkMode ? Colors.black : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
