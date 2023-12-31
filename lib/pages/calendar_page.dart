import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../bloc/notes_bloc.dart';
import '../bloc/notes_event.dart';
import '../bloc/notes_state.dart';
import '../notifi/notifi.dart';
import '../sql_directory/note_model.dart';
import 'note_page.dart';

class CalendarPage extends StatefulWidget {
  final NoteModel? noteModel;

  const CalendarPage({Key? key, this.noteModel}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat format = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  final DateTime _dateTime = DateTime.now();
  late bool _dayChangeMode;
  late DateFormat dateFormat;
  late DateTime currentMonth;
  late DateFormat dayOfWeekFormat;
  late DateTime currentDay;

  Map<DateTime, List<NoteModel>> events = {};

  @override
  void initState() {
    super.initState();
    _dayChangeMode = false;
    dateFormat = DateFormat('MMMM');
    currentMonth = _dateTime;
    dayOfWeekFormat = DateFormat('EEEE');
    currentDay = _dateTime;
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
        actions: [
          IconButton(
              onPressed: () {
                NotificationService().showNotification(
                    title: 'Warning!', body: 'You create note', id: 1);
              },
              icon: const Icon(Icons.message))
        ],
      ),
      drawer: buildDrawer(),
      body: BlocBuilder<NotesBloc, NotesState>(
        builder: (context, state) {
          if (state is NotesLoadSuccess) {
            events.clear();
            for (var note in state.todoList) {
              final date = note.remainingDate;
              if (events[date] == null) {
                events[date] = [];
              }
              events[date]!.add(note);
            }
            if (state.todoList.isEmpty) {
              return SingleChildScrollView(
                child: Column(
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
                    const SizedBox(
                      height: 50,
                    ),
                    const SizedBox(
                      height: 200,
                      child: Center(
                        child: Text(
                          'To add a note press " + "',
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
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
                          key: Key(itemData.id!),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NotePage(noteModel: itemData),
                                ),
                              );
                            },
                            child: Card(
                              color: Colors.blue,
                              child: ListTile(
                                leading: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      itemData.remainingDate
                                          .toString()
                                          .substring(0, 10),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  itemData.description!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_sweep_outlined,
                                      color: Colors.white),
                                  onPressed: () {
                                    _onDelete(context, itemData.id!);
                                  },
                                ),
                              ),
                            ),
                          ),
                          onDismissed: (direction) {
                            _onDelete(context, itemData.id!);
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            }
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
              builder: (context) =>
                  NotePage(noteModel: NoteModel(remainingDate: _selectedDay)),
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
      eventLoader: (day) {
        return _getEventsForDay(day);
      },
      selectedDayPredicate: (DateTime date) {
        return isSameDay(_selectedDay, date);
      },
      calendarStyle: CalendarStyle(
        weekendTextStyle: TextStyle(
          fontSize: 15,
          color: Colors.indigo[900],
          fontWeight: FontWeight.w500,
        ),
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
                    setState(
                      () {
                        _dayChangeMode = value;
                      },
                    );
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

  List<NoteModel> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }
}
