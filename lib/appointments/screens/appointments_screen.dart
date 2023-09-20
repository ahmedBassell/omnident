import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:omni_dent/appointments/widgets/appointment_list_item.dart';
import 'package:omni_dent/core/services/appointments_service.dart';
import 'package:omni_dent/core/services/empty_states_service.dart';
import 'package:omni_dent/core/widgets/appointment_creation_form.dart';

class AppointmentsScreen extends StatefulWidget {
  final String doctorName = "Tala";

  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  AppointmentsService get _appointmentsService =>
      GetIt.I<AppointmentsService>();
  EmptyStatesService get _emptyStatesService => GetIt.I<EmptyStatesService>();
  late List<AppointmentWithPatient> _todayAppointments = [];
  late List<AppointmentWithPatient> _laterThisWeekAppointments = [];
  late StreamSubscription<List<AppointmentWithPatient>>
      _todayAppointmentsSubscription;
  late StreamSubscription<List<AppointmentWithPatient>>
      _laterAppointmentsSubscription;
  String _todayEmptyStateCopy = "";
  String _weekEmptyStateCopy = "";

  @override
  void initState() {
    super.initState();
    _todayAppointmentsSubscription =
        _appointmentsService.watchTodayAppointments().listen((data) {
      setState(() {
        _todayAppointments = data;
      });
    });

    _laterAppointmentsSubscription =
        _appointmentsService.watchLaterThisWeekAppointments().listen((data) {
      setState(() {
        _laterThisWeekAppointments = data;
      });
    });

    setState(() {
      _todayEmptyStateCopy =
          _emptyStatesService.generateTodayAppointmentsEmptyState();
      _weekEmptyStateCopy =
          _emptyStatesService.generateWeekAppointmentsEmptyState();
    });
  }

  @override
  void dispose() {
    _todayAppointmentsSubscription.cancel();
    _laterAppointmentsSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: Text(
            //     'Good morning, Dr. ${widget.doctorName}!',
            //     style: TextStyle(
            //       fontSize: 24.0,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
            SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'You have ${_todayAppointments.length} appointments today',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            _todayAppointments.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _todayAppointments.length,
                    itemBuilder: (context, index) {
                      return AppointmentListItem(
                        item: _todayAppointments[index],
                        index: index,
                      );
                    },
                  )
                : Column(
                    children: [
                      SizedBox(height: 64.0),
                      Center(
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 4.0),
                          child: Text(
                            _todayEmptyStateCopy,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _openAppointmentForm();
                        },
                        child: Text('Add an Appointment'),
                      ),
                      SizedBox(height: 16.0),
                    ],
                  ),
            SizedBox(height: 24.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Later This Week',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            _laterThisWeekAppointments.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _laterThisWeekAppointments.length,
                    itemBuilder: (context, index) {
                      final appointment =
                          _laterThisWeekAppointments[index].appointment;
                      final formattedDate = DateFormat('E, MMM d, y')
                          .format(appointment.dateTimeFrom);
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
                                ),
                              ),
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
                  )
                : Column(
                    children: [
                      SizedBox(height: 64.0),
                      Center(
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 4.0),
                          child: Text(
                            _weekEmptyStateCopy,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _openAppointmentForm();
                        },
                        child: Text('Add an Appointment'),
                      ),
                      SizedBox(height: 16.0),
                    ],
                  ),
            SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }

  Future<void> _openAppointmentForm() {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
                8.0, 8.0, 8.0, MediaQuery.of(context).viewInsets.bottom),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[AppointmentCreationForm()]));
      },
    ).whenComplete(() {});
  }
}
