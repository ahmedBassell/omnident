import 'package:flutter/material.dart';

class InstrumentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instruments'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showAddInstrumentSheet(context);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: instruments.length,
        itemBuilder: (context, index) {
          return InstrumentItem(instrument: instruments[index]);
        },
      ),
    );
  }

  void _showAddInstrumentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return InstrumentCreationForm();
      },
    );
  }
}

class Instrument {
  final String name;
  final String lastSeenIn;
  final String lastSeenAt;
  final String expectedReceiveDateTime;
  final bool isLent;
  final String imageUrl;

  Instrument({
    required this.name,
    required this.lastSeenIn,
    required this.lastSeenAt,
    required this.expectedReceiveDateTime,
    required this.isLent,
    required this.imageUrl,
  });
}

final List<Instrument> instruments = [
  // Define your instrument items here
];

class InstrumentItem extends StatelessWidget {
  final Instrument instrument;

  InstrumentItem({required this.instrument});

  @override
  Widget build(BuildContext context) {
    // Build the instrument item widget here
    // Include the name, lastSeenIn, lastSeenAt, expectedReceiveDateTime,
    // isLent, and imageUrl in the layout
    // You can also include a "Mark as Received" action
    return Container();
  }
}

class InstrumentCreationForm extends StatelessWidget {
  // Build the instrument creation form with input fields
  // for name, lastSeenIn, lastSeenAt, expectedReceiveDateTime,
  // isLent, and imageUrl
  // Include a "Create" button to add the new instrument item
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
