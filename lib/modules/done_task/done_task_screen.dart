import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class DoneTask extends StatelessWidget {
  const DoneTask({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        List task = AppCubit
            .get(context)
            .doneTask;
        if (task.isNotEmpty) {
          return ListView.separated(
              itemBuilder: (context, index) =>
                  buildTaskCard(context: context, task: task[index]),
              separatorBuilder: (context, index) => Container(
                height: 1,
                width: double.infinity - 5,
                color: Colors.grey[300],
              ),
              itemCount: task.length);
        } else {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.task_sharp,
                  size: 50,
                  color: Colors.blue[900]!.withOpacity(0.4),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(

                  'please add some tasks',
                  style: TextStyle(fontSize: 20,color: Colors.blue[900]!.withOpacity(0.4)),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}