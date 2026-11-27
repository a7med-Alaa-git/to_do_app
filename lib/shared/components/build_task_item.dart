import 'package:flutter/material.dart';

class BuildTaskItem extends StatelessWidget {
  const BuildTaskItem({super.key, required this.tasks});
  final Map tasks;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blue,
            child: Text(
              '${tasks['time']}',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: 18),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${tasks['title']}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              Text('${tasks['date']}', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
