import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/modules/archived_tasks/archived_task_screen.dart';
import 'package:to_do_app/modules/done_tasks/done_task_screen.dart';
import 'package:to_do_app/modules/new_tasks/new_task_screen.dart';
import 'package:to_do_app/shared/components/constants.dart';

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
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  GlobalKey<FormState> formKey = GlobalKey();
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    createDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          titles[currentIndex],
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: tasks.isEmpty
          ? Center(child: CircularProgressIndicator())
          : screens[currentIndex],
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: Colors.blue,
        elevation: 0,
        onPressed: () {
          if (isBottomSheetShown) {
            if (formKey.currentState!.validate()) {
              insertToDataBase().then((value) {
                Navigator.pop(context);
                timeController.clear();
                dateController.clear();
                titleController.clear();
                isBottomSheetShown = false;
                getDataFromDatabase(database).then((value) {
                  setState(() {
                    tasks = value;
                    fabIcon = Icons.edit;
                  });
                });
              });
            }
          } else {
            scaffoldKey.currentState!
                .showBottomSheet((context) {
                  return Container(
                    padding: EdgeInsets.all(20),
                    color: Colors.grey.withValues(alpha: .05),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: titleController,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Field Required';
                              }
                              return null;
                            },
                            cursorColor: Colors.blue,
                            decoration: InputDecoration(
                              hintText: 'Task Title',
                              prefixIcon: Icon(
                                Icons.text_fields_outlined,
                                color: Colors.grey,
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 1.5,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(width: 1.5),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),

                          TextFormField(
                            controller: timeController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Field Required';
                              }
                              return null;
                            },
                            readOnly: true,
                            cursorColor: Colors.blue,
                            onTap: () {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ).then((value) {
                                timeController.text = value!
                                    .format(context)
                                    .toString();
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Task Time',
                              prefixIcon: Icon(
                                Icons.watch_later_rounded,
                                color: Colors.grey,
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 1.5,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(width: 1.5),
                              ),
                            ),
                          ),

                          SizedBox(height: 15),

                          TextFormField(
                            controller: dateController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Field Required';
                              }

                              return null;
                            },
                            readOnly: true,
                            cursorColor: Colors.blue,
                            onTap: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.parse('2030-12-31'),
                              ).then((value) {
                                dateController.text = DateFormat.yMMMEd()
                                    .format(value!);
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Task Date',
                              prefixIcon: Icon(
                                Icons.calendar_month_rounded,
                                color: Colors.grey,
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 1.5,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(width: 1.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                })
                .closed
                .then((value) {
                  isBottomSheetShown = false;
                  setState(() {
                    fabIcon = Icons.edit;
                  });
                });
            isBottomSheetShown = true;
            setState(() {
              fabIcon = Icons.add;
            });
          }
        },
        child: Icon(fabIcon, color: Colors.white),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
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
      onOpen: (database) {
        getDataFromDatabase(database).then((value) {
          setState(() {
            tasks = value;
          });
        });
      },
      onCreate: (database, version) async {
        await database.execute(
          'create table tasks (id integer primary key , title text , date text , time text ,status text)',
        );
      },
      version: 1,
    );
  }

  Future insertToDataBase() async {
    return await database.transaction((action) async {
      return await action.rawInsert(
        'insert into tasks (title,date,time,status) values ("${titleController.text}","${dateController.text}","${timeController.text}","new")',
      );
    });
  }

  Future<List<Map>> getDataFromDatabase(Database database) async {
    return await database.rawQuery('select * from tasks');
  }
}
