import 'package:flutter/material.dart';
import 'package:omni_dent/core/widgets/patient_avatar.dart';

class AppointmentsScreen extends StatefulWidget {
  final String doctorName = "Tala";
  final int numberOfAppointments = 8;

  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
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
              'You have ${widget.numberOfAppointments} appointments today.',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey,
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: widget.numberOfAppointments,
              itemBuilder: (context, index) {
                // Replace with your appointment data
                String time = '9:00 AM';
                String patientName = 'John Doe';
                int age = 35;
                String sex = 'Male';

                return Container(
                  margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
                  padding: EdgeInsets.all(8.0),
                  // decoration: BoxDecoration(
                  //   border: Border.all(color: Colors.grey),
                  //   borderRadius: BorderRadius.circular(8.0),
                  // ),
                  child: Row(
                    children: [
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        // Wrap the Row with Expanded
                        child: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(40.0)),
                            child: Container(
                              padding: EdgeInsets.all(16.0),
                              color: index % 2 == 0
                                  ? Colors.teal.shade50
                                  : Colors.red.shade50,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .start, // Align items at the ends
                                  children: [
                                    Container(
                                        child: PatientAvatar(
                                            displayName: patientName,
                                            radius: 16.0)),
                                    Spacer(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                    ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                        child: Container(
                                            padding: EdgeInsets.all(8.0),
                                            color: Colors.white,
                                            child: Icon(Icons.arrow_forward_ios,
                                                size: 20.0)))
                                  ]),
                            )),
                      ),
                    ],
                  ),
                );
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
