import 'package:calendar_app/pages/note_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../bloc/notes_bloc.dart';
import '../bloc/notes_event.dart';
import '../bloc/notes_state.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat format = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  bool _dayChangeMode = false;
  late DateFormat dateFormat;
  late DateTime currentMonth;
  late DateFormat dayOfWeekFormat;
  late DateTime currentDay;

  @override
  void initState() {
    super.initState();
    _dayChangeMode = false;
    dateFormat = DateFormat('MMMM');
    currentMonth = DateTime.now();
    dayOfWeekFormat = DateFormat('EEEE');
    currentDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final monthName = dateFormat.format(currentMonth);
    final dayOfWeekName = dayOfWeekFormat.format(currentDay);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Month'),
        centerTitle: true,
      ),
      drawer: buildDrawer(),
      body: BlocBuilder<NotesBloc, NotesState>(
        builder: (context, state) {
          if (state is NotesLoadSuccess) {
            if (state.todoList.isEmpty) {
              return Column(
                children: [
                  buildCalendar(),
                  Container(
                    decoration: const BoxDecoration(color: Colors.blue),
                    child: ListTile(
                      leading: Text(_selectedDay.day.toString(),
                          style: const TextStyle(
                            fontSize: 43,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                          )),
                      title: Text(monthName),
                      subtitle: Text(dayOfWeekName),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Icon(
                        Icons.create,
                        size: 100,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'To add a note press +',
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ],
              );
            }
            return Column(
              children: [
                buildCalendar(),
                Container(
                  decoration: const BoxDecoration(color: Colors.blue),
                  child: ListTile(
                    leading: Text(
                      _selectedDay.day.toString(),
                      style: const TextStyle(
                        fontSize: 43,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    title: Text(monthName),
                    subtitle: Text(dayOfWeekName),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.todoList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final itemData = state.todoList[index];
                      return Dismissible(
                        key: Key(itemData.id.toString()),
                        child: Card(
                          color: Colors.blue[300],
                          child: ListTile(
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  itemData.remainingDate
                                      .toString()
                                      .substring(0, 10),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ],
                            ),
                            title: TextButton(
                              onPressed: () {},
                              child: Text(
                                itemData.description,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_sweep_outlined,
                                  color: Colors.black54),
                              onPressed: () {
                                _onDelete(context, itemData.id);
                              },
                            ),
                          ),
                        ),
                        onDismissed: (direction) {
                          _onDelete(context, itemData.id);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotePage(
                dateFromCalendarPage: _selectedDay,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildCalendar() {
    return TableCalendar(
      focusedDay: _selectedDay,
      calendarFormat: format,
      firstDay: DateTime(1989),
      lastDay: DateTime(2050),
      startingDayOfWeek:
          _dayChangeMode ? StartingDayOfWeek.sunday : StartingDayOfWeek.monday,
      daysOfWeekVisible: true,
      onDaySelected: (DateTime selectedDay, _) {
        setState(() {
          _selectedDay = selectedDay;
          currentDay = selectedDay;
          currentMonth = selectedDay;
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
    );
  }

  Widget buildDrawer() {
    return Drawer(
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
    );
  }

  void _onDelete(BuildContext context, String id) {
    BlocProvider.of<NotesBloc>(context).add(NotesDeleteRequested(id));
  }
}
