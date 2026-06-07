// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $AppBindingsTable extends AppBindings
    with TableInfo<$AppBindingsTable, AppBinding> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppBindingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _packageNameMeta = const VerificationMeta(
    'packageName',
  );
  @override
  late final GeneratedColumn<String> packageName = GeneratedColumn<String>(
    'package_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _appLabelMeta = const VerificationMeta(
    'appLabel',
  );
  @override
  late final GeneratedColumn<String> appLabel = GeneratedColumn<String>(
    'app_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _radiusMetersMeta = const VerificationMeta(
    'radiusMeters',
  );
  @override
  late final GeneratedColumn<int> radiusMeters = GeneratedColumn<int>(
    'radius_meters',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(100),
  );
  static const VerificationMeta _locationLabelMeta = const VerificationMeta(
    'locationLabel',
  );
  @override
  late final GeneratedColumn<String> locationLabel = GeneratedColumn<String>(
    'location_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconDataMeta = const VerificationMeta(
    'iconData',
  );
  @override
  late final GeneratedColumn<Uint8List> iconData = GeneratedColumn<Uint8List>(
    'icon_data',
    aliasedName,
    true,
    type: DriftSqlType.blob,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _usageCountMeta = const VerificationMeta(
    'usageCount',
  );
  @override
  late final GeneratedColumn<int> usageCount = GeneratedColumn<int>(
    'usage_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastUsedAtMeta = const VerificationMeta(
    'lastUsedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastUsedAt = GeneratedColumn<DateTime>(
    'last_used_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    packageName,
    appLabel,
    latitude,
    longitude,
    radiusMeters,
    locationLabel,
    url,
    iconData,
    usageCount,
    lastUsedAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_bindings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppBinding> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('package_name')) {
      context.handle(
        _packageNameMeta,
        packageName.isAcceptableOrUnknown(
          data['package_name']!,
          _packageNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_packageNameMeta);
    }
    if (data.containsKey('app_label')) {
      context.handle(
        _appLabelMeta,
        appLabel.isAcceptableOrUnknown(data['app_label']!, _appLabelMeta),
      );
    } else if (isInserting) {
      context.missing(_appLabelMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('radius_meters')) {
      context.handle(
        _radiusMetersMeta,
        radiusMeters.isAcceptableOrUnknown(
          data['radius_meters']!,
          _radiusMetersMeta,
        ),
      );
    }
    if (data.containsKey('location_label')) {
      context.handle(
        _locationLabelMeta,
        locationLabel.isAcceptableOrUnknown(
          data['location_label']!,
          _locationLabelMeta,
        ),
      );
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    }
    if (data.containsKey('icon_data')) {
      context.handle(
        _iconDataMeta,
        iconData.isAcceptableOrUnknown(data['icon_data']!, _iconDataMeta),
      );
    }
    if (data.containsKey('usage_count')) {
      context.handle(
        _usageCountMeta,
        usageCount.isAcceptableOrUnknown(data['usage_count']!, _usageCountMeta),
      );
    }
    if (data.containsKey('last_used_at')) {
      context.handle(
        _lastUsedAtMeta,
        lastUsedAt.isAcceptableOrUnknown(
          data['last_used_at']!,
          _lastUsedAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppBinding map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppBinding(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      packageName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}package_name'],
      )!,
      appLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}app_label'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      radiusMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}radius_meters'],
      )!,
      locationLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location_label'],
      ),
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      ),
      iconData: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}icon_data'],
      ),
      usageCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}usage_count'],
      )!,
      lastUsedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_used_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AppBindingsTable createAlias(String alias) {
    return $AppBindingsTable(attachedDatabase, alias);
  }
}

class AppBinding extends DataClass implements Insertable<AppBinding> {
  final int id;
  final String packageName;
  final String appLabel;
  final double latitude;
  final double longitude;
  final int radiusMeters;
  final String? locationLabel;
  final String? url;
  final Uint8List? iconData;
  final int usageCount;
  final DateTime? lastUsedAt;
  final DateTime createdAt;
  const AppBinding({
    required this.id,
    required this.packageName,
    required this.appLabel,
    required this.latitude,
    required this.longitude,
    required this.radiusMeters,
    this.locationLabel,
    this.url,
    this.iconData,
    required this.usageCount,
    this.lastUsedAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['package_name'] = Variable<String>(packageName);
    map['app_label'] = Variable<String>(appLabel);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['radius_meters'] = Variable<int>(radiusMeters);
    if (!nullToAbsent || locationLabel != null) {
      map['location_label'] = Variable<String>(locationLabel);
    }
    if (!nullToAbsent || url != null) {
      map['url'] = Variable<String>(url);
    }
    if (!nullToAbsent || iconData != null) {
      map['icon_data'] = Variable<Uint8List>(iconData);
    }
    map['usage_count'] = Variable<int>(usageCount);
    if (!nullToAbsent || lastUsedAt != null) {
      map['last_used_at'] = Variable<DateTime>(lastUsedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AppBindingsCompanion toCompanion(bool nullToAbsent) {
    return AppBindingsCompanion(
      id: Value(id),
      packageName: Value(packageName),
      appLabel: Value(appLabel),
      latitude: Value(latitude),
      longitude: Value(longitude),
      radiusMeters: Value(radiusMeters),
      locationLabel: locationLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(locationLabel),
      url: url == null && nullToAbsent ? const Value.absent() : Value(url),
      iconData: iconData == null && nullToAbsent
          ? const Value.absent()
          : Value(iconData),
      usageCount: Value(usageCount),
      lastUsedAt: lastUsedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUsedAt),
      createdAt: Value(createdAt),
    );
  }

  factory AppBinding.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppBinding(
      id: serializer.fromJson<int>(json['id']),
      packageName: serializer.fromJson<String>(json['packageName']),
      appLabel: serializer.fromJson<String>(json['appLabel']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      radiusMeters: serializer.fromJson<int>(json['radiusMeters']),
      locationLabel: serializer.fromJson<String?>(json['locationLabel']),
      url: serializer.fromJson<String?>(json['url']),
      iconData: serializer.fromJson<Uint8List?>(json['iconData']),
      usageCount: serializer.fromJson<int>(json['usageCount']),
      lastUsedAt: serializer.fromJson<DateTime?>(json['lastUsedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'packageName': serializer.toJson<String>(packageName),
      'appLabel': serializer.toJson<String>(appLabel),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'radiusMeters': serializer.toJson<int>(radiusMeters),
      'locationLabel': serializer.toJson<String?>(locationLabel),
      'url': serializer.toJson<String?>(url),
      'iconData': serializer.toJson<Uint8List?>(iconData),
      'usageCount': serializer.toJson<int>(usageCount),
      'lastUsedAt': serializer.toJson<DateTime?>(lastUsedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AppBinding copyWith({
    int? id,
    String? packageName,
    String? appLabel,
    double? latitude,
    double? longitude,
    int? radiusMeters,
    Value<String?> locationLabel = const Value.absent(),
    Value<String?> url = const Value.absent(),
    Value<Uint8List?> iconData = const Value.absent(),
    int? usageCount,
    Value<DateTime?> lastUsedAt = const Value.absent(),
    DateTime? createdAt,
  }) => AppBinding(
    id: id ?? this.id,
    packageName: packageName ?? this.packageName,
    appLabel: appLabel ?? this.appLabel,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    radiusMeters: radiusMeters ?? this.radiusMeters,
    locationLabel: locationLabel.present
        ? locationLabel.value
        : this.locationLabel,
    url: url.present ? url.value : this.url,
    iconData: iconData.present ? iconData.value : this.iconData,
    usageCount: usageCount ?? this.usageCount,
    lastUsedAt: lastUsedAt.present ? lastUsedAt.value : this.lastUsedAt,
    createdAt: createdAt ?? this.createdAt,
  );
  AppBinding copyWithCompanion(AppBindingsCompanion data) {
    return AppBinding(
      id: data.id.present ? data.id.value : this.id,
      packageName: data.packageName.present
          ? data.packageName.value
          : this.packageName,
      appLabel: data.appLabel.present ? data.appLabel.value : this.appLabel,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      radiusMeters: data.radiusMeters.present
          ? data.radiusMeters.value
          : this.radiusMeters,
      locationLabel: data.locationLabel.present
          ? data.locationLabel.value
          : this.locationLabel,
      url: data.url.present ? data.url.value : this.url,
      iconData: data.iconData.present ? data.iconData.value : this.iconData,
      usageCount: data.usageCount.present
          ? data.usageCount.value
          : this.usageCount,
      lastUsedAt: data.lastUsedAt.present
          ? data.lastUsedAt.value
          : this.lastUsedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppBinding(')
          ..write('id: $id, ')
          ..write('packageName: $packageName, ')
          ..write('appLabel: $appLabel, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('radiusMeters: $radiusMeters, ')
          ..write('locationLabel: $locationLabel, ')
          ..write('url: $url, ')
          ..write('iconData: $iconData, ')
          ..write('usageCount: $usageCount, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    packageName,
    appLabel,
    latitude,
    longitude,
    radiusMeters,
    locationLabel,
    url,
    $driftBlobEquality.hash(iconData),
    usageCount,
    lastUsedAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppBinding &&
          other.id == this.id &&
          other.packageName == this.packageName &&
          other.appLabel == this.appLabel &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.radiusMeters == this.radiusMeters &&
          other.locationLabel == this.locationLabel &&
          other.url == this.url &&
          $driftBlobEquality.equals(other.iconData, this.iconData) &&
          other.usageCount == this.usageCount &&
          other.lastUsedAt == this.lastUsedAt &&
          other.createdAt == this.createdAt);
}

class AppBindingsCompanion extends UpdateCompanion<AppBinding> {
  final Value<int> id;
  final Value<String> packageName;
  final Value<String> appLabel;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<int> radiusMeters;
  final Value<String?> locationLabel;
  final Value<String?> url;
  final Value<Uint8List?> iconData;
  final Value<int> usageCount;
  final Value<DateTime?> lastUsedAt;
  final Value<DateTime> createdAt;
  const AppBindingsCompanion({
    this.id = const Value.absent(),
    this.packageName = const Value.absent(),
    this.appLabel = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.radiusMeters = const Value.absent(),
    this.locationLabel = const Value.absent(),
    this.url = const Value.absent(),
    this.iconData = const Value.absent(),
    this.usageCount = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AppBindingsCompanion.insert({
    this.id = const Value.absent(),
    required String packageName,
    required String appLabel,
    required double latitude,
    required double longitude,
    this.radiusMeters = const Value.absent(),
    this.locationLabel = const Value.absent(),
    this.url = const Value.absent(),
    this.iconData = const Value.absent(),
    this.usageCount = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : packageName = Value(packageName),
       appLabel = Value(appLabel),
       latitude = Value(latitude),
       longitude = Value(longitude);
  static Insertable<AppBinding> custom({
    Expression<int>? id,
    Expression<String>? packageName,
    Expression<String>? appLabel,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<int>? radiusMeters,
    Expression<String>? locationLabel,
    Expression<String>? url,
    Expression<Uint8List>? iconData,
    Expression<int>? usageCount,
    Expression<DateTime>? lastUsedAt,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (packageName != null) 'package_name': packageName,
      if (appLabel != null) 'app_label': appLabel,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (radiusMeters != null) 'radius_meters': radiusMeters,
      if (locationLabel != null) 'location_label': locationLabel,
      if (url != null) 'url': url,
      if (iconData != null) 'icon_data': iconData,
      if (usageCount != null) 'usage_count': usageCount,
      if (lastUsedAt != null) 'last_used_at': lastUsedAt,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AppBindingsCompanion copyWith({
    Value<int>? id,
    Value<String>? packageName,
    Value<String>? appLabel,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<int>? radiusMeters,
    Value<String?>? locationLabel,
    Value<String?>? url,
    Value<Uint8List?>? iconData,
    Value<int>? usageCount,
    Value<DateTime?>? lastUsedAt,
    Value<DateTime>? createdAt,
  }) {
    return AppBindingsCompanion(
      id: id ?? this.id,
      packageName: packageName ?? this.packageName,
      appLabel: appLabel ?? this.appLabel,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      radiusMeters: radiusMeters ?? this.radiusMeters,
      locationLabel: locationLabel ?? this.locationLabel,
      url: url ?? this.url,
      iconData: iconData ?? this.iconData,
      usageCount: usageCount ?? this.usageCount,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (packageName.present) {
      map['package_name'] = Variable<String>(packageName.value);
    }
    if (appLabel.present) {
      map['app_label'] = Variable<String>(appLabel.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (radiusMeters.present) {
      map['radius_meters'] = Variable<int>(radiusMeters.value);
    }
    if (locationLabel.present) {
      map['location_label'] = Variable<String>(locationLabel.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (iconData.present) {
      map['icon_data'] = Variable<Uint8List>(iconData.value);
    }
    if (usageCount.present) {
      map['usage_count'] = Variable<int>(usageCount.value);
    }
    if (lastUsedAt.present) {
      map['last_used_at'] = Variable<DateTime>(lastUsedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppBindingsCompanion(')
          ..write('id: $id, ')
          ..write('packageName: $packageName, ')
          ..write('appLabel: $appLabel, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('radiusMeters: $radiusMeters, ')
          ..write('locationLabel: $locationLabel, ')
          ..write('url: $url, ')
          ..write('iconData: $iconData, ')
          ..write('usageCount: $usageCount, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AppBindingsTable appBindings = $AppBindingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [appBindings];
}

typedef $$AppBindingsTableCreateCompanionBuilder =
    AppBindingsCompanion Function({
      Value<int> id,
      required String packageName,
      required String appLabel,
      required double latitude,
      required double longitude,
      Value<int> radiusMeters,
      Value<String?> locationLabel,
      Value<String?> url,
      Value<Uint8List?> iconData,
      Value<int> usageCount,
      Value<DateTime?> lastUsedAt,
      Value<DateTime> createdAt,
    });
typedef $$AppBindingsTableUpdateCompanionBuilder =
    AppBindingsCompanion Function({
      Value<int> id,
      Value<String> packageName,
      Value<String> appLabel,
      Value<double> latitude,
      Value<double> longitude,
      Value<int> radiusMeters,
      Value<String?> locationLabel,
      Value<String?> url,
      Value<Uint8List?> iconData,
      Value<int> usageCount,
      Value<DateTime?> lastUsedAt,
      Value<DateTime> createdAt,
    });

class $$AppBindingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppBindingsTable> {
  $$AppBindingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appLabel => $composableBuilder(
    column: $table.appLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get radiusMeters => $composableBuilder(
    column: $table.radiusMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locationLabel => $composableBuilder(
    column: $table.locationLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get iconData => $composableBuilder(
    column: $table.iconData,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get usageCount => $composableBuilder(
    column: $table.usageCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppBindingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppBindingsTable> {
  $$AppBindingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appLabel => $composableBuilder(
    column: $table.appLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get radiusMeters => $composableBuilder(
    column: $table.radiusMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locationLabel => $composableBuilder(
    column: $table.locationLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get iconData => $composableBuilder(
    column: $table.iconData,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get usageCount => $composableBuilder(
    column: $table.usageCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppBindingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppBindingsTable> {
  $$AppBindingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get packageName => $composableBuilder(
    column: $table.packageName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get appLabel =>
      $composableBuilder(column: $table.appLabel, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<int> get radiusMeters => $composableBuilder(
    column: $table.radiusMeters,
    builder: (column) => column,
  );

  GeneratedColumn<String> get locationLabel => $composableBuilder(
    column: $table.locationLabel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<Uint8List> get iconData =>
      $composableBuilder(column: $table.iconData, builder: (column) => column);

  GeneratedColumn<int> get usageCount => $composableBuilder(
    column: $table.usageCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AppBindingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppBindingsTable,
          AppBinding,
          $$AppBindingsTableFilterComposer,
          $$AppBindingsTableOrderingComposer,
          $$AppBindingsTableAnnotationComposer,
          $$AppBindingsTableCreateCompanionBuilder,
          $$AppBindingsTableUpdateCompanionBuilder,
          (
            AppBinding,
            BaseReferences<_$AppDatabase, $AppBindingsTable, AppBinding>,
          ),
          AppBinding,
          PrefetchHooks Function()
        > {
  $$AppBindingsTableTableManager(_$AppDatabase db, $AppBindingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppBindingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppBindingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppBindingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> packageName = const Value.absent(),
                Value<String> appLabel = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<int> radiusMeters = const Value.absent(),
                Value<String?> locationLabel = const Value.absent(),
                Value<String?> url = const Value.absent(),
                Value<Uint8List?> iconData = const Value.absent(),
                Value<int> usageCount = const Value.absent(),
                Value<DateTime?> lastUsedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AppBindingsCompanion(
                id: id,
                packageName: packageName,
                appLabel: appLabel,
                latitude: latitude,
                longitude: longitude,
                radiusMeters: radiusMeters,
                locationLabel: locationLabel,
                url: url,
                iconData: iconData,
                usageCount: usageCount,
                lastUsedAt: lastUsedAt,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String packageName,
                required String appLabel,
                required double latitude,
                required double longitude,
                Value<int> radiusMeters = const Value.absent(),
                Value<String?> locationLabel = const Value.absent(),
                Value<String?> url = const Value.absent(),
                Value<Uint8List?> iconData = const Value.absent(),
                Value<int> usageCount = const Value.absent(),
                Value<DateTime?> lastUsedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AppBindingsCompanion.insert(
                id: id,
                packageName: packageName,
                appLabel: appLabel,
                latitude: latitude,
                longitude: longitude,
                radiusMeters: radiusMeters,
                locationLabel: locationLabel,
                url: url,
                iconData: iconData,
                usageCount: usageCount,
                lastUsedAt: lastUsedAt,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppBindingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppBindingsTable,
      AppBinding,
      $$AppBindingsTableFilterComposer,
      $$AppBindingsTableOrderingComposer,
      $$AppBindingsTableAnnotationComposer,
      $$AppBindingsTableCreateCompanionBuilder,
      $$AppBindingsTableUpdateCompanionBuilder,
      (
        AppBinding,
        BaseReferences<_$AppDatabase, $AppBindingsTable, AppBinding>,
      ),
      AppBinding,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AppBindingsTableTableManager get appBindings =>
      $$AppBindingsTableTableManager(_db, _db.appBindings);
}
