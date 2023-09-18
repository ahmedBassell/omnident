import 'package:drift/drift.dart';
import 'package:get_it/get_it.dart';
import 'package:omni_dent/database/database.dart';

class LocationsService {
  OmniDatabase get _db => GetIt.I<OmniDatabase>();

  // Create
  Future<Location> create({
    required String name,
  }) async {
    int locationId = await _db.locations.insertOne(LocationsCompanion.insert(
      name: name,
    ));
    return findById(locationId);
  }

  // Read
  Future<Location> findById(int locationId) async {
    return await (_db.locations.select()
          ..where((tbl) => tbl.id.equals(locationId)))
        .getSingle();
  }

  Future<List<Location>> getAll({int limit = 50, int offset = 0}) async {
    List<Location> locations =
        await (_db.select(_db.locations)..limit(limit, offset: offset)).get();
    return locations;
  }

  // Update
  Future<Location> update({
    required int locationId,
    required String name,
  }) async {
    await (_db.locations.update()..where((tbl) => tbl.id.equals(locationId)))
        .write(LocationsCompanion(
      name: Value(name),
    ));

    return findById(locationId);
  }

  // Delete
  Future<void> delete({
    required int locationId,
  }) async {
    await (_db.locations.delete()..where((tbl) => tbl.id.equals(locationId)))
        .go();
  }

  Future<int> totalCount() async {
    var countExp = _db.locations.id.count();
    final query = _db.selectOnly(_db.locations)..addColumns([countExp]);
    var result = await query.map((row) => row.read(countExp)).getSingle();
    return result!;
  }
}
