import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:omni_dent/locations/services/locations_service.dart';

class LocationCreationForm extends StatefulWidget {
  @override
  _LocationCreationFormState createState() => _LocationCreationFormState();
}

class _LocationCreationFormState extends State<LocationCreationForm> {
  LocationsService get _locationsService => GetIt.I<LocationsService>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _locationName = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Location Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a location name';
              }
              return null;
            },
            onSaved: (value) {
              setState(() {
                _locationName = value!;
              });
            },
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _createLocation,
            child: Text('Create Location'),
          ),
        ],
      ),
    );
  }

  void _createLocation() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await _locationsService.create(name: _locationName);
      Navigator.pop(context);
    }
  }
}
