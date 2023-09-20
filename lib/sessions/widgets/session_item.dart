import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:omni_dent/core/models/tooth_state.dart';
import 'package:omni_dent/database/database.dart';
import 'package:omni_dent/sessions/services/sessions_service.dart';
import 'package:omni_dent/sessions/widgets/session_creation_form.dart';

class ToothRecord {
  final String toothNumber;
  final ToothState state;

  ToothRecord({
    required this.toothNumber,
    required this.state,
  });
}

class SessionRecord {
  final DateTime dateTime;
  final String symptoms;
  final String treatment;
  final List<ToothRecord> affectedTeeth;

  SessionRecord({
    required this.dateTime,
    required this.symptoms,
    required this.treatment,
    required this.affectedTeeth,
  });
}

class SessionItem extends StatelessWidget {
  SessionsService get _sessionsService => GetIt.I<SessionsService>();
  final SessionWithTeeth sessionWithTeeth;
  final Patient patient;
  final Function onSessionDelete;
  Function showUpdateSessionSheet;

  SessionItem(
      {required this.sessionWithTeeth,
      required this.patient,
      required this.onSessionDelete,
      required this.showUpdateSessionSheet});

  @override
  Widget build(BuildContext context) {
    final session = sessionWithTeeth.session;
    final teeth = sessionWithTeeth.teeth;
    final formattedDateTime =
        DateFormat('E, MMM d y').format(session.dateTimeFrom);

    return Card(
      elevation: 2,
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$formattedDateTime',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit,
                          color: Colors.grey.shade600,
                          size: 20), // Icon for update
                      onPressed: () {
                        // Handle update button press here
                        showUpdateSessionSheet(patient, sessionWithTeeth);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete,
                          color: Colors.red.shade200,
                          size: 20), // Icon for delete
                      onPressed: () {
                        _showDeleteConfirmationDialog(context, session);
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 10),
            Text('Symptoms: ${session.symptoms}'),
            Text('Treatment: ${session.treatment}'),
            SizedBox(height: 10),
            _buildToothList(teeth),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Session session) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Session?'),
          content: Text('Are you sure you want to delete the session?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () async {
                await onSessionDelete(sessionId: session.id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildToothList(List<SessionTooth> toothRecords) {
    return Container(
      height: 40, // Adjust the height as needed
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tooth = toothRecords[index];
          final bgColor =
              index % 2 == 0 ? Colors.teal.shade50 : Colors.red.shade50;

          return _buildToothItem(tooth, bgColor);
        },
        separatorBuilder: (context, index) {
          return SizedBox(width: 4.0); // Add some spacing between teeth
        },
        itemCount: toothRecords.length,
      ),
    );
  }

  Widget _buildToothItem(SessionTooth tooth, Color bgColor) {
    return Container(
      width: 100, // Adjust the width as needed
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              tooth.toothName.name,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(width: 8.0),
            Text(
              _formatToothState(tooth.state),
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatToothState(ToothState state) {
    switch (state) {
      case ToothState.extracted:
        return 'Extracted';
      case ToothState.decayed:
        return 'Decayed';
      case ToothState.cavity:
        return 'Cavity';
      case ToothState.none:
        return 'Healthy';
      // Add more cases for other states as needed
    }
  }
}
