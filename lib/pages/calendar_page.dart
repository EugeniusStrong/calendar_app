import 'package:calendar_app/pages/note_page.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late TextEditingController _datePickerController;
  CalendarFormat format = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  bool _dayChangeMode = false;

  @override
  void initState() {
    super.initState();
    _datePickerController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Month'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              subtitle: const Text('Select the start day of the week'),
              title: Row(
                children: [
                  _dayChangeMode
                      ? const Text('Select start day (SUNDAY)')
                      : const Text('Select start day (MONDAY)'),
                  const Spacer(),
                  Switch(
                    value: _dayChangeMode,
                    onChanged: (value) {
                      setState(() {
                        _dayChangeMode = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _selectedDay,
            calendarFormat: format,
            firstDay: DateTime(1989),
            lastDay: DateTime(2050),
            startingDayOfWeek: _dayChangeMode
                ? StartingDayOfWeek.sunday
                : StartingDayOfWeek.monday,
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
            child: Container(
              decoration: const BoxDecoration(color: Colors.grey),
              child: ListTile(
                title: _datePickerController.text.isEmpty
                    ? const Text('')
                    : const Text('Select day:'),
                subtitle: Text(_datePickerController.text),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String dateTransfer = _datePickerController.text;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotePage(
                dateReception: dateTransfer,
                dateUpdateReception: '',
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
