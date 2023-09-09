import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:omni_dent/core/models/tooth_entry.dart';
import 'package:omni_dent/core/models/tooth_name.dart';
import 'package:omni_dent/core/models/tooth_state.dart';
import 'package:omni_dent/database/database.dart';
import 'package:omni_dent/sessions/services/sessions_service.dart';

class SessionCreationForm extends StatefulWidget {
  final Patient patient;
  final SessionWithTeeth? existingSession;

  const SessionCreationForm({
    super.key,
    required this.patient,
    this.existingSession,
  });

  @override
  _SessionCreationFormState createState() => _SessionCreationFormState();
}

class _SessionCreationFormState extends State<SessionCreationForm> {
  SessionsService get _sessionsService => GetIt.I<SessionsService>();
  DateTime _sessionDate = DateTime.now();
  String _symptoms = '';
  String _treatment = '';
  List<ToothEntry> _affectedTeeth = [
    ToothEntry()
  ]; // Start with one tooth entry

  @override
  void initState() {
    super.initState();
    // If it's an update operation, initialize the form with existing session data
    if (widget.existingSession != null) {
      final session = widget.existingSession!.session;
      final existingTeeth = widget.existingSession!.teeth;

      _sessionDate = session.dateTimeFrom;
      _symptoms = session.symptoms ?? "";
      _treatment = session.treatment;
      _affectedTeeth = existingTeeth.map((tooth) {
        return ToothEntry(
          toothName: tooth.toothName,
          toothState: tooth.state,
        );
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.existingSession == null
                    ? 'New Session'
                    : 'Update Session',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              DateTimePicker(
                type: DateTimePickerType.dateTime,
                dateMask: 'd MMM, yyyy - hh:mm a',
                initialValue: _sessionDate?.toString(),
                firstDate: DateTime.now(),
                lastDate: DateTime(2101),
                icon: Icon(Icons.event),
                dateLabelText: 'Session Date',
                timeLabelText: "Time",
                onChanged: (dateTime) {
                  setState(() {
                    _sessionDate = DateTime.parse(dateTime);
                  });
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Symptoms'),
                maxLines: 3,
                initialValue: _symptoms, // Initialize with existing data
                onChanged: (value) {
                  setState(() {
                    _symptoms = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Symptoms are required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(labelText: 'Treatment'),
                maxLines: 3,
                initialValue: _treatment, // Initialize with existing data
                onChanged: (value) {
                  setState(() {
                    _treatment = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Treatment is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Text(
                'Affected Teeth',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Column(
                children: _affectedTeeth.map((toothEntry) {
                  return ToothEntryWidget(
                    toothEntry: toothEntry,
                    onDelete: () {
                      setState(() {
                        _affectedTeeth.remove(toothEntry);
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  if (_affectedTeeth.length < 3) {
                    setState(() {
                      _affectedTeeth.add(ToothEntry());
                    });
                  }
                },
                child: Text('Add Tooth'),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  // Submit session data
                  if (_formKey.currentState!.validate()) {
                    if (widget.existingSession == null) {
                      // Create a new session
                      _sessionsService.create(
                        patient: widget.patient,
                        dateTimeFrom: _sessionDate,
                        title: "title",
                        treatment: _treatment,
                        symptoms: _symptoms,
                        sessionTeeth: _affectedTeeth,
                      );
                    } else {
                      // Update an existing session
                      _sessionsService.update(
                        sessionId: widget.existingSession!.session.id,
                        patient: widget.patient,
                        dateTimeFrom: _sessionDate,
                        title: "title",
                        treatment: _treatment,
                        symptoms: _symptoms,
                        sessionTeeth: _affectedTeeth,
                      );
                    }

                    Navigator.pop(context);
                  }
                },
                child: Text(widget.existingSession == null
                    ? 'Add Session'
                    : 'Update Session'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ToothEntryWidget extends StatelessWidget {
  final ToothEntry toothEntry;
  final VoidCallback onDelete;

  ToothEntryWidget({required this.toothEntry, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<ToothName>(
            value: toothEntry.toothName,
            onChanged: (value) {
              toothEntry.toothName = value;
            },
            items: ToothName.values
                .map((tn) => DropdownMenuItem(child: Text(tn.name), value: tn))
                .toList(),
            decoration: InputDecoration(labelText: 'Tooth'),
            validator: (value) {
              if (value == null) {
                return 'Tooth name is required';
              }
              return null;
            },
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: DropdownButtonFormField<ToothState>(
            value: toothEntry.toothState,
            onChanged: (value) {
              toothEntry.toothState = value;
            },
            items: ToothState.values
                .map((ts) => DropdownMenuItem(child: Text(ts.name), value: ts))
                .toList(),
            decoration: InputDecoration(labelText: 'Tooth State'),
            validator: (value) {
              if (value == null) {
                return 'Tooth state is required';
              }
              return null;
            },
          ),
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: onDelete,
        ),
      ],
    );
  }
}
