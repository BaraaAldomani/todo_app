import 'package:flutter/material.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

Widget defaultTextField({
  required TextEditingController controller,
  required TextInputType keyboardType,
  required String label,
  required IconData prefixIcon,
  required String? Function(String?)? validate,
  Function(String)? onSubmit,
  Function()? onTap,
  IconData? suffixIcon,
}) =>
    TextFormField(
      onTap: onTap,
      enabled: true,
      controller: controller,
      keyboardType: keyboardType,
      onFieldSubmitted: onSubmit,
      validator: validate,
      decoration: InputDecoration(
          label: Text(label),
          prefixIcon: Icon(prefixIcon),
          suffixIcon: Icon(suffixIcon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
    );

Widget buildTaskCard({required Map task, required context}) => Dismissible(
  direction: DismissDirection.endToStart,
      background: Container(
        child: Padding(padding: EdgeInsets.only(left: 300, top: 50),child: Text('DELETE',style: TextStyle(color: Colors.white,fontSize: 20),)),
        color: Colors.red[900],
      ),
      key: Key(task['id'].toString()),
      onDismissed: (direction) {
        AppCubit.get(context).deleteDatabase(id: task['id']);
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              maxRadius: 50,
              child: Text('${task['time']}'),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${task['title']}',
                    style: TextStyle(fontSize: 25),
                  ),
                  Text(
                    '${task['date']}',
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateDatabase(states: 'done', id: task['id']);
              },
              icon: Icon(
                Icons.check_box,
                color: Colors.green[900],
              ),
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateDatabase(states: 'archive', id: task['id']);
              },
              icon: Icon(
                Icons.archive_outlined,
                color: Colors.red[900],
              ),
            ),
          ],
        ),
      ),
    );
