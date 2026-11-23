import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
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
  late Database database;

  @override
  void initState() {
    super.initState();
    createDataBase();
  }

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
        onPressed: () {
          insertToDataBase();
        },
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

  void createDataBase() async {
    database = await openDatabase(
      'todo.db',
      onOpen: (database) {},
      onCreate: (database, version) async {
        await database.execute(
          'create table tasks (id integer primary key , title text , date text , time text ,status text)',
        );
      },
      version: 1,
    );
  }

  void insertToDataBase() {
    database
        .transaction((action) {
          return action.rawInsert(
            'insert into tasks (title, date,time,status) values ("new task","24/11/2026","12:26","new")',
          );
        })
        .then((va) {
          print("$va success");
        })
        .catchError((err) {
          print(err.toString());
        });
  }
}
