import 'package:drift/drift.dart';
import 'package:get_it/get_it.dart';
import 'package:omni_dent/database/database.dart';

class InstrumentsService {
  OmniDatabase get _db => GetIt.I<OmniDatabase>();

  // Create
  Future<Instrument> create(
      {required int locationId,
      required String name,
      String? lentToFriendName,
      String? imagePath}) async {
    int instrumentId = await _db.instruments.insertOne(
        InstrumentsCompanion.insert(
            name: name,
            location: locationId,
            lentToFriendName: Value(lentToFriendName),
            imagePath: Value(imagePath)));
    return findById(instrumentId);
  }

  // Read
  Future<Instrument> findById(int instrumentId) async {
    return await (_db.instruments.select()
          ..where((tbl) => tbl.id.equals(instrumentId)))
        .getSingle();
  }

  Future<List<Instrument>> getAll({int limit = 50, int offset = 0}) async {
    List<Instrument> instruments = await (_db.select(_db.instruments)
          ..where((tbl) => tbl.receivedAt.isNull())
          ..limit(limit, offset: offset))
        .get();
    return instruments;
  }

  // Update
  Future<Instrument> update(
      {required int instrumentId,
      required int locationId,
      required String name,
      String? lentToFriendName,
      String? imagePath,
      DateTime? receivedAt}) async {
    await (_db.instruments.update()
          ..where((tbl) => tbl.id.equals(instrumentId)))
        .write(InstrumentsCompanion(
            name: Value(name),
            location: Value(locationId),
            lentToFriendName: Value(lentToFriendName),
            imagePath: Value(imagePath),
            receivedAt: Value(receivedAt)));

    return findById(instrumentId);
  }

  Future<int> totalCount() async {
    var countExp = _db.instruments.id.count();
    final query = _db.selectOnly(_db.instruments)..addColumns([countExp]);
    query.where(_db.instruments.receivedAt.isNull());
    var result = await query.map((row) => row.read(countExp)).getSingle();
    return result!;
  }
}
