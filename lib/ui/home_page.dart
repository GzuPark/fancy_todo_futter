import 'package:fancy_todo_flutter/services/theme_services.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        },
      ), // beginning of the appbar
      actions: const [
        Icon(Icons.person, size: 20),
        SizedBox(width: 20),
      ],
    );
  }
}
