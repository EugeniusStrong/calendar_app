import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotePage extends StatefulWidget {
  final DateTime dateFromCalendarPage;

  const NotePage({super.key, required this.dateFromCalendarPage});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late TextEditingController _noteController;
  late DateFormat dateFormat;
  late DateTime currentMonth;
  late DateFormat dayOfWeekFormat;
  late DateTime currentDay;

  @override
  void initState() {
    super.initState();
    dateFormat = DateFormat('MMMM');
    currentMonth = widget.dateFromCalendarPage;
    dayOfWeekFormat = DateFormat('EEEE');
    currentDay = widget.dateFromCalendarPage;
    _noteController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final monthName = dateFormat.format(currentMonth);
    final dayOfWeekName = dayOfWeekFormat.format(currentDay);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create your note'),
        centerTitle: true,
      ),
      body: Form(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextButton(
              onPressed: () {},
              child: Text(
                '${currentDay.day.toString()} $monthName $dayOfWeekName',
                style: const TextStyle(fontSize: 30),
              ),
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
                Navigator.pop(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              ),
              child: const Text(
                'Add note',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
