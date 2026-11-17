import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

class Projects extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  TextColumn get thumbnailPath => text().nullable()();
  RealColumn get canvasWidth => real().nullable()();
  RealColumn get canvasHeight => real().nullable()();
  IntColumn get backgroundColor => integer().withDefault(const Constant(0xFFFFFFFF))();
  BoolColumn get showGrid => boolean().withDefault(const Constant(true))();
  TextColumn get gridStyle => text().withDefault(const Constant('dots'))();
  RealColumn get cameraX => real().withDefault(const Constant(0.0))();
  RealColumn get cameraY => real().withDefault(const Constant(0.0))();
  RealColumn get cameraZoom => real().withDefault(const Constant(1.0))();
  IntColumn get documentVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

class Layers extends Table {
  TextColumn get id => text()();
  TextColumn get projectId => text()();
  TextColumn get name => text()();
  IntColumn get orderIndex => integer()();
  BoolColumn get isVisible => boolean().withDefault(const Constant(true))();
  BoolColumn get isLocked => boolean().withDefault(const Constant(false))();
  RealColumn get opacity => real().withDefault(const Constant(1.0))();

  @override
  Set<Column> get primaryKey => {id};
}

class CanvasObjects extends Table {
  TextColumn get id => text()();
  TextColumn get projectId => text()();
  TextColumn get layerId => text()();
  TextColumn get type => text()();
  IntColumn get orderIndex => integer()();
  TextColumn get data => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Projects, Layers, CanvasObjects])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'infinora.sqlite'));
      return NativeDatabase.createInBackground(file);
    });
  }
}
