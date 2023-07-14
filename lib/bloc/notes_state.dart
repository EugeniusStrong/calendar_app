import 'package:calendar_app/sql_directory/note_model.dart';
import 'package:equatable/equatable.dart';

abstract class NotesState extends Equatable {}

class NoteInitial extends NotesState {
  @override
  List<Object?> get props => [];
}

class NotesLoadSuccess extends NotesState {
  final List<NoteModel> todoList;

  NotesLoadSuccess({required this.todoList});

  @override
  List<Object?> get props => [todoList];
}
