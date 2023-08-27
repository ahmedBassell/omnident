import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:omni_dent/core/models/patient.dart';
import 'package:omni_dent/core/services/appointments_service.dart';
import 'package:omni_dent/core/services/patients_service.dart';

class AppointmentCreationForm extends StatefulWidget {
  @override
  _AppointmentCreationFormState createState() =>
      _AppointmentCreationFormState();
}

class _AppointmentCreationFormState extends State<AppointmentCreationForm> {
  PatientsService get _patientsService => GetIt.I<PatientsService>();
  AppointmentsService get _appointmentsService =>
      GetIt.I<AppointmentsService>();

  late final List<Patient> patients;
  final _formKey = GlobalKey<FormState>();

  String? _appointmentName;
  DateTime _dateTime = DateTime.now();
  Patient? _selectedPatient;
  String? _notes;

  @override
  void initState() {
    super.initState();
    patients = _patientsService.getPatients();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Create New Appointment',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter appointment name';
                  }
                  return null;
                },
                onSaved: (value) => _appointmentName = value,
                decoration: InputDecoration(labelText: 'Appointment Name'),
              ),
              SizedBox(height: 16),
              DateTimePicker(
                type: DateTimePickerType.dateTime,
                dateMask: 'd MMM, yyyy - hh:mm a',
                initialValue: _dateTime?.toString(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2101),
                icon: Icon(Icons.event),
                dateLabelText: 'Date',
                timeLabelText: "Hour",
                onChanged: (dateTime) {
                  setState(() {
                    _dateTime = DateTime.parse(dateTime);
                  });
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<Patient>(
                value: _selectedPatient,
                onChanged: (value) {
                  setState(() {
                    _selectedPatient = value;
                  });
                },
                items: patients.map((patient) {
                  return DropdownMenuItem<Patient>(
                    value: patient,
                    child: Text(patient.name),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Select Patient'),
              ),
              SizedBox(height: 16),
              TextFormField(
                onSaved: (value) => _notes = value,
                decoration: InputDecoration(labelText: 'Notes'),
                maxLines: 4,
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Create appointment logic here
                    _appointmentsService.createAppointment(
                        name: _appointmentName,
                        dateTime: _dateTime,
                        patient: _selectedPatient!);
                    Navigator.pop(
                        context); // Close the bottom sheet after submission
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text('Create Appointment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
