import 'package:equatable/equatable.dart';

abstract class NotesEvent extends Equatable {
  @override
  bool? get stringify => true;
}

class NotesAppStarted extends NotesEvent {
  @override
  List<Object?> get props => const [];
}

class NotesSaveRequested extends NotesEvent {
  final String description;
  final DateTime remainingDate;

  NotesSaveRequested({required this.remainingDate, required this.description});

  @override
  List<Object?> get props => [description, remainingDate];
}

class NotesDeleteRequested extends NotesEvent {
  final String id;

  NotesDeleteRequested(this.id);

  @override
  List<Object?> get props => [id];
}
