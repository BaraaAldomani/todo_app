import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archive_task/archive_task_screen.dart';
import 'package:todo_app/modules/done_task/done_task_screen.dart';
import 'package:todo_app/modules/new_task/new_task_screen.dart';
import 'package:todo_app/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppinitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = [
    NewTask(),
    DoneTask(),
    ArchivedTask(),
  ];
  List<String> titles = [
    'New Task',
    'Done task',
    'Archive Task',
  ];

  void changeIndix(int index) {
    currentIndex = index;
    emit(AppChangeBottomSheetState());
  }

  late Database database;
  List<Map> newTask = [];
  List<Map> doneTask = [];
  List<Map> archivedTask = [];

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (
        database,
        version,
      ) {
        print('database created');
        database
            .execute(
                'CREATE TABLE task (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print('table created');
        }).catchError((error) {
          print('error was ${error.toString()}');
        });
      },
      onOpen: (database) {
        print('database is opened');
        getDataFormeDB(database);
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  void insertToDatabase(
      {required String title,
      required String date,
      required String time}) async {
    return await database.transaction((txn) async {
      txn
          .rawInsert(
        'INSERT INTO task ( title, date, time, status ) VALUES( "$title", "$date", "$time", "new" )',
      )
          .then((value) {
        print('inserted  successfuly');
      }).catchError((error) {
        print('error when inserting  $error');
      });
    }).then((value) {
      getDataFormeDB(database);
    });
  }

  void getDataFormeDB(database)  {
    newTask = [];
    doneTask = [];
    archivedTask = [];
    database.rawQuery('Select * FROM task').then((value) {
      value.forEach((element) {
        if(element['status']=='new') { newTask.add(element);}
        else if(element['status']=='done') { doneTask.add(element);}
        else{ archivedTask.add(element);}
      });
      emit(AppGetDatabaseState());
    });
  }

  void updateDatabase({
    String ?states,
    required int id,
  }) async {database.rawUpdate(
      'UPDATE task SET status = ? WHERE id = ?',
      ['$states', id],
    ).then((value) {
      getDataFormeDB(database);
    emit(AppUpdateDatabaseState());
  });
  }
  void deleteDatabase({
    required int id,
  }) async {database.rawDelete('DELETE FROM task WHERE id = ?' , [id]
    ).then((value) {
      getDataFormeDB(database);
    emit(AppDeleteDatabaseState());
  });
  }
}
