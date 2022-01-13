import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var dateController = TextEditingController();
  var titleController = TextEditingController();
  var timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            AppCubit cubit = AppCubit.get(context);
            return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.blue[900],
                title: Text(cubit.titles[cubit.currentIndex]),
              ),
              body: cubit.screens[cubit.currentIndex],
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.shifting,
                selectedItemColor: Colors.blue[900],
                unselectedItemColor: Colors.blue[900]?.withOpacity(0.3),
                selectedLabelStyle:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                currentIndex: AppCubit.get(context).currentIndex,
                showUnselectedLabels: true,
                onTap: (value) {
                  cubit.changeIndix(value);
                },
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.task),
                    label: 'Task',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline),
                    label: 'Done',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.event_note_sharp),
                    label: 'Archive',
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.blue[900],
                child: Icon(Icons.add),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: Container(
                        color: Colors.blue[900]?.withOpacity(0.1),
                        child: Form(
                          key: formKey,
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                defaultTextField(
                                    controller: titleController,
                                    keyboardType: TextInputType.text,
                                    label: 'Task title',
                                    prefixIcon: Icons.title,
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return 'title must be not empty';
                                      }
                                      return null;
                                    }),
                                SizedBox(
                                  height: 20,
                                ),
                                defaultTextField(
                                    controller: timeController,
                                    onTap: () {
                                      showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now())
                                          .then((value) {
                                        timeController.text =
                                            value!.format(context).toString();
                                      });
                                    },
                                    keyboardType: TextInputType.datetime,
                                    label: 'Task time',
                                    prefixIcon: Icons.watch_later_outlined,
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return 'time must be not empty';
                                      }
                                      return null;
                                    }),
                                SizedBox(
                                  height: 20,
                                ),
                                defaultTextField(
                                    onTap: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now(),
                                              lastDate: DateTime.now()
                                                  .add(Duration(days: 360)))
                                          .then((value) {
                                        dateController.text =
                                            DateFormat.yMMMd().format(value!);
                                      });
                                    },
                                    controller: dateController,
                                    keyboardType: TextInputType.datetime,
                                    label: 'Task date',
                                    prefixIcon: Icons.date_range_rounded,
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return 'title must be not empty';
                                      }
                                      return null;
                                    }),
                                Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Container(
                                    height: 50,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors.blue[900],
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: MaterialButton(
                                      child: Text(
                                        'Submit',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          cubit.insertToDatabase(
                                              title: titleController.text,
                                              date: dateController.text,
                                              time: timeController.text);
                                          Navigator.pop(context);
                                          //   // setState(
                                          //   //       () {
                                          //   //     currentIndex = 0;
                                          //   //     fabIcon = Icons.edit;
                                          //   //   },
                                          //   // );
                                          // });
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),
    );
  }
}
