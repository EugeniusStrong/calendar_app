import 'package:calendar_app/bloc/notes_event.dart';
import 'package:calendar_app/pages/calendar_page.dart';
import 'package:calendar_app/sql_directory/database.dart';
import 'package:calendar_app/sql_directory/note_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/notes_bloc.dart';

void main() {
  runApp(
    BlocProvider<NotesBloc>(
      create: (context) =>
          NotesBloc(DBProvider.db, NoteModel(remainingDate: DateTime.now()))
            ..add(NotesAppStarted()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CalendarPage(),
    );
  }
}
