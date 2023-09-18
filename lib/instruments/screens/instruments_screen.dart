import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:omni_dent/database/database.dart';
import 'package:omni_dent/instruments/services/instruments_service.dart';
import 'package:omni_dent/instruments/widgets/instrument_creation_form.dart';
import 'package:omni_dent/instruments/widgets/instrument_item.dart';

class InstrumentsScreen extends StatefulWidget {
  @override
  _InstrumentsScreenState createState() => _InstrumentsScreenState();
}

class _InstrumentsScreenState extends State<InstrumentsScreen> {
  InstrumentsService get _instrumentsService => GetIt.I<InstrumentsService>();
  List<Instrument> instruments = [];
  String _emptyStateCopy = "";
  List<String> emptyStateSentences = [
    "High-five! All instruments are settled up! 🙌",
    "No lent or misplaced instruments in sight! 🥳",
    "Your instrument inventory is shining bright ✨",
    "Nice work! Your instrument inventory is on point 🪥",
    "All tools are in place ... for now 😉"
  ];

  @override
  void initState() {
    super.initState();
    emptyStateSentences.shuffle();
    _instrumentsService.getAll().then((value) => {
          setState(() {
            instruments = value;
            _emptyStateCopy = emptyStateSentences.first;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Instruments')),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            _showAddInstrumentSheet(context);
          }),
      body: instruments.length == 0
          ? Center(child: Text(_emptyStateCopy))
          : ListView.builder(
              itemCount: instruments.length,
              itemBuilder: (context, index) {
                return InstrumentItem(
                    instrument: instruments[index],
                    onInstrumentUpdated: onInstrumentUpdated);
              },
            ),
    );
  }

  void _showAddInstrumentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
              InstrumentCreationForm(
                onInstrumentCreated: (newInstrument) {
                  setState(() {
                    instruments.add(newInstrument);
                  });
                  Navigator.pop(context); // Close the bottom sheet
                },
              )
            ]));
      },
    );
  }

  void onInstrumentUpdated() async {
    _instrumentsService.getAll().then((value) => {
          setState(() {
            instruments = value;
          })
        });
  }
}
