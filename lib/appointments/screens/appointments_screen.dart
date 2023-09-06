import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:omni_dent/appointments/widgets/appointment_list_item.dart';
import 'package:omni_dent/core/services/appointments_service.dart';
import 'package:omni_dent/core/widgets/patient_avatar.dart';

class AppointmentsScreen extends StatefulWidget {
  final String doctorName = "Tala";

  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  AppointmentsService get _appointmentsService =>
      GetIt.I<AppointmentsService>();
  late List<AppointmentWithPatient> _todayAppointments = [];
  late List<AppointmentWithPatient> _laterThisWeekAppointments = [];

  @override
  void initState() {
    super.initState();
    _appointmentsService.getTodayAppointments().then((data) {
      setState(() {
        _todayAppointments = data;
      });
    });

    _appointmentsService.getLaterThisWeekAppointments().then((data) {
      setState(() {
        _laterThisWeekAppointments = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Full screen width and height
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

// Height (without SafeArea)
    var padding = MediaQuery.of(context).viewPadding;
    double height1 = height - padding.top - padding.bottom;

// Height (without status bar)
    double height2 = height - padding.top;

// Height (without status and toolbar)
    double height3 = height - padding.top - kToolbarHeight;
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Good morning, Dr. ${widget.doctorName}!',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'You have ${_todayAppointments.length} appointments today.',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _todayAppointments.length,
              itemBuilder: (context, index) {
                return AppointmentListItem(
                  item: _todayAppointments[index],
                  index: index,
                );
              },
            ),
            SizedBox(height: 24.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Later This Week',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.grey,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _laterThisWeekAppointments.length,
              itemBuilder: (context, index) {
                final appointment =
                    _laterThisWeekAppointments[index].appointment;
                final formattedDate =
                    DateFormat('E, MMM d, y').format(appointment.dateTimeFrom);
                if (index == 0 ||
                    appointment.dateTimeFrom.day !=
                        _laterThisWeekAppointments[index - 1]
                            .appointment
                            .dateTimeFrom
                            .day) {
                  // Return a separator with the date
                  return Column(
                    children: [
                      ListTile(
                        title: Center(
                            child: Text(
                          formattedDate,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey,
                          ),
                        )),
                      ),
                      AppointmentListItem(
                          item: _laterThisWeekAppointments[index],
                          index: index),
                    ],
                  );
                } else {
                  return AppointmentListItem(
                    item: _laterThisWeekAppointments[index],
                    index: index,
                  );
                }
              },
            ),
            SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }
}
