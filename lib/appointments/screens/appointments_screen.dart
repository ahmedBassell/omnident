import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
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
  late List<AppointmentWithPatient> _appointmentsWithPatient = [];
  @override
  void initState() {
    super.initState();
    _appointmentsService.getAppointments().then((data) {
      setState(() {
        _appointmentsWithPatient = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
      ),
      body: Column(
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
              'You have ${_appointmentsWithPatient.length} appointments today.',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey,
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: _appointmentsWithPatient.length,
              itemBuilder: (context, index) {
                return AppointmentListItem(
                    item: _appointmentsWithPatient[index], index: index);
              },
            ),
          ),
          // SizedBox(height: 16.0),
          // Container(
          //   child: Center(
          //     child: ElevatedButton(
          //       onPressed: () {
          //         // Navigate to create a new appointment screen
          //         // You can use Navigator.push here
          //       },
          //       child: Text('Create New Appointment'),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
