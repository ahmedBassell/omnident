import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:omni_dent/database/database.dart';
import 'package:omni_dent/instruments/services/instruments_service.dart';
import 'package:omni_dent/locations/services/locations_service.dart';

class InstrumentCreationForm extends StatefulWidget {
  final Function(Instrument) onInstrumentCreated;

  InstrumentCreationForm({required this.onInstrumentCreated});

  @override
  _InstrumentCreationFormState createState() => _InstrumentCreationFormState();
}

class _InstrumentCreationFormState extends State<InstrumentCreationForm> {
  InstrumentsService get _instrumentsService => GetIt.I<InstrumentsService>();
  LocationsService get _locationsService => GetIt.I<LocationsService>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _name = '';
  Location? _location = null;
  bool _isLentToFriend = false;
  String? _friendName = null;
  List<Location> _locations = [];

  @override
  void initState() {
    super.initState();
    _locationsService.getAll().then((existingLocations) {
      setState(() {
        _locations = existingLocations;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
              onSaved: (value) {
                _name = value!;
              },
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<Location>(
              value: _location,
              onChanged: (newValue) {
                setState(() {
                  _location = newValue;
                });
              },
              items: _locations.map<DropdownMenuItem<Location>>(
                (value) {
                  return DropdownMenuItem<Location>(
                    value: value,
                    child: Text(value.name),
                  );
                },
              ).toList(),
              decoration: InputDecoration(labelText: 'Location'),
              validator: (value) {
                if (value == null) {
                  return 'Please select a location';
                }
                return null;
              },
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Text('Take a Photo:'),
                SizedBox(width: 8.0),
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () {
                    // Implement photo capture logic
                  },
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Text('Lent to a Friend:'),
                SizedBox(width: 8.0),
                Switch(
                  value: _isLentToFriend,
                  onChanged: (value) {
                    setState(() {
                      _isLentToFriend = value;
                    });
                  },
                ),
              ],
            ),
            if (_isLentToFriend)
              TextFormField(
                decoration: InputDecoration(labelText: 'Friend Name'),
                validator: (value) {
                  if (_isLentToFriend && (value == null || value.isEmpty)) {
                    return 'Please enter friend\'s name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _friendName = value!;
                },
              ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _createInstrument,
              child: Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  void _createInstrument() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Create an Instrument object with the entered data
      Instrument newInstrument = await _instrumentsService.create(
        name: _name,
        // location: _location,
        locationId: 1,
        imagePath: null, // You can set this to the photo URL when implemented
        lentToFriendName: _friendName,
      );
      widget
          .onInstrumentCreated(newInstrument); // Callback to add the instrument
    }
  }
}
