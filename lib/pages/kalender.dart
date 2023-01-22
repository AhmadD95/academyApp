import 'package:academy/pages/event_editing.dart';
import 'package:academy/widgets/bottom_nav_bar.dart';
import 'package:academy/widgets/navigation_drawer.dart';
import 'package:academy/widgets/on_pressed.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../helper/events_data_source.dart';
import '../provider/event_provider.dart';

class CalenderWidget extends StatelessWidget {
  const CalenderWidget({Key? key}) : super(key: key);

  static const routeName = '/calenderPage';

  @override
  Widget build(BuildContext context) {
    final events = Provider.of<EventProvider>(context).events;

    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(),
        backgroundColor: Color.fromARGB(255, 1, 138, 190),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                nextScreen(context, EventEditingPage());
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      bottomNavigationBar: ButtomNavBar(index: 2),
      extendBodyBehindAppBar: false,
      drawer: NavigationDrawerNav(),
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 1, 138, 190),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 249, 249, 249),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SfCalendar(
            backgroundColor: Colors.transparent,
            dataSource: EventDataSource(events),
            initialSelectedDate: DateTime.now(),
            view: CalendarView.month,
            firstDayOfWeek: 1,
            headerHeight: 70,
            monthViewSettings: MonthViewSettings(
              showAgenda: true,
              appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
            ),
            headerStyle: CalendarHeaderStyle(
              textAlign: TextAlign.center,
              textStyle: TextStyle(
                fontSize: 25,
                fontStyle: FontStyle.normal,
              ),
            ),
            cellBorderColor: Colors.transparent,
            todayHighlightColor: Color.fromARGB(255, 1, 138, 190),
            selectionDecoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromARGB(255, 1, 138, 190),
                  width: 1,
                ),
                borderRadius: BorderRadius.all(Radius.circular(5))),
          ),
        ),
      ),
    ); // Scaffold
  }
}
