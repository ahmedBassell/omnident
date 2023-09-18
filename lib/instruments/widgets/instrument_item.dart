import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:omni_dent/core/services/snack_bar_service.dart';
import 'package:omni_dent/core/services/utils_service.dart';
import 'package:omni_dent/database/database.dart';
import 'package:omni_dent/instruments/services/instruments_service.dart';
import 'package:omni_dent/locations/services/locations_service.dart';

class InstrumentItem extends StatefulWidget {
  final Instrument instrument;
  final Function() onInstrumentUpdated;

  InstrumentItem({required this.instrument, required this.onInstrumentUpdated});

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
    final String? _friendName = widget.instrument.lentToFriendName;
    final createdAtFormatted =
        _utilsService.formatTimestamp(widget.instrument.createdAt);

    return Card(
        margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
        elevation: 2, // Add a subtle elevation for a card effect
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: _friendName == null
                    ? Colors.teal.shade200
                    : Colors.red.shade200, // Set the color of the left border
                width: 2.0, // Set the width of the left border
              ),
            ),
          ),
          child: ListTile(
            horizontalTitleGap: 8.0,
            contentPadding: EdgeInsets.all(8.0),
            titleAlignment: ListTileTitleAlignment.top,
            leading:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              CircleAvatar(
                backgroundColor:
                    Colors.teal.shade200, // You can use a different color
                child: Icon(
                  Icons.handyman, // Replace with your instrument-related icon
                  color: Colors.white,
                ),
              )
            ]),
            title: Text(
              _utilsService.capitalize(widget.instrument.name),
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4.0), // Added some spacing
                Row(children: [
                  Icon(Icons.location_pin, size: 14.0),
                  SizedBox(width: 2.0),
                  Text(
                    _location?.name ?? "NA",
                    style:
                        TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
                  )
                ]),
                if (_friendName != null)
                  Row(children: [
                    Icon(Icons.person, size: 14.0),
                    SizedBox(width: 2.0),
                    Text(
                      _friendName,
                      style: TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.w400),
                    ),
                  ]),
                Row(
                  children: [
                    Icon(Icons.timelapse, size: 14.0),
                    SizedBox(width: 2.0),
                    Text(createdAtFormatted,
                        style: TextStyle(
                            fontSize: 12.0, fontWeight: FontWeight.w400))
                  ],
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      await _instrumentsService.update(
                          instrumentId: widget.instrument.id,
                          locationId: widget.instrument.location,
                          name: widget.instrument.name,
                          receivedAt: DateTime.now());
                      _snackBarService.show(
                          context, "Instrument has been marked as received!",
                          actionLabel: "Undo", actionOnPress: undoReceive);
                      widget.onInstrumentUpdated();
                    },
                    style: ElevatedButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      backgroundColor: Colors
                          .teal.shade400, // Change button color based on status
                    ),
                    child: Icon(Icons.check))
              ],
            ),
          ),
        ));
  }

  void undoReceive() async {
    await _instrumentsService.update(
        instrumentId: widget.instrument.id,
        locationId: widget.instrument.location,
        name: widget.instrument.name,
        receivedAt: null);
    widget.onInstrumentUpdated();
  }
}
