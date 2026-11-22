import 'package:flutter/material.dart';
import 'package:to_do_app/modules/archived_tasks/archived_task_screen.dart';
import 'package:to_do_app/modules/done_tasks/done_task_screen.dart';
import 'package:to_do_app/modules/new_tasks/new_task_screen.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 0;
  List<Widget> screens = [
    NewTaskScreen(),
    DoneTaskScreen(),
    ArchivedTaskScreen(),
  ];
  List<String> titles = ['New Tasks', 'Done Tasks', 'Archived Tasks'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          titles[currentIndex],
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: screens[currentIndex],
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: Colors.blue,
        elevation: 0,
        onPressed: () {},
        child: Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline_outlined),
            label: 'Done',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.archive_outlined),
            label: 'Archived',
          ),
        ],
        selectedItemColor: Colors.blue,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
