import 'package:flutter/material.dart';
import 'package:to_do_app/shared/components/build_task_item.dart';
import 'package:to_do_app/shared/components/constants.dart';

// ignore: must_be_immutable
class NewTaskScreen extends StatelessWidget {
  const NewTaskScreen({super.key});



  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) => BuildTaskItem(tasks: tasks[index],),
      separatorBuilder: (context, index) => Padding(
        padding: const EdgeInsetsDirectional.only(start: 20),
        child: Container(width: double.infinity, height: 1, color: Colors.grey),
      ),
      itemCount: tasks.length,
    );
  }
}
