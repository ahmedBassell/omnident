import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:omni_dent/core/services/snack_bar_service.dart';
import 'package:omni_dent/core/services/utils_service.dart';
import 'package:omni_dent/database/database.dart';
import 'package:omni_dent/instruments/services/instruments_service.dart';
import 'package:omni_dent/locations/services/locations_service.dart';

class InstrumentItem extends StatefulWidget {
  final Instrument instrument;
  final Function() onInstrumentReceived;

  InstrumentItem(
      {required this.instrument, required this.onInstrumentReceived});

  @override
  _InstrumentItemState createState() => _InstrumentItemState();
}

class _InstrumentItemState extends State<InstrumentItem> {
  UtilsService get _utilsService => GetIt.I<UtilsService>();
  LocationsService get _locationsService => GetIt.I<LocationsService>();
  InstrumentsService get _instrumentsService => GetIt.I<InstrumentsService>();
  SnackBarService get _snackBarService => GetIt.I<SnackBarService>();
  late bool isReceived;
  Location? _location;

  @override
  void initState() {
    super.initState();
    isReceived =
        widget.instrument.receivedAt != null; // Initialize the received status
    _locationsService.findById(widget.instrument.location).then((value) => {
          setState(() {
            _location = value;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    final createdAtFormatted =
        _utilsService.formatTimestamp(widget.instrument.createdAt);

    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 2, // Add a subtle elevation for a card effect
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              Colors.teal.shade200, // You can use a different color
          child: Icon(
            Icons.handyman, // Replace with your instrument-related icon
            color: Colors.white,
          ),
        ),
        title: Text(
          widget.instrument.name,
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8), // Added some spacing
            Text(
              _location?.name ?? "NA",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8), // Added some spacing
            Text(
              createdAtFormatted,
              style: TextStyle(fontSize: 12.0, color: Colors.grey),
            ), // Moved Created At here
          ],
        ),
        trailing: ElevatedButton(
            onPressed: () async {
              await _instrumentsService.update(
                  instrumentId: widget.instrument.id,
                  locationId: widget.instrument.location,
                  name: widget.instrument.name,
                  receivedAt: DateTime.now());
              _snackBarService.show(
                  context, "Instrument has been marked as received!");
              widget.onInstrumentReceived();
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0)),
              backgroundColor:
                  Colors.red.shade200, // Change button color based on status
            ),
            child: Icon(Icons.check)),
      ),
    );
  }
}
