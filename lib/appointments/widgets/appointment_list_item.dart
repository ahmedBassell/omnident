import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:omni_dent/core/services/appointments_service.dart';
import 'package:omni_dent/core/services/patients_service.dart';
import 'package:omni_dent/core/services/utils_service.dart';
import 'package:omni_dent/core/widgets/appointment_creation_form.dart';
import 'package:omni_dent/core/widgets/patient_avatar.dart';
import 'package:intl/intl.dart';
import 'package:omni_dent/database/database.dart';
import 'package:omni_dent/patients/screens/patient_screen.dart';

class AppointmentListItem extends StatefulWidget {
  final AppointmentWithPatient item;
  final int index;
  const AppointmentListItem(
      {super.key, required this.item, required this.index});

  @override
  _AppointmentListItemState createState() => _AppointmentListItemState();
}

class _AppointmentListItemState extends State<AppointmentListItem> {
  PatientsService get _patientsService => GetIt.I<PatientsService>();
  UtilsService get _utilsService => GetIt.I<UtilsService>();
  @override
  Widget build(BuildContext context) {
    // Replace with your appointment data
    Appointment _appointment = widget.item.appointment;
    Patient _patient = widget.item.patient;
    String time = DateFormat.jm().format(_appointment.dateTimeFrom);
    String patientName = _patient.name;
    int age = _patientsService.calculateAge(_patient);
    String sex = _utilsService.capitalize(_patient.gender.name);

    return Container(
      margin: EdgeInsets.fromLTRB(16.0, 16, 16, 0),
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      // color: Colors.red,
      child: Row(
        children: [
          Text(
            time,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 12.0),
          Expanded(
            // Wrap the Row with Expanded
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(40.0)),
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  color: widget.index % 2 == 0
                      ? Colors.teal.shade50
                      : Colors.red.shade50,
                  child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.start, // Align items at the ends
                      children: [
                        Container(
                            child: PatientAvatar(
                                displayName: patientName, radius: 16.0)),
                        Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              patientName,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '$age years · $sex',
                              style: TextStyle(
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Row(children: [
                          GestureDetector(
                              child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  child: Container(
                                      padding: EdgeInsets.all(8.0),
                                      color: Colors.white,
                                      child: Icon(Icons.edit, size: 16.0))),
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AppointmentCreationForm(
                                        initialAppointment: _appointment);
                                  },
                                );
                              }),
                          SizedBox(width: 8.0),
                          GestureDetector(
                              onTap: (() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PatientScreen(patient: _patient)));
                              }),
                              child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  child: Container(
                                      padding: EdgeInsets.all(8.0),
                                      color: Colors.white,
                                      child: Icon(Icons.arrow_forward_ios,
                                          size: 16.0))))
                        ])
                      ]),
                )),
          ),
        ],
      ),
    );
  }
}
