import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:omni_dent/core/models/appointment.dart';
import 'package:omni_dent/core/models/patient.dart';
import 'package:omni_dent/core/services/appointments_service.dart';
import 'package:omni_dent/core/services/patients_service.dart';
import 'package:omni_dent/core/widgets/appointment_creation_form.dart';
import 'package:omni_dent/core/widgets/patient_card.dart';
import 'package:omni_dent/core/widgets/patient_creation_form.dart';
import 'package:omni_dent/database/database.dart';
import 'package:omni_dent/locations/widgets/location_creation_form.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  PatientsService get _patientsService => GetIt.I<PatientsService>();
  AppointmentsService get _appointmentsService =>
      GetIt.I<AppointmentsService>();
  List<AppointmentWithPatient> upcomingAppointments = [];
  List<Patient> recentPatients = [];

  @override
  void initState() {
    super.initState();
    List<Patient> patients = [];
    _patientsService.getPatients().then((patients) {
      setState(() {
        recentPatients = patients;
      });
    });
    _appointmentsService.getAppointments().then((data) {
      setState(() {
        upcomingAppointments = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              'Upcoming Appointments',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            // Display a list of upcoming appointments with details
            if (upcomingAppointments.isEmpty)
              Text(
                'No recent patients.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              )
            else
              for (var appointmentWithPatient in upcomingAppointments)
                _buildAppointmentCard(appointmentWithPatient),
            SizedBox(height: 32),
            Text(
              'Most Recent Patients',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            if (recentPatients.isEmpty)
              Text(
                'No recent patients.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              )
            else
              _buildRecentPatientsSection(),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     _showAddOptions(context);
      //   },
      //   child: Icon(Icons.add),
      // )
    );
  }

  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return PatientCreationForm();
                    },
                  ).whenComplete(() {
                    Navigator.pop(context);
                  });
                },
                title: Text('Add a patient'),
                leading: Icon(Icons.person_add),
              ),
              SizedBox(height: 16),
              ListTile(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return AppointmentCreationForm();
                    },
                  ).whenComplete(() {
                    Navigator.pop(context);
                  });
                },
                title: Text('Create New Appointment'),
                leading: Icon(Icons.calendar_today),
              ),
              // SizedBox(height: 16),
              // ListTile(
              //   onTap: () {
              //     showModalBottomSheet(
              //       context: context,
              //       builder: (BuildContext context) {
              //         return LocationCreationForm();
              //       },
              //     ).whenComplete(() {
              //       Navigator.pop(context);
              //     });
              //   },
              //   title: Text('Create New Location'),
              //   leading: Icon(Icons.pin_drop),
              // ),
            ],
          ),
        );
      },
    ).whenComplete(() => {
          // Navigator.pop(context);
          setState(() async {
            recentPatients = await _patientsService.getPatients();
            upcomingAppointments = await _appointmentsService.getAppointments();
            print(upcomingAppointments);
          })
        });
  }

  Widget _buildRecentPatientsSection() {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recentPatients.length,
        itemBuilder: (context, index) {
          var patient = recentPatients[index];
          return PatientCard(patient);
        },
      ),
    );
  }

  Widget _buildAppointmentCard(AppointmentWithPatient appointmentWithPatient) {
    final appointment = appointmentWithPatient.appointment;
    final patient = appointmentWithPatient.patient;
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 16),
      child: ListTile(
        title: Text(patient.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(appointment.title),
            Text(
              'Date: ${appointment.dateTimeFrom.day}/${appointment.dateTimeFrom.month}/${appointment.dateTimeFrom.year}',
            ),
            Text(
              'Time: ${appointment.dateTimeFrom.hour}:${appointment.dateTimeFrom.minute}',
            ),
            Text(
              'Gender: ${patient.gender.name}',
            ),
          ],
        ),
      ),
    );
  }
}
