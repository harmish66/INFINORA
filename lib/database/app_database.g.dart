// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProjectsTable extends Projects with TableInfo<$ProjectsTable, Project> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _thumbnailPathMeta = const VerificationMeta(
    'thumbnailPath',
  );
  @override
  late final GeneratedColumn<String> thumbnailPath = GeneratedColumn<String>(
    'thumbnail_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _canvasWidthMeta = const VerificationMeta(
    'canvasWidth',
  );
  @override
  late final GeneratedColumn<double> canvasWidth = GeneratedColumn<double>(
    'canvas_width',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _canvasHeightMeta = const VerificationMeta(
    'canvasHeight',
  );
  @override
  late final GeneratedColumn<double> canvasHeight = GeneratedColumn<double>(
    'canvas_height',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _backgroundColorMeta = const VerificationMeta(
    'backgroundColor',
  );
  @override
  late final GeneratedColumn<int> backgroundColor = GeneratedColumn<int>(
    'background_color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0xFFFFFFFF),
  );
  static const VerificationMeta _showGridMeta = const VerificationMeta(
    'showGrid',
  );
  @override
  late final GeneratedColumn<bool> showGrid = GeneratedColumn<bool>(
    'show_grid',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_grid" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _gridStyleMeta = const VerificationMeta(
    'gridStyle',
  );
  @override
  late final GeneratedColumn<String> gridStyle = GeneratedColumn<String>(
    'grid_style',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('dots'),
  );
  static const VerificationMeta _cameraXMeta = const VerificationMeta(
    'cameraX',
  );
  @override
  late final GeneratedColumn<double> cameraX = GeneratedColumn<double>(
    'camera_x',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _cameraYMeta = const VerificationMeta(
    'cameraY',
  );
  @override
  late final GeneratedColumn<double> cameraY = GeneratedColumn<double>(
    'camera_y',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _cameraZoomMeta = const VerificationMeta(
    'cameraZoom',
  );
  @override
  late final GeneratedColumn<double> cameraZoom = GeneratedColumn<double>(
    'camera_zoom',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.0),
  );
  static const VerificationMeta _documentVersionMeta = const VerificationMeta(
    'documentVersion',
  );
  @override
  late final GeneratedColumn<int> documentVersion = GeneratedColumn<int>(
    'document_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    createdAt,
    updatedAt,
    isFavorite,
    isArchived,
    thumbnailPath,
    canvasWidth,
    canvasHeight,
    backgroundColor,
    showGrid,
    gridStyle,
    cameraX,
    cameraY,
    cameraZoom,
    documentVersion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'projects';
  @override
  VerificationContext validateIntegrity(
    Insertable<Project> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('thumbnail_path')) {
      context.handle(
        _thumbnailPathMeta,
        thumbnailPath.isAcceptableOrUnknown(
          data['thumbnail_path']!,
          _thumbnailPathMeta,
        ),
      );
    }
    if (data.containsKey('canvas_width')) {
      context.handle(
        _canvasWidthMeta,
        canvasWidth.isAcceptableOrUnknown(
          data['canvas_width']!,
          _canvasWidthMeta,
        ),
      );
    }
    if (data.containsKey('canvas_height')) {
      context.handle(
        _canvasHeightMeta,
        canvasHeight.isAcceptableOrUnknown(
          data['canvas_height']!,
          _canvasHeightMeta,
        ),
      );
    }
    if (data.containsKey('background_color')) {
      context.handle(
        _backgroundColorMeta,
        backgroundColor.isAcceptableOrUnknown(
          data['background_color']!,
          _backgroundColorMeta,
        ),
      );
    }
    if (data.containsKey('show_grid')) {
      context.handle(
        _showGridMeta,
        showGrid.isAcceptableOrUnknown(data['show_grid']!, _showGridMeta),
      );
    }
    if (data.containsKey('grid_style')) {
      context.handle(
        _gridStyleMeta,
        gridStyle.isAcceptableOrUnknown(data['grid_style']!, _gridStyleMeta),
      );
    }
    if (data.containsKey('camera_x')) {
      context.handle(
        _cameraXMeta,
        cameraX.isAcceptableOrUnknown(data['camera_x']!, _cameraXMeta),
      );
    }
    if (data.containsKey('camera_y')) {
      context.handle(
        _cameraYMeta,
        cameraY.isAcceptableOrUnknown(data['camera_y']!, _cameraYMeta),
      );
    }
    if (data.containsKey('camera_zoom')) {
      context.handle(
        _cameraZoomMeta,
        cameraZoom.isAcceptableOrUnknown(data['camera_zoom']!, _cameraZoomMeta),
      );
    }
    if (data.containsKey('document_version')) {
      context.handle(
        _documentVersionMeta,
        documentVersion.isAcceptableOrUnknown(
          data['document_version']!,
          _documentVersionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Project map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Project(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      thumbnailPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumbnail_path'],
      ),
      canvasWidth: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}canvas_width'],
      ),
      canvasHeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}canvas_height'],
      ),
      backgroundColor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}background_color'],
      )!,
      showGrid: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_grid'],
      )!,
      gridStyle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}grid_style'],
      )!,
      cameraX: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}camera_x'],
      )!,
      cameraY: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}camera_y'],
      )!,
      cameraZoom: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}camera_zoom'],
      )!,
      documentVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}document_version'],
      )!,
    );
  }

  @override
  $ProjectsTable createAlias(String alias) {
    return $ProjectsTable(attachedDatabase, alias);
  }
}

class Project extends DataClass implements Insertable<Project> {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isFavorite;
  final bool isArchived;
  final String? thumbnailPath;
  final double? canvasWidth;
  final double? canvasHeight;
  final int backgroundColor;
  final bool showGrid;
  final String gridStyle;
  final double cameraX;
  final double cameraY;
  final double cameraZoom;
  final int documentVersion;
  const Project({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.isFavorite,
    required this.isArchived,
    this.thumbnailPath,
    this.canvasWidth,
    this.canvasHeight,
    required this.backgroundColor,
    required this.showGrid,
    required this.gridStyle,
    required this.cameraX,
    required this.cameraY,
    required this.cameraZoom,
    required this.documentVersion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['is_archived'] = Variable<bool>(isArchived);
    if (!nullToAbsent || thumbnailPath != null) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath);
    }
    if (!nullToAbsent || canvasWidth != null) {
      map['canvas_width'] = Variable<double>(canvasWidth);
    }
    if (!nullToAbsent || canvasHeight != null) {
      map['canvas_height'] = Variable<double>(canvasHeight);
    }
    map['background_color'] = Variable<int>(backgroundColor);
    map['show_grid'] = Variable<bool>(showGrid);
    map['grid_style'] = Variable<String>(gridStyle);
    map['camera_x'] = Variable<double>(cameraX);
    map['camera_y'] = Variable<double>(cameraY);
    map['camera_zoom'] = Variable<double>(cameraZoom);
    map['document_version'] = Variable<int>(documentVersion);
    return map;
  }

  ProjectsCompanion toCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      isFavorite: Value(isFavorite),
      isArchived: Value(isArchived),
      thumbnailPath: thumbnailPath == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbnailPath),
      canvasWidth: canvasWidth == null && nullToAbsent
          ? const Value.absent()
          : Value(canvasWidth),
      canvasHeight: canvasHeight == null && nullToAbsent
          ? const Value.absent()
          : Value(canvasHeight),
      backgroundColor: Value(backgroundColor),
      showGrid: Value(showGrid),
      gridStyle: Value(gridStyle),
      cameraX: Value(cameraX),
      cameraY: Value(cameraY),
      cameraZoom: Value(cameraZoom),
      documentVersion: Value(documentVersion),
    );
  }

  factory Project.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Project(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      thumbnailPath: serializer.fromJson<String?>(json['thumbnailPath']),
      canvasWidth: serializer.fromJson<double?>(json['canvasWidth']),
      canvasHeight: serializer.fromJson<double?>(json['canvasHeight']),
      backgroundColor: serializer.fromJson<int>(json['backgroundColor']),
      showGrid: serializer.fromJson<bool>(json['showGrid']),
      gridStyle: serializer.fromJson<String>(json['gridStyle']),
      cameraX: serializer.fromJson<double>(json['cameraX']),
      cameraY: serializer.fromJson<double>(json['cameraY']),
      cameraZoom: serializer.fromJson<double>(json['cameraZoom']),
      documentVersion: serializer.fromJson<int>(json['documentVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'isArchived': serializer.toJson<bool>(isArchived),
      'thumbnailPath': serializer.toJson<String?>(thumbnailPath),
      'canvasWidth': serializer.toJson<double?>(canvasWidth),
      'canvasHeight': serializer.toJson<double?>(canvasHeight),
      'backgroundColor': serializer.toJson<int>(backgroundColor),
      'showGrid': serializer.toJson<bool>(showGrid),
      'gridStyle': serializer.toJson<String>(gridStyle),
      'cameraX': serializer.toJson<double>(cameraX),
      'cameraY': serializer.toJson<double>(cameraY),
      'cameraZoom': serializer.toJson<double>(cameraZoom),
      'documentVersion': serializer.toJson<int>(documentVersion),
    };
  }

  Project copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFavorite,
    bool? isArchived,
    Value<String?> thumbnailPath = const Value.absent(),
    Value<double?> canvasWidth = const Value.absent(),
    Value<double?> canvasHeight = const Value.absent(),
    int? backgroundColor,
    bool? showGrid,
    String? gridStyle,
    double? cameraX,
    double? cameraY,
    double? cameraZoom,
    int? documentVersion,
  }) => Project(
    id: id ?? this.id,
    name: name ?? this.name,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    isFavorite: isFavorite ?? this.isFavorite,
    isArchived: isArchived ?? this.isArchived,
    thumbnailPath: thumbnailPath.present
        ? thumbnailPath.value
        : this.thumbnailPath,
    canvasWidth: canvasWidth.present ? canvasWidth.value : this.canvasWidth,
    canvasHeight: canvasHeight.present ? canvasHeight.value : this.canvasHeight,
    backgroundColor: backgroundColor ?? this.backgroundColor,
    showGrid: showGrid ?? this.showGrid,
    gridStyle: gridStyle ?? this.gridStyle,
    cameraX: cameraX ?? this.cameraX,
    cameraY: cameraY ?? this.cameraY,
    cameraZoom: cameraZoom ?? this.cameraZoom,
    documentVersion: documentVersion ?? this.documentVersion,
  );
  Project copyWithCompanion(ProjectsCompanion data) {
    return Project(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      thumbnailPath: data.thumbnailPath.present
          ? data.thumbnailPath.value
          : this.thumbnailPath,
      canvasWidth: data.canvasWidth.present
          ? data.canvasWidth.value
          : this.canvasWidth,
      canvasHeight: data.canvasHeight.present
          ? data.canvasHeight.value
          : this.canvasHeight,
      backgroundColor: data.backgroundColor.present
          ? data.backgroundColor.value
          : this.backgroundColor,
      showGrid: data.showGrid.present ? data.showGrid.value : this.showGrid,
      gridStyle: data.gridStyle.present ? data.gridStyle.value : this.gridStyle,
      cameraX: data.cameraX.present ? data.cameraX.value : this.cameraX,
      cameraY: data.cameraY.present ? data.cameraY.value : this.cameraY,
      cameraZoom: data.cameraZoom.present
          ? data.cameraZoom.value
          : this.cameraZoom,
      documentVersion: data.documentVersion.present
          ? data.documentVersion.value
          : this.documentVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Project(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('isArchived: $isArchived, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('canvasWidth: $canvasWidth, ')
          ..write('canvasHeight: $canvasHeight, ')
          ..write('backgroundColor: $backgroundColor, ')
          ..write('showGrid: $showGrid, ')
          ..write('gridStyle: $gridStyle, ')
          ..write('cameraX: $cameraX, ')
          ..write('cameraY: $cameraY, ')
          ..write('cameraZoom: $cameraZoom, ')
          ..write('documentVersion: $documentVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    createdAt,
    updatedAt,
    isFavorite,
    isArchived,
    thumbnailPath,
    canvasWidth,
    canvasHeight,
    backgroundColor,
    showGrid,
    gridStyle,
    cameraX,
    cameraY,
    cameraZoom,
    documentVersion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Project &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.isFavorite == this.isFavorite &&
          other.isArchived == this.isArchived &&
          other.thumbnailPath == this.thumbnailPath &&
          other.canvasWidth == this.canvasWidth &&
          other.canvasHeight == this.canvasHeight &&
          other.backgroundColor == this.backgroundColor &&
          other.showGrid == this.showGrid &&
          other.gridStyle == this.gridStyle &&
          other.cameraX == this.cameraX &&
          other.cameraY == this.cameraY &&
          other.cameraZoom == this.cameraZoom &&
          other.documentVersion == this.documentVersion);
}

class ProjectsCompanion extends UpdateCompanion<Project> {
  final Value<String> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<bool> isFavorite;
  final Value<bool> isArchived;
  final Value<String?> thumbnailPath;
  final Value<double?> canvasWidth;
  final Value<double?> canvasHeight;
  final Value<int> backgroundColor;
  final Value<bool> showGrid;
  final Value<String> gridStyle;
  final Value<double> cameraX;
  final Value<double> cameraY;
  final Value<double> cameraZoom;
  final Value<int> documentVersion;
  final Value<int> rowid;
  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.thumbnailPath = const Value.absent(),
    this.canvasWidth = const Value.absent(),
    this.canvasHeight = const Value.absent(),
    this.backgroundColor = const Value.absent(),
    this.showGrid = const Value.absent(),
    this.gridStyle = const Value.absent(),
    this.cameraX = const Value.absent(),
    this.cameraY = const Value.absent(),
    this.cameraZoom = const Value.absent(),
    this.documentVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProjectsCompanion.insert({
    required String id,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.isFavorite = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.thumbnailPath = const Value.absent(),
    this.canvasWidth = const Value.absent(),
    this.canvasHeight = const Value.absent(),
    this.backgroundColor = const Value.absent(),
    this.showGrid = const Value.absent(),
    this.gridStyle = const Value.absent(),
    this.cameraX = const Value.absent(),
    this.cameraY = const Value.absent(),
    this.cameraZoom = const Value.absent(),
    this.documentVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Project> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isFavorite,
    Expression<bool>? isArchived,
    Expression<String>? thumbnailPath,
    Expression<double>? canvasWidth,
    Expression<double>? canvasHeight,
    Expression<int>? backgroundColor,
    Expression<bool>? showGrid,
    Expression<String>? gridStyle,
    Expression<double>? cameraX,
    Expression<double>? cameraY,
    Expression<double>? cameraZoom,
    Expression<int>? documentVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (isArchived != null) 'is_archived': isArchived,
      if (thumbnailPath != null) 'thumbnail_path': thumbnailPath,
      if (canvasWidth != null) 'canvas_width': canvasWidth,
      if (canvasHeight != null) 'canvas_height': canvasHeight,
      if (backgroundColor != null) 'background_color': backgroundColor,
      if (showGrid != null) 'show_grid': showGrid,
      if (gridStyle != null) 'grid_style': gridStyle,
      if (cameraX != null) 'camera_x': cameraX,
      if (cameraY != null) 'camera_y': cameraY,
      if (cameraZoom != null) 'camera_zoom': cameraZoom,
      if (documentVersion != null) 'document_version': documentVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProjectsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<bool>? isFavorite,
    Value<bool>? isArchived,
    Value<String?>? thumbnailPath,
    Value<double?>? canvasWidth,
    Value<double?>? canvasHeight,
    Value<int>? backgroundColor,
    Value<bool>? showGrid,
    Value<String>? gridStyle,
    Value<double>? cameraX,
    Value<double>? cameraY,
    Value<double>? cameraZoom,
    Value<int>? documentVersion,
    Value<int>? rowid,
  }) {
    return ProjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFavorite: isFavorite ?? this.isFavorite,
      isArchived: isArchived ?? this.isArchived,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      canvasWidth: canvasWidth ?? this.canvasWidth,
      canvasHeight: canvasHeight ?? this.canvasHeight,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      showGrid: showGrid ?? this.showGrid,
      gridStyle: gridStyle ?? this.gridStyle,
      cameraX: cameraX ?? this.cameraX,
      cameraY: cameraY ?? this.cameraY,
      cameraZoom: cameraZoom ?? this.cameraZoom,
      documentVersion: documentVersion ?? this.documentVersion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (thumbnailPath.present) {
      map['thumbnail_path'] = Variable<String>(thumbnailPath.value);
    }
    if (canvasWidth.present) {
      map['canvas_width'] = Variable<double>(canvasWidth.value);
    }
    if (canvasHeight.present) {
      map['canvas_height'] = Variable<double>(canvasHeight.value);
    }
    if (backgroundColor.present) {
      map['background_color'] = Variable<int>(backgroundColor.value);
    }
    if (showGrid.present) {
      map['show_grid'] = Variable<bool>(showGrid.value);
    }
    if (gridStyle.present) {
      map['grid_style'] = Variable<String>(gridStyle.value);
    }
    if (cameraX.present) {
      map['camera_x'] = Variable<double>(cameraX.value);
    }
    if (cameraY.present) {
      map['camera_y'] = Variable<double>(cameraY.value);
    }
    if (cameraZoom.present) {
      map['camera_zoom'] = Variable<double>(cameraZoom.value);
    }
    if (documentVersion.present) {
      map['document_version'] = Variable<int>(documentVersion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('isArchived: $isArchived, ')
          ..write('thumbnailPath: $thumbnailPath, ')
          ..write('canvasWidth: $canvasWidth, ')
          ..write('canvasHeight: $canvasHeight, ')
          ..write('backgroundColor: $backgroundColor, ')
          ..write('showGrid: $showGrid, ')
          ..write('gridStyle: $gridStyle, ')
          ..write('cameraX: $cameraX, ')
          ..write('cameraY: $cameraY, ')
          ..write('cameraZoom: $cameraZoom, ')
          ..write('documentVersion: $documentVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LayersTable extends Layers with TableInfo<$LayersTable, Layer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LayersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isVisibleMeta = const VerificationMeta(
    'isVisible',
  );
  @override
  late final GeneratedColumn<bool> isVisible = GeneratedColumn<bool>(
    'is_visible',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_visible" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isLockedMeta = const VerificationMeta(
    'isLocked',
  );
  @override
  late final GeneratedColumn<bool> isLocked = GeneratedColumn<bool>(
    'is_locked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_locked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _opacityMeta = const VerificationMeta(
    'opacity',
  );
  @override
  late final GeneratedColumn<double> opacity = GeneratedColumn<double>(
    'opacity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    name,
    orderIndex,
    isVisible,
    isLocked,
    opacity,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'layers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Layer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('is_visible')) {
      context.handle(
        _isVisibleMeta,
        isVisible.isAcceptableOrUnknown(data['is_visible']!, _isVisibleMeta),
      );
    }
    if (data.containsKey('is_locked')) {
      context.handle(
        _isLockedMeta,
        isLocked.isAcceptableOrUnknown(data['is_locked']!, _isLockedMeta),
      );
    }
    if (data.containsKey('opacity')) {
      context.handle(
        _opacityMeta,
        opacity.isAcceptableOrUnknown(data['opacity']!, _opacityMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Layer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Layer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      isVisible: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_visible'],
      )!,
      isLocked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_locked'],
      )!,
      opacity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}opacity'],
      )!,
    );
  }

  @override
  $LayersTable createAlias(String alias) {
    return $LayersTable(attachedDatabase, alias);
  }
}

class Layer extends DataClass implements Insertable<Layer> {
  final String id;
  final String projectId;
  final String name;
  final int orderIndex;
  final bool isVisible;
  final bool isLocked;
  final double opacity;
  const Layer({
    required this.id,
    required this.projectId,
    required this.name,
    required this.orderIndex,
    required this.isVisible,
    required this.isLocked,
    required this.opacity,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['project_id'] = Variable<String>(projectId);
    map['name'] = Variable<String>(name);
    map['order_index'] = Variable<int>(orderIndex);
    map['is_visible'] = Variable<bool>(isVisible);
    map['is_locked'] = Variable<bool>(isLocked);
    map['opacity'] = Variable<double>(opacity);
    return map;
  }

  LayersCompanion toCompanion(bool nullToAbsent) {
    return LayersCompanion(
      id: Value(id),
      projectId: Value(projectId),
      name: Value(name),
      orderIndex: Value(orderIndex),
      isVisible: Value(isVisible),
      isLocked: Value(isLocked),
      opacity: Value(opacity),
    );
  }

  factory Layer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Layer(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      name: serializer.fromJson<String>(json['name']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      isVisible: serializer.fromJson<bool>(json['isVisible']),
      isLocked: serializer.fromJson<bool>(json['isLocked']),
      opacity: serializer.fromJson<double>(json['opacity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String>(projectId),
      'name': serializer.toJson<String>(name),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'isVisible': serializer.toJson<bool>(isVisible),
      'isLocked': serializer.toJson<bool>(isLocked),
      'opacity': serializer.toJson<double>(opacity),
    };
  }

  Layer copyWith({
    String? id,
    String? projectId,
    String? name,
    int? orderIndex,
    bool? isVisible,
    bool? isLocked,
    double? opacity,
  }) => Layer(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    name: name ?? this.name,
    orderIndex: orderIndex ?? this.orderIndex,
    isVisible: isVisible ?? this.isVisible,
    isLocked: isLocked ?? this.isLocked,
    opacity: opacity ?? this.opacity,
  );
  Layer copyWithCompanion(LayersCompanion data) {
    return Layer(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      name: data.name.present ? data.name.value : this.name,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      isVisible: data.isVisible.present ? data.isVisible.value : this.isVisible,
      isLocked: data.isLocked.present ? data.isLocked.value : this.isLocked,
      opacity: data.opacity.present ? data.opacity.value : this.opacity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Layer(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('name: $name, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('isVisible: $isVisible, ')
          ..write('isLocked: $isLocked, ')
          ..write('opacity: $opacity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    projectId,
    name,
    orderIndex,
    isVisible,
    isLocked,
    opacity,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Layer &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.name == this.name &&
          other.orderIndex == this.orderIndex &&
          other.isVisible == this.isVisible &&
          other.isLocked == this.isLocked &&
          other.opacity == this.opacity);
}

class LayersCompanion extends UpdateCompanion<Layer> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<String> name;
  final Value<int> orderIndex;
  final Value<bool> isVisible;
  final Value<bool> isLocked;
  final Value<double> opacity;
  final Value<int> rowid;
  const LayersCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.name = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.isVisible = const Value.absent(),
    this.isLocked = const Value.absent(),
    this.opacity = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LayersCompanion.insert({
    required String id,
    required String projectId,
    required String name,
    required int orderIndex,
    this.isVisible = const Value.absent(),
    this.isLocked = const Value.absent(),
    this.opacity = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       projectId = Value(projectId),
       name = Value(name),
       orderIndex = Value(orderIndex);
  static Insertable<Layer> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? name,
    Expression<int>? orderIndex,
    Expression<bool>? isVisible,
    Expression<bool>? isLocked,
    Expression<double>? opacity,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (name != null) 'name': name,
      if (orderIndex != null) 'order_index': orderIndex,
      if (isVisible != null) 'is_visible': isVisible,
      if (isLocked != null) 'is_locked': isLocked,
      if (opacity != null) 'opacity': opacity,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LayersCompanion copyWith({
    Value<String>? id,
    Value<String>? projectId,
    Value<String>? name,
    Value<int>? orderIndex,
    Value<bool>? isVisible,
    Value<bool>? isLocked,
    Value<double>? opacity,
    Value<int>? rowid,
  }) {
    return LayersCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      orderIndex: orderIndex ?? this.orderIndex,
      isVisible: isVisible ?? this.isVisible,
      isLocked: isLocked ?? this.isLocked,
      opacity: opacity ?? this.opacity,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (isVisible.present) {
      map['is_visible'] = Variable<bool>(isVisible.value);
    }
    if (isLocked.present) {
      map['is_locked'] = Variable<bool>(isLocked.value);
    }
    if (opacity.present) {
      map['opacity'] = Variable<double>(opacity.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LayersCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('name: $name, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('isVisible: $isVisible, ')
          ..write('isLocked: $isLocked, ')
          ..write('opacity: $opacity, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CanvasObjectsTable extends CanvasObjects
    with TableInfo<$CanvasObjectsTable, CanvasObject> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CanvasObjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _layerIdMeta = const VerificationMeta(
    'layerId',
  );
  @override
  late final GeneratedColumn<String> layerId = GeneratedColumn<String>(
    'layer_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<String> data = GeneratedColumn<String>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    layerId,
    type,
    orderIndex,
    data,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'canvas_objects';
  @override
  VerificationContext validateIntegrity(
    Insertable<CanvasObject> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('layer_id')) {
      context.handle(
        _layerIdMeta,
        layerId.isAcceptableOrUnknown(data['layer_id']!, _layerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_layerIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    if (data.containsKey('data')) {
      context.handle(
        _dataMeta,
        this.data.isAcceptableOrUnknown(data['data']!, _dataMeta),
      );
    } else if (isInserting) {
      context.missing(_dataMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CanvasObject map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CanvasObject(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      )!,
      layerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}layer_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      data: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CanvasObjectsTable createAlias(String alias) {
    return $CanvasObjectsTable(attachedDatabase, alias);
  }
}

class CanvasObject extends DataClass implements Insertable<CanvasObject> {
  final String id;
  final String projectId;
  final String layerId;
  final String type;
  final int orderIndex;
  final String data;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CanvasObject({
    required this.id,
    required this.projectId,
    required this.layerId,
    required this.type,
    required this.orderIndex,
    required this.data,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['project_id'] = Variable<String>(projectId);
    map['layer_id'] = Variable<String>(layerId);
    map['type'] = Variable<String>(type);
    map['order_index'] = Variable<int>(orderIndex);
    map['data'] = Variable<String>(data);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CanvasObjectsCompanion toCompanion(bool nullToAbsent) {
    return CanvasObjectsCompanion(
      id: Value(id),
      projectId: Value(projectId),
      layerId: Value(layerId),
      type: Value(type),
      orderIndex: Value(orderIndex),
      data: Value(data),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CanvasObject.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CanvasObject(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      layerId: serializer.fromJson<String>(json['layerId']),
      type: serializer.fromJson<String>(json['type']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      data: serializer.fromJson<String>(json['data']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String>(projectId),
      'layerId': serializer.toJson<String>(layerId),
      'type': serializer.toJson<String>(type),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'data': serializer.toJson<String>(data),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CanvasObject copyWith({
    String? id,
    String? projectId,
    String? layerId,
    String? type,
    int? orderIndex,
    String? data,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => CanvasObject(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    layerId: layerId ?? this.layerId,
    type: type ?? this.type,
    orderIndex: orderIndex ?? this.orderIndex,
    data: data ?? this.data,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CanvasObject copyWithCompanion(CanvasObjectsCompanion data) {
    return CanvasObject(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      layerId: data.layerId.present ? data.layerId.value : this.layerId,
      type: data.type.present ? data.type.value : this.type,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      data: data.data.present ? data.data.value : this.data,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CanvasObject(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('layerId: $layerId, ')
          ..write('type: $type, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('data: $data, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    projectId,
    layerId,
    type,
    orderIndex,
    data,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CanvasObject &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.layerId == this.layerId &&
          other.type == this.type &&
          other.orderIndex == this.orderIndex &&
          other.data == this.data &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CanvasObjectsCompanion extends UpdateCompanion<CanvasObject> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<String> layerId;
  final Value<String> type;
  final Value<int> orderIndex;
  final Value<String> data;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CanvasObjectsCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.layerId = const Value.absent(),
    this.type = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.data = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CanvasObjectsCompanion.insert({
    required String id,
    required String projectId,
    required String layerId,
    required String type,
    required int orderIndex,
    required String data,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       projectId = Value(projectId),
       layerId = Value(layerId),
       type = Value(type),
       orderIndex = Value(orderIndex),
       data = Value(data),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CanvasObject> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? layerId,
    Expression<String>? type,
    Expression<int>? orderIndex,
    Expression<String>? data,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (layerId != null) 'layer_id': layerId,
      if (type != null) 'type': type,
      if (orderIndex != null) 'order_index': orderIndex,
      if (data != null) 'data': data,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CanvasObjectsCompanion copyWith({
    Value<String>? id,
    Value<String>? projectId,
    Value<String>? layerId,
    Value<String>? type,
    Value<int>? orderIndex,
    Value<String>? data,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CanvasObjectsCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      layerId: layerId ?? this.layerId,
      type: type ?? this.type,
      orderIndex: orderIndex ?? this.orderIndex,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (layerId.present) {
      map['layer_id'] = Variable<String>(layerId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (data.present) {
      map['data'] = Variable<String>(data.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CanvasObjectsCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('layerId: $layerId, ')
          ..write('type: $type, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('data: $data, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProjectsTable projects = $ProjectsTable(this);
  late final $LayersTable layers = $LayersTable(this);
  late final $CanvasObjectsTable canvasObjects = $CanvasObjectsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    projects,
    layers,
    canvasObjects,
  ];
}

typedef $$ProjectsTableCreateCompanionBuilder =
    ProjectsCompanion Function({
      required String id,
      required String name,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<bool> isFavorite,
      Value<bool> isArchived,
      Value<String?> thumbnailPath,
      Value<double?> canvasWidth,
      Value<double?> canvasHeight,
      Value<int> backgroundColor,
      Value<bool> showGrid,
      Value<String> gridStyle,
      Value<double> cameraX,
      Value<double> cameraY,
      Value<double> cameraZoom,
      Value<int> documentVersion,
      Value<int> rowid,
    });
typedef $$ProjectsTableUpdateCompanionBuilder =
    ProjectsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<bool> isFavorite,
      Value<bool> isArchived,
      Value<String?> thumbnailPath,
      Value<double?> canvasWidth,
      Value<double?> canvasHeight,
      Value<int> backgroundColor,
      Value<bool> showGrid,
      Value<String> gridStyle,
      Value<double> cameraX,
      Value<double> cameraY,
      Value<double> cameraZoom,
      Value<int> documentVersion,
      Value<int> rowid,
    });

class $$ProjectsTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get canvasWidth => $composableBuilder(
    column: $table.canvasWidth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get canvasHeight => $composableBuilder(
    column: $table.canvasHeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get backgroundColor => $composableBuilder(
    column: $table.backgroundColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get showGrid => $composableBuilder(
    column: $table.showGrid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gridStyle => $composableBuilder(
    column: $table.gridStyle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cameraX => $composableBuilder(
    column: $table.cameraX,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cameraY => $composableBuilder(
    column: $table.cameraY,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cameraZoom => $composableBuilder(
    column: $table.cameraZoom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get documentVersion => $composableBuilder(
    column: $table.documentVersion,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get canvasWidth => $composableBuilder(
    column: $table.canvasWidth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get canvasHeight => $composableBuilder(
    column: $table.canvasHeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get backgroundColor => $composableBuilder(
    column: $table.backgroundColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showGrid => $composableBuilder(
    column: $table.showGrid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gridStyle => $composableBuilder(
    column: $table.gridStyle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cameraX => $composableBuilder(
    column: $table.cameraX,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cameraY => $composableBuilder(
    column: $table.cameraY,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cameraZoom => $composableBuilder(
    column: $table.cameraZoom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get documentVersion => $composableBuilder(
    column: $table.documentVersion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<String> get thumbnailPath => $composableBuilder(
    column: $table.thumbnailPath,
    builder: (column) => column,
  );

  GeneratedColumn<double> get canvasWidth => $composableBuilder(
    column: $table.canvasWidth,
    builder: (column) => column,
  );

  GeneratedColumn<double> get canvasHeight => $composableBuilder(
    column: $table.canvasHeight,
    builder: (column) => column,
  );

  GeneratedColumn<int> get backgroundColor => $composableBuilder(
    column: $table.backgroundColor,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get showGrid =>
      $composableBuilder(column: $table.showGrid, builder: (column) => column);

  GeneratedColumn<String> get gridStyle =>
      $composableBuilder(column: $table.gridStyle, builder: (column) => column);

  GeneratedColumn<double> get cameraX =>
      $composableBuilder(column: $table.cameraX, builder: (column) => column);

  GeneratedColumn<double> get cameraY =>
      $composableBuilder(column: $table.cameraY, builder: (column) => column);

  GeneratedColumn<double> get cameraZoom => $composableBuilder(
    column: $table.cameraZoom,
    builder: (column) => column,
  );

  GeneratedColumn<int> get documentVersion => $composableBuilder(
    column: $table.documentVersion,
    builder: (column) => column,
  );
}

class $$ProjectsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProjectsTable,
          Project,
          $$ProjectsTableFilterComposer,
          $$ProjectsTableOrderingComposer,
          $$ProjectsTableAnnotationComposer,
          $$ProjectsTableCreateCompanionBuilder,
          $$ProjectsTableUpdateCompanionBuilder,
          (Project, BaseReferences<_$AppDatabase, $ProjectsTable, Project>),
          Project,
          PrefetchHooks Function()
        > {
  $$ProjectsTableTableManager(_$AppDatabase db, $ProjectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<String?> thumbnailPath = const Value.absent(),
                Value<double?> canvasWidth = const Value.absent(),
                Value<double?> canvasHeight = const Value.absent(),
                Value<int> backgroundColor = const Value.absent(),
                Value<bool> showGrid = const Value.absent(),
                Value<String> gridStyle = const Value.absent(),
                Value<double> cameraX = const Value.absent(),
                Value<double> cameraY = const Value.absent(),
                Value<double> cameraZoom = const Value.absent(),
                Value<int> documentVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectsCompanion(
                id: id,
                name: name,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isFavorite: isFavorite,
                isArchived: isArchived,
                thumbnailPath: thumbnailPath,
                canvasWidth: canvasWidth,
                canvasHeight: canvasHeight,
                backgroundColor: backgroundColor,
                showGrid: showGrid,
                gridStyle: gridStyle,
                cameraX: cameraX,
                cameraY: cameraY,
                cameraZoom: cameraZoom,
                documentVersion: documentVersion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<bool> isFavorite = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<String?> thumbnailPath = const Value.absent(),
                Value<double?> canvasWidth = const Value.absent(),
                Value<double?> canvasHeight = const Value.absent(),
                Value<int> backgroundColor = const Value.absent(),
                Value<bool> showGrid = const Value.absent(),
                Value<String> gridStyle = const Value.absent(),
                Value<double> cameraX = const Value.absent(),
                Value<double> cameraY = const Value.absent(),
                Value<double> cameraZoom = const Value.absent(),
                Value<int> documentVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectsCompanion.insert(
                id: id,
                name: name,
                createdAt: createdAt,
                updatedAt: updatedAt,
                isFavorite: isFavorite,
                isArchived: isArchived,
                thumbnailPath: thumbnailPath,
                canvasWidth: canvasWidth,
                canvasHeight: canvasHeight,
                backgroundColor: backgroundColor,
                showGrid: showGrid,
                gridStyle: gridStyle,
                cameraX: cameraX,
                cameraY: cameraY,
                cameraZoom: cameraZoom,
                documentVersion: documentVersion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProjectsTable,
      Project,
      $$ProjectsTableFilterComposer,
      $$ProjectsTableOrderingComposer,
      $$ProjectsTableAnnotationComposer,
      $$ProjectsTableCreateCompanionBuilder,
      $$ProjectsTableUpdateCompanionBuilder,
      (Project, BaseReferences<_$AppDatabase, $ProjectsTable, Project>),
      Project,
      PrefetchHooks Function()
    >;
typedef $$LayersTableCreateCompanionBuilder =
    LayersCompanion Function({
      required String id,
      required String projectId,
      required String name,
      required int orderIndex,
      Value<bool> isVisible,
      Value<bool> isLocked,
      Value<double> opacity,
      Value<int> rowid,
    });
typedef $$LayersTableUpdateCompanionBuilder =
    LayersCompanion Function({
      Value<String> id,
      Value<String> projectId,
      Value<String> name,
      Value<int> orderIndex,
      Value<bool> isVisible,
      Value<bool> isLocked,
      Value<double> opacity,
      Value<int> rowid,
    });

class $$LayersTableFilterComposer
    extends Composer<_$AppDatabase, $LayersTable> {
  $$LayersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isVisible => $composableBuilder(
    column: $table.isVisible,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isLocked => $composableBuilder(
    column: $table.isLocked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get opacity => $composableBuilder(
    column: $table.opacity,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LayersTableOrderingComposer
    extends Composer<_$AppDatabase, $LayersTable> {
  $$LayersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isVisible => $composableBuilder(
    column: $table.isVisible,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isLocked => $composableBuilder(
    column: $table.isLocked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get opacity => $composableBuilder(
    column: $table.opacity,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LayersTableAnnotationComposer
    extends Composer<_$AppDatabase, $LayersTable> {
  $$LayersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get projectId =>
      $composableBuilder(column: $table.projectId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isVisible =>
      $composableBuilder(column: $table.isVisible, builder: (column) => column);

  GeneratedColumn<bool> get isLocked =>
      $composableBuilder(column: $table.isLocked, builder: (column) => column);

  GeneratedColumn<double> get opacity =>
      $composableBuilder(column: $table.opacity, builder: (column) => column);
}

class $$LayersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LayersTable,
          Layer,
          $$LayersTableFilterComposer,
          $$LayersTableOrderingComposer,
          $$LayersTableAnnotationComposer,
          $$LayersTableCreateCompanionBuilder,
          $$LayersTableUpdateCompanionBuilder,
          (Layer, BaseReferences<_$AppDatabase, $LayersTable, Layer>),
          Layer,
          PrefetchHooks Function()
        > {
  $$LayersTableTableManager(_$AppDatabase db, $LayersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LayersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LayersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LayersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<bool> isVisible = const Value.absent(),
                Value<bool> isLocked = const Value.absent(),
                Value<double> opacity = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LayersCompanion(
                id: id,
                projectId: projectId,
                name: name,
                orderIndex: orderIndex,
                isVisible: isVisible,
                isLocked: isLocked,
                opacity: opacity,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String projectId,
                required String name,
                required int orderIndex,
                Value<bool> isVisible = const Value.absent(),
                Value<bool> isLocked = const Value.absent(),
                Value<double> opacity = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LayersCompanion.insert(
                id: id,
                projectId: projectId,
                name: name,
                orderIndex: orderIndex,
                isVisible: isVisible,
                isLocked: isLocked,
                opacity: opacity,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LayersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LayersTable,
      Layer,
      $$LayersTableFilterComposer,
      $$LayersTableOrderingComposer,
      $$LayersTableAnnotationComposer,
      $$LayersTableCreateCompanionBuilder,
      $$LayersTableUpdateCompanionBuilder,
      (Layer, BaseReferences<_$AppDatabase, $LayersTable, Layer>),
      Layer,
      PrefetchHooks Function()
    >;
typedef $$CanvasObjectsTableCreateCompanionBuilder =
    CanvasObjectsCompanion Function({
      required String id,
      required String projectId,
      required String layerId,
      required String type,
      required int orderIndex,
      required String data,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$CanvasObjectsTableUpdateCompanionBuilder =
    CanvasObjectsCompanion Function({
      Value<String> id,
      Value<String> projectId,
      Value<String> layerId,
      Value<String> type,
      Value<int> orderIndex,
      Value<String> data,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$CanvasObjectsTableFilterComposer
    extends Composer<_$AppDatabase, $CanvasObjectsTable> {
  $$CanvasObjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get layerId => $composableBuilder(
    column: $table.layerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CanvasObjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $CanvasObjectsTable> {
  $$CanvasObjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get projectId => $composableBuilder(
    column: $table.projectId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get layerId => $composableBuilder(
    column: $table.layerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get data => $composableBuilder(
    column: $table.data,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CanvasObjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CanvasObjectsTable> {
  $$CanvasObjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get projectId =>
      $composableBuilder(column: $table.projectId, builder: (column) => column);

  GeneratedColumn<String> get layerId =>
      $composableBuilder(column: $table.layerId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get data =>
      $composableBuilder(column: $table.data, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CanvasObjectsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CanvasObjectsTable,
          CanvasObject,
          $$CanvasObjectsTableFilterComposer,
          $$CanvasObjectsTableOrderingComposer,
          $$CanvasObjectsTableAnnotationComposer,
          $$CanvasObjectsTableCreateCompanionBuilder,
          $$CanvasObjectsTableUpdateCompanionBuilder,
          (
            CanvasObject,
            BaseReferences<_$AppDatabase, $CanvasObjectsTable, CanvasObject>,
          ),
          CanvasObject,
          PrefetchHooks Function()
        > {
  $$CanvasObjectsTableTableManager(_$AppDatabase db, $CanvasObjectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CanvasObjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CanvasObjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CanvasObjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<String> layerId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<String> data = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CanvasObjectsCompanion(
                id: id,
                projectId: projectId,
                layerId: layerId,
                type: type,
                orderIndex: orderIndex,
                data: data,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String projectId,
                required String layerId,
                required String type,
                required int orderIndex,
                required String data,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CanvasObjectsCompanion.insert(
                id: id,
                projectId: projectId,
                layerId: layerId,
                type: type,
                orderIndex: orderIndex,
                data: data,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CanvasObjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CanvasObjectsTable,
      CanvasObject,
      $$CanvasObjectsTableFilterComposer,
      $$CanvasObjectsTableOrderingComposer,
      $$CanvasObjectsTableAnnotationComposer,
      $$CanvasObjectsTableCreateCompanionBuilder,
      $$CanvasObjectsTableUpdateCompanionBuilder,
      (
        CanvasObject,
        BaseReferences<_$AppDatabase, $CanvasObjectsTable, CanvasObject>,
      ),
      CanvasObject,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db, _db.projects);
  $$LayersTableTableManager get layers =>
      $$LayersTableTableManager(_db, _db.layers);
  $$CanvasObjectsTableTableManager get canvasObjects =>
      $$CanvasObjectsTableTableManager(_db, _db.canvasObjects);
}
