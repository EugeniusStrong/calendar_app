import 'package:calendar_app/pages/calendar_page.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class NotePage extends StatefulWidget {
  final String dateReception;
  final String dateUpdateReception;

  const NotePage(
      {super.key,
      required this.dateReception,
      required this.dateUpdateReception});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final TextEditingController _datePickerController = TextEditingController();
  final TextEditingController _receptionDateController =
      TextEditingController();
  final TextEditingController _receptionUpdateDateController =
      TextEditingController();
  CalendarFormat format = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _receptionDateController.text = widget.dateReception;
    _receptionUpdateDateController.text = widget.dateUpdateReception;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create your note'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CalendarPage(),
              ),
            );
          },
        ),
      ),
      body: Form(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _receptionUpdateDateController.text.isNotEmpty
                  ? _receptionUpdateDateController
                  : _receptionDateController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Select date',
                suffixIcon: IconButton(
                  onPressed: () {
                    _showInputForm();
                  },
                  icon: const Icon(Icons.calendar_month),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              maxLines: 5,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Enter note',
                hintText: 'Enter note here',
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.delete_outline_outlined),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CalendarPage(),
                  ),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
              ),
              child: const Text(
                'Add note',
                style: TextStyle(fontSize: 20),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showInputForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TableCalendar(
                    focusedDay: _selectedDay,
                    calendarFormat: format,
                    firstDay: DateTime(1989),
                    lastDay: DateTime(2050),
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    daysOfWeekVisible: true,
                    onDaySelected: (DateTime selectDay, _) {
                      setState(() {
                        _selectedDay = selectDay;
                        _datePickerController.text =
                            selectDay.toString().substring(0, 10);
                      });
                    },
                    selectedDayPredicate: (DateTime date) {
                      return isSameDay(_selectedDay, date);
                    },
                    calendarStyle: CalendarStyle(
                      weekendTextStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.indigo[900],
                          fontWeight: FontWeight.w500),
                      isTodayHighlighted: true,
                      todayDecoration: BoxDecoration(
                        color: Colors.blueGrey[600],
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      selectedTextStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.green[700],
                      ),
                      weekendStyle: TextStyle(
                        fontSize: 15,
                        color: Colors.indigo[900],
                      ),
                    ),
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: _datePickerController.text.isEmpty
                          ? const Text('')
                          : const Text(
                              'Select day:',
                              style: TextStyle(fontSize: 18),
                            ),
                      subtitle: Text(
                        _datePickerController.text,
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('CANCEL'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          String dateUpdateTransfer =
                              _datePickerController.text;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotePage(
                                dateReception: '',
                                dateUpdateReception: dateUpdateTransfer,
                              ),
                            ),
                          );
                        },
                        child: const Text('ADD'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
