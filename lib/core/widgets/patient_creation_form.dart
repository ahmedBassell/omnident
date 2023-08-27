import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:omni_dent/core/services/patients_service.dart';

class PatientCreationForm extends StatefulWidget {
  @override
  _PatientCreationFormState createState() => _PatientCreationFormState();
}

class _PatientCreationFormState extends State<PatientCreationForm> {
  final _formKey = GlobalKey<FormState>();
  PatientsService get _patientsService => GetIt.I<PatientsService>();

  String? _name;
  String? _email;
  String? _phone;
  String? _gender;
  String? _jobTitle;
  String? _company;
  String? _notes;

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
              'Create New Patient',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(labelText: 'Patient Name'),
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
              onSaved: (value) => _email = value,
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(labelText: 'Patient Phone'),
              onSaved: (value) => _phone = value,
            ),
            SizedBox(height: 16),
            Text('Gender'),
            Row(
              children: [
                Radio<String>(
                  value: 'Male',
                  groupValue: _gender,
                  onChanged: (value) {
                    setState(() {
                      _gender = value;
                    });
                  },
                ),
                Text('Male'),
                Radio<String>(
                  value: 'Female',
                  groupValue: _gender,
                  onChanged: (value) {
                    setState(() {
                      _gender = value;
                    });
                  },
                ),
                Text('Female'),
              ],
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(labelText: 'Job Title'),
              onSaved: (value) => _jobTitle = value,
            ),
            SizedBox(height: 16),
            TextFormField(
              decoration: InputDecoration(labelText: 'Company'),
              onSaved: (value) => _company = value,
            ),
            SizedBox(height: 16),
            Text('Notes'),
            TextFormField(
              maxLines: 4, // Set the number of lines for the larger text box
              decoration: InputDecoration(
                hintText: 'Enter patient notes',
                border: OutlineInputBorder(),
              ),
              onSaved: (value) => _notes = value,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // Perform submission logic here
                  _patientsService.createPatient(
                      name: _name!,
                      email: _email,
                      phone: _phone,
                      notes: _notes);
                  try {
                    Navigator.pop(context);
                    // snackBarService.show(
                    //     context, "Event Created Successfully!");
                  } catch (e) {
                    print(e);
                    // snackBarService.show(context, "Event Creation Failed!");
                  }
                }
              },
              child: Text('Create'),
            ),
          ],
        ),
      ),
    ));
  }
}
