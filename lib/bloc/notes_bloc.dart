import 'package:calendar_app/sql_directory/note_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../sql_directory/database.dart';
import 'notes_event.dart';
import 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  static const _uuid = Uuid();
  final DBProvider db;
  final NoteModel? input;

  NotesBloc(this.db, this.input) : super(NoteInitial()) {
    on<NotesDeleteRequested>((event, emit) async {
      await _deleteNote(event.id, emit);
    });
    on<NotesSaveRequested>((event, emit) async {
      await _saveNote(event.description, event.remainingDate, emit);
    });
    on<NotesAppStarted>((event, emit) async {
      await _loadData(emit);
    });
  }

  /// Удаление записи с указанным идентификатором.
  ///
  /// Выполняет операцию удаления заметки, обновления списка заметок.
  /// Далее, с помощью функции emit эмитируется событие NotesLoadSuccess
  /// для обновления пользовательского интерфейса с новым списком заметок.
  Future<void> _deleteNote(String id, Emitter<NotesState> emit) async {
    await db.deleteNote(id);
    final notesList = await db.getNotes();
    emit(NotesLoadSuccess(todoList: notesList));
  }

  /// Сохранение/обновление записи.
  ///
  /// Создается уникальный идентификатор для заметки с помощью библиотеки uuid.
  /// Затем вызывается метод insertOrUpdate базы данных для сохранения или обновления заметки.
  /// После этого получается список всех заметок из базы данных с помощью метода getNotes.
  /// Далее, с помощью функции emit эмитируется событие NotesLoadSuccess
  /// для обновления пользовательского интерфейса с новым списком заметок.
  Future<void> _saveNote(String? description, DateTime remainingDate,
      Emitter<NotesState> emit) async {
    final id = input?.id ?? _uuid.v4();
    await db.insertOrUpdate(
        id: id, description: description, remainingDate: remainingDate);
    final notesList = await db.getNotes();
    emit(NotesLoadSuccess(todoList: notesList));
  }

  /// Загружает список заметок.
  ///
  /// Эмитируется событие для отображения списка заметок.
  Future<void> _loadData(Emitter<NotesState> emit) async {
    final notesList = await db.getNotes();
    emit(NotesLoadSuccess(todoList: notesList));
  }
}
