import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:omni_dent/core/models/gender.dart';
import 'package:omni_dent/core/services/patients_service.dart';
import 'package:omni_dent/database/database.dart';

class PatientCreationForm extends StatefulWidget {
  final Patient? existingPatient;

  PatientCreationForm({this.existingPatient});

  @override
  _PatientCreationFormState createState() => _PatientCreationFormState();
}

class _PatientCreationFormState extends State<PatientCreationForm> {
  final _formKey = GlobalKey<FormState>();
  PatientsService get _patientsService => GetIt.I<PatientsService>();

  String? _name;
  String? _email;
  String? _phone;
  Gender _gender = Gender.none;
  // String? _jobTitle;
  // String? _company;
  DateTime? _dateTime;

  @override
  void initState() {
    super.initState();
    if (widget.existingPatient != null) {
      // If in update mode, set the fields to the existing patient's data
      _name = widget.existingPatient!.name;
      _email = widget.existingPatient!.email;
      _phone = widget.existingPatient!.phone;
      _gender = widget.existingPatient!.gender;
      // _jobTitle = widget.existingPatient!.jobTitle;
      // _company = widget.existingPatient!.company;
      _dateTime = widget.existingPatient!.birthDate;
    }
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
                widget.existingPatient != null
                    ? 'Update Patient'
                    : 'Create New Patient',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Patient Name'),
                initialValue: _name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onSaved: (value) => _name = value,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Patient Email'),
                initialValue: _email,
                onSaved: (value) => _email = value,
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Patient Phone'),
                initialValue: _phone,
                onSaved: (value) => _phone = value,
              ),
              SizedBox(height: 16),
              Text('Gender'),
              Row(
                children: [
                  Radio<Gender>(
                    value: Gender.male,
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value == null ? _gender : value;
                      });
                    },
                  ),
                  Text('Male'),
                  Radio<Gender>(
                    value: Gender.female,
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value == null ? _gender : value;
                      });
                    },
                  ),
                  Text('Female'),
                ],
              ),
              SizedBox(height: 16),
              // TextFormField(
              //   decoration: InputDecoration(labelText: 'Job Title'),
              //   initialValue: _jobTitle,
              //   onSaved: (value) => _jobTitle = value,
              // ),
              // SizedBox(height: 16),
              // TextFormField(
              //   decoration: InputDecoration(labelText: 'Company'),
              //   initialValue: _company,
              //   onSaved: (value) => _company = value,
              // ),
              // SizedBox(height: 16),
              DateTimePicker(
                type: DateTimePickerType.date,
                dateMask: 'd MMM, yyyy',
                initialValue: _dateTime?.toString(),
                firstDate: DateTime(1930),
                lastDate: DateTime(2101),
                icon: Icon(Icons.event),
                dateLabelText: 'Birth Date',
                onChanged: (dateTime) {
                  setState(() {
                    _dateTime = DateTime.parse(dateTime);
                  });
                },
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Check if it's in create or update mode
                    if (widget.existingPatient == null) {
                      // Create a new patient
                      _patientsService.createPatient(
                        name: _name!,
                        email: _email,
                        phone: _phone,
                        gender: _gender,
                        birthDate: _dateTime,
                      );
                    } else {
                      // Update the existing patient
                      print(_email);
                      _patientsService.update(
                        patientId: widget.existingPatient!.id,
                        name: _name!,
                        email: _email,
                        phone: _phone,
                        gender: _gender,
                        birthDate: _dateTime,
                      );
                    }
                    try {
                      Navigator.pop(context);
                    } catch (e) {
                      print(e);
                    }
                  }
                },
                child: Text(widget.existingPatient != null
                    ? 'Update'
                    : 'Create'), // Change button text based on mode
              ),
            ],
          ),
        ),
      ),
    );
  }
}
