import 'package:fancy_todo_flutter/db/db_helper.dart';
import 'package:fancy_todo_flutter/models/task.dart';
import 'package:get/get.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    getTasks();
  }

  var taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) async {
    return await DBHelper.insert(task);
  }

  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  Future<void> updateTask({Task? task}) async {
    await DBHelper.update(task);
    getTasks();
  }

  void delete(Task task) {
    DBHelper.delete(task);
    getTasks();
  }

  void markTaskCompleted(int id, int isCompleted) async {
    await DBHelper.updateIsCompleted(id, isCompleted);
    getTasks();
  }
}
