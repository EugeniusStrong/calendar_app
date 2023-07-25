import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../bloc/notes_bloc.dart';
import '../bloc/notes_event.dart';
import '../sql_directory/note_model.dart';

class NotePage extends StatefulWidget {
  final NoteModel? noteModel;

  const NotePage({Key? key, this.noteModel}) : super(key: key);

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late TextEditingController _noteController;
  late DateFormat dateFormat;
  late DateTime currentMonth;
  late DateFormat dayOfWeekFormat;
  late DateTime currentDay;
  static const _uuid = Uuid();

  @override
  void initState() {
    super.initState();
    dateFormat = DateFormat('MMMM');
    currentMonth = widget.noteModel!.remainingDate;
    dayOfWeekFormat = DateFormat('EEEE');
    currentDay = widget.noteModel!.remainingDate;
    _noteController =
        TextEditingController(text: widget.noteModel!.description);
  }

  @override
  void dispose() {
    super.dispose();
    _noteController;
  }

  @override
  Widget build(BuildContext context) {
    final monthName = dateFormat.format(currentMonth);
    final dayOfWeekName = dayOfWeekFormat.format(currentDay);

    return BlocProvider<NotesBloc>(
      create: (context) => BlocProvider.of<NotesBloc>(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create your note'),
          centerTitle: true,
        ),
        body: Form(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                '${currentDay.day} $monthName $dayOfWeekName',
                style: const TextStyle(fontSize: 30),
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                maxLines: 5,
                controller: _noteController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Enter note',
                  hintText: 'Enter note here',
                  suffixIcon: IconButton(
                    onPressed: () {
                      _noteController.clear();
                    },
                    icon: const Icon(Icons.delete_outline_outlined),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: () {
                  final id = widget.noteModel?.id ?? _uuid.v4();
                  final notesBloc = BlocProvider.of<NotesBloc>(context);
                  notesBloc.add(
                    NotesSaveRequested(
                      id: id,
                      remainingDate: widget.noteModel!.remainingDate,
                      description: _noteController.text,
                    ),
                  );
                  Navigator.pop(context);
                  _noteController.clear();
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
                ),
                child: const Text(
                  'Add note',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
