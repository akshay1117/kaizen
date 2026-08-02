// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_database.dart';

// ignore_for_file: type=lint
class $ExpenseTrackersTable extends ExpenseTrackers
    with TableInfo<$ExpenseTrackersTable, ExpenseTracker> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpenseTrackersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => '${DateTime.now().millisecondsSinceEpoch}');
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _budgetMeta = const VerificationMeta('budget');
  @override
  late final GeneratedColumn<double> budget = GeneratedColumn<double>(
      'budget', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _cycleTypeMeta =
      const VerificationMeta('cycleType');
  @override
  late final GeneratedColumn<String> cycleType = GeneratedColumn<String>(
      'cycle_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Monthly'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, budget, cycleType, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expense_trackers';
  @override
  VerificationContext validateIntegrity(Insertable<ExpenseTracker> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('budget')) {
      context.handle(_budgetMeta,
          budget.isAcceptableOrUnknown(data['budget']!, _budgetMeta));
    }
    if (data.containsKey('cycle_type')) {
      context.handle(_cycleTypeMeta,
          cycleType.isAcceptableOrUnknown(data['cycle_type']!, _cycleTypeMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpenseTracker map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseTracker(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      budget: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}budget']),
      cycleType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}cycle_type'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ExpenseTrackersTable createAlias(String alias) {
    return $ExpenseTrackersTable(attachedDatabase, alias);
  }
}

class ExpenseTracker extends DataClass implements Insertable<ExpenseTracker> {
  final String id;
  final String name;
  final double? budget;
  final String cycleType;
  final DateTime createdAt;
  const ExpenseTracker(
      {required this.id,
      required this.name,
      this.budget,
      required this.cycleType,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || budget != null) {
      map['budget'] = Variable<double>(budget);
    }
    map['cycle_type'] = Variable<String>(cycleType);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ExpenseTrackersCompanion toCompanion(bool nullToAbsent) {
    return ExpenseTrackersCompanion(
      id: Value(id),
      name: Value(name),
      budget:
          budget == null && nullToAbsent ? const Value.absent() : Value(budget),
      cycleType: Value(cycleType),
      createdAt: Value(createdAt),
    );
  }

  factory ExpenseTracker.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseTracker(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      budget: serializer.fromJson<double?>(json['budget']),
      cycleType: serializer.fromJson<String>(json['cycleType']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'budget': serializer.toJson<double?>(budget),
      'cycleType': serializer.toJson<String>(cycleType),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ExpenseTracker copyWith(
          {String? id,
          String? name,
          Value<double?> budget = const Value.absent(),
          String? cycleType,
          DateTime? createdAt}) =>
      ExpenseTracker(
        id: id ?? this.id,
        name: name ?? this.name,
        budget: budget.present ? budget.value : this.budget,
        cycleType: cycleType ?? this.cycleType,
        createdAt: createdAt ?? this.createdAt,
      );
  ExpenseTracker copyWithCompanion(ExpenseTrackersCompanion data) {
    return ExpenseTracker(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      budget: data.budget.present ? data.budget.value : this.budget,
      cycleType: data.cycleType.present ? data.cycleType.value : this.cycleType,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseTracker(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('budget: $budget, ')
          ..write('cycleType: $cycleType, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, budget, cycleType, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseTracker &&
          other.id == this.id &&
          other.name == this.name &&
          other.budget == this.budget &&
          other.cycleType == this.cycleType &&
          other.createdAt == this.createdAt);
}

class ExpenseTrackersCompanion extends UpdateCompanion<ExpenseTracker> {
  final Value<String> id;
  final Value<String> name;
  final Value<double?> budget;
  final Value<String> cycleType;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ExpenseTrackersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.budget = const Value.absent(),
    this.cycleType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExpenseTrackersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.budget = const Value.absent(),
    this.cycleType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<ExpenseTracker> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<double>? budget,
    Expression<String>? cycleType,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (budget != null) 'budget': budget,
      if (cycleType != null) 'cycle_type': cycleType,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExpenseTrackersCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<double?>? budget,
      Value<String>? cycleType,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return ExpenseTrackersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      budget: budget ?? this.budget,
      cycleType: cycleType ?? this.cycleType,
      createdAt: createdAt ?? this.createdAt,
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
    if (budget.present) {
      map['budget'] = Variable<double>(budget.value);
    }
    if (cycleType.present) {
      map['cycle_type'] = Variable<String>(cycleType.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseTrackersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('budget: $budget, ')
          ..write('cycleType: $cycleType, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExpenseMembersTable extends ExpenseMembers
    with TableInfo<$ExpenseMembersTable, ExpenseMember> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpenseMembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => '${DateTime.now().millisecondsSinceEpoch}');
  static const VerificationMeta _trackerIdMeta =
      const VerificationMeta('trackerId');
  @override
  late final GeneratedColumn<String> trackerId = GeneratedColumn<String>(
      'tracker_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES expense_trackers (id) ON DELETE CASCADE'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _avatarPathMeta =
      const VerificationMeta('avatarPath');
  @override
  late final GeneratedColumn<String> avatarPath = GeneratedColumn<String>(
      'avatar_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  @override
  List<GeneratedColumn> get $columns =>
      [id, trackerId, name, avatarPath, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expense_members';
  @override
  VerificationContext validateIntegrity(Insertable<ExpenseMember> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tracker_id')) {
      context.handle(_trackerIdMeta,
          trackerId.isAcceptableOrUnknown(data['tracker_id']!, _trackerIdMeta));
    } else if (isInserting) {
      context.missing(_trackerIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('avatar_path')) {
      context.handle(
          _avatarPathMeta,
          avatarPath.isAcceptableOrUnknown(
              data['avatar_path']!, _avatarPathMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpenseMember map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseMember(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      trackerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tracker_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      avatarPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}avatar_path']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ExpenseMembersTable createAlias(String alias) {
    return $ExpenseMembersTable(attachedDatabase, alias);
  }
}

class ExpenseMember extends DataClass implements Insertable<ExpenseMember> {
  final String id;
  final String trackerId;
  final String name;
  final String? avatarPath;
  final DateTime createdAt;
  const ExpenseMember(
      {required this.id,
      required this.trackerId,
      required this.name,
      this.avatarPath,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tracker_id'] = Variable<String>(trackerId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || avatarPath != null) {
      map['avatar_path'] = Variable<String>(avatarPath);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ExpenseMembersCompanion toCompanion(bool nullToAbsent) {
    return ExpenseMembersCompanion(
      id: Value(id),
      trackerId: Value(trackerId),
      name: Value(name),
      avatarPath: avatarPath == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarPath),
      createdAt: Value(createdAt),
    );
  }

  factory ExpenseMember.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseMember(
      id: serializer.fromJson<String>(json['id']),
      trackerId: serializer.fromJson<String>(json['trackerId']),
      name: serializer.fromJson<String>(json['name']),
      avatarPath: serializer.fromJson<String?>(json['avatarPath']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'trackerId': serializer.toJson<String>(trackerId),
      'name': serializer.toJson<String>(name),
      'avatarPath': serializer.toJson<String?>(avatarPath),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ExpenseMember copyWith(
          {String? id,
          String? trackerId,
          String? name,
          Value<String?> avatarPath = const Value.absent(),
          DateTime? createdAt}) =>
      ExpenseMember(
        id: id ?? this.id,
        trackerId: trackerId ?? this.trackerId,
        name: name ?? this.name,
        avatarPath: avatarPath.present ? avatarPath.value : this.avatarPath,
        createdAt: createdAt ?? this.createdAt,
      );
  ExpenseMember copyWithCompanion(ExpenseMembersCompanion data) {
    return ExpenseMember(
      id: data.id.present ? data.id.value : this.id,
      trackerId: data.trackerId.present ? data.trackerId.value : this.trackerId,
      name: data.name.present ? data.name.value : this.name,
      avatarPath:
          data.avatarPath.present ? data.avatarPath.value : this.avatarPath,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseMember(')
          ..write('id: $id, ')
          ..write('trackerId: $trackerId, ')
          ..write('name: $name, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, trackerId, name, avatarPath, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseMember &&
          other.id == this.id &&
          other.trackerId == this.trackerId &&
          other.name == this.name &&
          other.avatarPath == this.avatarPath &&
          other.createdAt == this.createdAt);
}

class ExpenseMembersCompanion extends UpdateCompanion<ExpenseMember> {
  final Value<String> id;
  final Value<String> trackerId;
  final Value<String> name;
  final Value<String?> avatarPath;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ExpenseMembersCompanion({
    this.id = const Value.absent(),
    this.trackerId = const Value.absent(),
    this.name = const Value.absent(),
    this.avatarPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExpenseMembersCompanion.insert({
    this.id = const Value.absent(),
    required String trackerId,
    required String name,
    this.avatarPath = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : trackerId = Value(trackerId),
        name = Value(name);
  static Insertable<ExpenseMember> custom({
    Expression<String>? id,
    Expression<String>? trackerId,
    Expression<String>? name,
    Expression<String>? avatarPath,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (trackerId != null) 'tracker_id': trackerId,
      if (name != null) 'name': name,
      if (avatarPath != null) 'avatar_path': avatarPath,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExpenseMembersCompanion copyWith(
      {Value<String>? id,
      Value<String>? trackerId,
      Value<String>? name,
      Value<String?>? avatarPath,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return ExpenseMembersCompanion(
      id: id ?? this.id,
      trackerId: trackerId ?? this.trackerId,
      name: name ?? this.name,
      avatarPath: avatarPath ?? this.avatarPath,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (trackerId.present) {
      map['tracker_id'] = Variable<String>(trackerId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (avatarPath.present) {
      map['avatar_path'] = Variable<String>(avatarPath.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseMembersCompanion(')
          ..write('id: $id, ')
          ..write('trackerId: $trackerId, ')
          ..write('name: $name, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExpenseAccountsTable extends ExpenseAccounts
    with TableInfo<$ExpenseAccountsTable, ExpenseAccount> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpenseAccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => '${DateTime.now().millisecondsSinceEpoch}');
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('wallet'));
  static const VerificationMeta _initialBalanceMeta =
      const VerificationMeta('initialBalance');
  @override
  late final GeneratedColumn<double> initialBalance = GeneratedColumn<double>(
      'initial_balance', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, icon, initialBalance, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expense_accounts';
  @override
  VerificationContext validateIntegrity(Insertable<ExpenseAccount> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    }
    if (data.containsKey('initial_balance')) {
      context.handle(
          _initialBalanceMeta,
          initialBalance.isAcceptableOrUnknown(
              data['initial_balance']!, _initialBalanceMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpenseAccount map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseAccount(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon'])!,
      initialBalance: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}initial_balance'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ExpenseAccountsTable createAlias(String alias) {
    return $ExpenseAccountsTable(attachedDatabase, alias);
  }
}

class ExpenseAccount extends DataClass implements Insertable<ExpenseAccount> {
  final String id;
  final String name;
  final String icon;
  final double initialBalance;
  final DateTime createdAt;
  const ExpenseAccount(
      {required this.id,
      required this.name,
      required this.icon,
      required this.initialBalance,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['icon'] = Variable<String>(icon);
    map['initial_balance'] = Variable<double>(initialBalance);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ExpenseAccountsCompanion toCompanion(bool nullToAbsent) {
    return ExpenseAccountsCompanion(
      id: Value(id),
      name: Value(name),
      icon: Value(icon),
      initialBalance: Value(initialBalance),
      createdAt: Value(createdAt),
    );
  }

  factory ExpenseAccount.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseAccount(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String>(json['icon']),
      initialBalance: serializer.fromJson<double>(json['initialBalance']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String>(icon),
      'initialBalance': serializer.toJson<double>(initialBalance),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ExpenseAccount copyWith(
          {String? id,
          String? name,
          String? icon,
          double? initialBalance,
          DateTime? createdAt}) =>
      ExpenseAccount(
        id: id ?? this.id,
        name: name ?? this.name,
        icon: icon ?? this.icon,
        initialBalance: initialBalance ?? this.initialBalance,
        createdAt: createdAt ?? this.createdAt,
      );
  ExpenseAccount copyWithCompanion(ExpenseAccountsCompanion data) {
    return ExpenseAccount(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      initialBalance: data.initialBalance.present
          ? data.initialBalance.value
          : this.initialBalance,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseAccount(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('initialBalance: $initialBalance, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, icon, initialBalance, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseAccount &&
          other.id == this.id &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.initialBalance == this.initialBalance &&
          other.createdAt == this.createdAt);
}

class ExpenseAccountsCompanion extends UpdateCompanion<ExpenseAccount> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> icon;
  final Value<double> initialBalance;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ExpenseAccountsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.initialBalance = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExpenseAccountsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.icon = const Value.absent(),
    this.initialBalance = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<ExpenseAccount> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<double>? initialBalance,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (initialBalance != null) 'initial_balance': initialBalance,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExpenseAccountsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? icon,
      Value<double>? initialBalance,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return ExpenseAccountsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      initialBalance: initialBalance ?? this.initialBalance,
      createdAt: createdAt ?? this.createdAt,
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
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (initialBalance.present) {
      map['initial_balance'] = Variable<double>(initialBalance.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseAccountsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('initialBalance: $initialBalance, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExpenseCategoriesTable extends ExpenseCategories
    with TableInfo<$ExpenseCategoriesTable, ExpenseCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpenseCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => '${DateTime.now().millisecondsSinceEpoch}');
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
      'icon', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _colorHexMeta =
      const VerificationMeta('colorHex');
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
      'color_hex', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isIncomeMeta =
      const VerificationMeta('isIncome');
  @override
  late final GeneratedColumn<bool> isIncome = GeneratedColumn<bool>(
      'is_income', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_income" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, icon, colorHex, isIncome, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expense_categories';
  @override
  VerificationContext validateIntegrity(Insertable<ExpenseCategory> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
          _iconMeta, icon.isAcceptableOrUnknown(data['icon']!, _iconMeta));
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('color_hex')) {
      context.handle(_colorHexMeta,
          colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta));
    } else if (isInserting) {
      context.missing(_colorHexMeta);
    }
    if (data.containsKey('is_income')) {
      context.handle(_isIncomeMeta,
          isIncome.isAcceptableOrUnknown(data['is_income']!, _isIncomeMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpenseCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseCategory(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      icon: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}icon'])!,
      colorHex: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}color_hex'])!,
      isIncome: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_income'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ExpenseCategoriesTable createAlias(String alias) {
    return $ExpenseCategoriesTable(attachedDatabase, alias);
  }
}

class ExpenseCategory extends DataClass implements Insertable<ExpenseCategory> {
  final String id;
  final String name;
  final String icon;
  final String colorHex;
  final bool isIncome;
  final DateTime createdAt;
  const ExpenseCategory(
      {required this.id,
      required this.name,
      required this.icon,
      required this.colorHex,
      required this.isIncome,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['icon'] = Variable<String>(icon);
    map['color_hex'] = Variable<String>(colorHex);
    map['is_income'] = Variable<bool>(isIncome);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ExpenseCategoriesCompanion toCompanion(bool nullToAbsent) {
    return ExpenseCategoriesCompanion(
      id: Value(id),
      name: Value(name),
      icon: Value(icon),
      colorHex: Value(colorHex),
      isIncome: Value(isIncome),
      createdAt: Value(createdAt),
    );
  }

  factory ExpenseCategory.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseCategory(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      icon: serializer.fromJson<String>(json['icon']),
      colorHex: serializer.fromJson<String>(json['colorHex']),
      isIncome: serializer.fromJson<bool>(json['isIncome']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'icon': serializer.toJson<String>(icon),
      'colorHex': serializer.toJson<String>(colorHex),
      'isIncome': serializer.toJson<bool>(isIncome),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ExpenseCategory copyWith(
          {String? id,
          String? name,
          String? icon,
          String? colorHex,
          bool? isIncome,
          DateTime? createdAt}) =>
      ExpenseCategory(
        id: id ?? this.id,
        name: name ?? this.name,
        icon: icon ?? this.icon,
        colorHex: colorHex ?? this.colorHex,
        isIncome: isIncome ?? this.isIncome,
        createdAt: createdAt ?? this.createdAt,
      );
  ExpenseCategory copyWithCompanion(ExpenseCategoriesCompanion data) {
    return ExpenseCategory(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      icon: data.icon.present ? data.icon.value : this.icon,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      isIncome: data.isIncome.present ? data.isIncome.value : this.isIncome,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseCategory(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('colorHex: $colorHex, ')
          ..write('isIncome: $isIncome, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, icon, colorHex, isIncome, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseCategory &&
          other.id == this.id &&
          other.name == this.name &&
          other.icon == this.icon &&
          other.colorHex == this.colorHex &&
          other.isIncome == this.isIncome &&
          other.createdAt == this.createdAt);
}

class ExpenseCategoriesCompanion extends UpdateCompanion<ExpenseCategory> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> icon;
  final Value<String> colorHex;
  final Value<bool> isIncome;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ExpenseCategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.icon = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.isIncome = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExpenseCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String icon,
    required String colorHex,
    this.isIncome = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : name = Value(name),
        icon = Value(icon),
        colorHex = Value(colorHex);
  static Insertable<ExpenseCategory> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? icon,
    Expression<String>? colorHex,
    Expression<bool>? isIncome,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (icon != null) 'icon': icon,
      if (colorHex != null) 'color_hex': colorHex,
      if (isIncome != null) 'is_income': isIncome,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExpenseCategoriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? icon,
      Value<String>? colorHex,
      Value<bool>? isIncome,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return ExpenseCategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      colorHex: colorHex ?? this.colorHex,
      isIncome: isIncome ?? this.isIncome,
      createdAt: createdAt ?? this.createdAt,
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
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (isIncome.present) {
      map['is_income'] = Variable<bool>(isIncome.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('icon: $icon, ')
          ..write('colorHex: $colorHex, ')
          ..write('isIncome: $isIncome, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExpenseSubscriptionsTable extends ExpenseSubscriptions
    with TableInfo<$ExpenseSubscriptionsTable, ExpenseSubscription> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpenseSubscriptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => '${DateTime.now().millisecondsSinceEpoch}');
  static const VerificationMeta _trackerIdMeta =
      const VerificationMeta('trackerId');
  @override
  late final GeneratedColumn<String> trackerId = GeneratedColumn<String>(
      'tracker_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES expense_trackers (id) ON DELETE CASCADE'));
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
      'account_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES expense_accounts (id) ON DELETE SET NULL'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _endDateMeta =
      const VerificationMeta('endDate');
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
      'end_date', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _intervalMeta =
      const VerificationMeta('interval');
  @override
  late final GeneratedColumn<String> interval = GeneratedColumn<String>(
      'interval', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('1 Month'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  @override
  List<GeneratedColumn> get $columns => [
        id,
        trackerId,
        accountId,
        name,
        amount,
        startDate,
        endDate,
        interval,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expense_subscriptions';
  @override
  VerificationContext validateIntegrity(
      Insertable<ExpenseSubscription> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tracker_id')) {
      context.handle(_trackerIdMeta,
          trackerId.isAcceptableOrUnknown(data['tracker_id']!, _trackerIdMeta));
    } else if (isInserting) {
      context.missing(_trackerIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(_endDateMeta,
          endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta));
    }
    if (data.containsKey('interval')) {
      context.handle(_intervalMeta,
          interval.isAcceptableOrUnknown(data['interval']!, _intervalMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpenseSubscription map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseSubscription(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      trackerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tracker_id'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_id']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      endDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}end_date']),
      interval: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}interval'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ExpenseSubscriptionsTable createAlias(String alias) {
    return $ExpenseSubscriptionsTable(attachedDatabase, alias);
  }
}

class ExpenseSubscription extends DataClass
    implements Insertable<ExpenseSubscription> {
  final String id;
  final String trackerId;
  final String? accountId;
  final String name;
  final double amount;
  final DateTime startDate;
  final DateTime? endDate;
  final String interval;
  final DateTime createdAt;
  const ExpenseSubscription(
      {required this.id,
      required this.trackerId,
      this.accountId,
      required this.name,
      required this.amount,
      required this.startDate,
      this.endDate,
      required this.interval,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tracker_id'] = Variable<String>(trackerId);
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<String>(accountId);
    }
    map['name'] = Variable<String>(name);
    map['amount'] = Variable<double>(amount);
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    map['interval'] = Variable<String>(interval);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ExpenseSubscriptionsCompanion toCompanion(bool nullToAbsent) {
    return ExpenseSubscriptionsCompanion(
      id: Value(id),
      trackerId: Value(trackerId),
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      name: Value(name),
      amount: Value(amount),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      interval: Value(interval),
      createdAt: Value(createdAt),
    );
  }

  factory ExpenseSubscription.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseSubscription(
      id: serializer.fromJson<String>(json['id']),
      trackerId: serializer.fromJson<String>(json['trackerId']),
      accountId: serializer.fromJson<String?>(json['accountId']),
      name: serializer.fromJson<String>(json['name']),
      amount: serializer.fromJson<double>(json['amount']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      interval: serializer.fromJson<String>(json['interval']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'trackerId': serializer.toJson<String>(trackerId),
      'accountId': serializer.toJson<String?>(accountId),
      'name': serializer.toJson<String>(name),
      'amount': serializer.toJson<double>(amount),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'interval': serializer.toJson<String>(interval),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ExpenseSubscription copyWith(
          {String? id,
          String? trackerId,
          Value<String?> accountId = const Value.absent(),
          String? name,
          double? amount,
          DateTime? startDate,
          Value<DateTime?> endDate = const Value.absent(),
          String? interval,
          DateTime? createdAt}) =>
      ExpenseSubscription(
        id: id ?? this.id,
        trackerId: trackerId ?? this.trackerId,
        accountId: accountId.present ? accountId.value : this.accountId,
        name: name ?? this.name,
        amount: amount ?? this.amount,
        startDate: startDate ?? this.startDate,
        endDate: endDate.present ? endDate.value : this.endDate,
        interval: interval ?? this.interval,
        createdAt: createdAt ?? this.createdAt,
      );
  ExpenseSubscription copyWithCompanion(ExpenseSubscriptionsCompanion data) {
    return ExpenseSubscription(
      id: data.id.present ? data.id.value : this.id,
      trackerId: data.trackerId.present ? data.trackerId.value : this.trackerId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      name: data.name.present ? data.name.value : this.name,
      amount: data.amount.present ? data.amount.value : this.amount,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      interval: data.interval.present ? data.interval.value : this.interval,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseSubscription(')
          ..write('id: $id, ')
          ..write('trackerId: $trackerId, ')
          ..write('accountId: $accountId, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('interval: $interval, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, trackerId, accountId, name, amount,
      startDate, endDate, interval, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseSubscription &&
          other.id == this.id &&
          other.trackerId == this.trackerId &&
          other.accountId == this.accountId &&
          other.name == this.name &&
          other.amount == this.amount &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.interval == this.interval &&
          other.createdAt == this.createdAt);
}

class ExpenseSubscriptionsCompanion
    extends UpdateCompanion<ExpenseSubscription> {
  final Value<String> id;
  final Value<String> trackerId;
  final Value<String?> accountId;
  final Value<String> name;
  final Value<double> amount;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  final Value<String> interval;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ExpenseSubscriptionsCompanion({
    this.id = const Value.absent(),
    this.trackerId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.name = const Value.absent(),
    this.amount = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.interval = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExpenseSubscriptionsCompanion.insert({
    this.id = const Value.absent(),
    required String trackerId,
    this.accountId = const Value.absent(),
    required String name,
    required double amount,
    required DateTime startDate,
    this.endDate = const Value.absent(),
    this.interval = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : trackerId = Value(trackerId),
        name = Value(name),
        amount = Value(amount),
        startDate = Value(startDate);
  static Insertable<ExpenseSubscription> custom({
    Expression<String>? id,
    Expression<String>? trackerId,
    Expression<String>? accountId,
    Expression<String>? name,
    Expression<double>? amount,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<String>? interval,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (trackerId != null) 'tracker_id': trackerId,
      if (accountId != null) 'account_id': accountId,
      if (name != null) 'name': name,
      if (amount != null) 'amount': amount,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (interval != null) 'interval': interval,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExpenseSubscriptionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? trackerId,
      Value<String?>? accountId,
      Value<String>? name,
      Value<double>? amount,
      Value<DateTime>? startDate,
      Value<DateTime?>? endDate,
      Value<String>? interval,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return ExpenseSubscriptionsCompanion(
      id: id ?? this.id,
      trackerId: trackerId ?? this.trackerId,
      accountId: accountId ?? this.accountId,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      interval: interval ?? this.interval,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (trackerId.present) {
      map['tracker_id'] = Variable<String>(trackerId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (interval.present) {
      map['interval'] = Variable<String>(interval.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseSubscriptionsCompanion(')
          ..write('id: $id, ')
          ..write('trackerId: $trackerId, ')
          ..write('accountId: $accountId, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('interval: $interval, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExpenseInstallmentsTable extends ExpenseInstallments
    with TableInfo<$ExpenseInstallmentsTable, ExpenseInstallment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpenseInstallmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => '${DateTime.now().millisecondsSinceEpoch}');
  static const VerificationMeta _trackerIdMeta =
      const VerificationMeta('trackerId');
  @override
  late final GeneratedColumn<String> trackerId = GeneratedColumn<String>(
      'tracker_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES expense_trackers (id) ON DELETE CASCADE'));
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
      'account_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES expense_accounts (id) ON DELETE SET NULL'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _totalAmountMeta =
      const VerificationMeta('totalAmount');
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
      'total_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _installmentAmountMeta =
      const VerificationMeta('installmentAmount');
  @override
  late final GeneratedColumn<double> installmentAmount =
      GeneratedColumn<double>('installment_amount', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _startDateMeta =
      const VerificationMeta('startDate');
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
      'start_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  @override
  List<GeneratedColumn> get $columns => [
        id,
        trackerId,
        accountId,
        name,
        totalAmount,
        installmentAmount,
        startDate,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expense_installments';
  @override
  VerificationContext validateIntegrity(Insertable<ExpenseInstallment> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tracker_id')) {
      context.handle(_trackerIdMeta,
          trackerId.isAcceptableOrUnknown(data['tracker_id']!, _trackerIdMeta));
    } else if (isInserting) {
      context.missing(_trackerIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('total_amount')) {
      context.handle(
          _totalAmountMeta,
          totalAmount.isAcceptableOrUnknown(
              data['total_amount']!, _totalAmountMeta));
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    if (data.containsKey('installment_amount')) {
      context.handle(
          _installmentAmountMeta,
          installmentAmount.isAcceptableOrUnknown(
              data['installment_amount']!, _installmentAmountMeta));
    } else if (isInserting) {
      context.missing(_installmentAmountMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(_startDateMeta,
          startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta));
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpenseInstallment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseInstallment(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      trackerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tracker_id'])!,
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_id']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      totalAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_amount'])!,
      installmentAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}installment_amount'])!,
      startDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}start_date'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ExpenseInstallmentsTable createAlias(String alias) {
    return $ExpenseInstallmentsTable(attachedDatabase, alias);
  }
}

class ExpenseInstallment extends DataClass
    implements Insertable<ExpenseInstallment> {
  final String id;
  final String trackerId;
  final String? accountId;
  final String name;
  final double totalAmount;
  final double installmentAmount;
  final DateTime startDate;
  final DateTime createdAt;
  const ExpenseInstallment(
      {required this.id,
      required this.trackerId,
      this.accountId,
      required this.name,
      required this.totalAmount,
      required this.installmentAmount,
      required this.startDate,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tracker_id'] = Variable<String>(trackerId);
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<String>(accountId);
    }
    map['name'] = Variable<String>(name);
    map['total_amount'] = Variable<double>(totalAmount);
    map['installment_amount'] = Variable<double>(installmentAmount);
    map['start_date'] = Variable<DateTime>(startDate);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ExpenseInstallmentsCompanion toCompanion(bool nullToAbsent) {
    return ExpenseInstallmentsCompanion(
      id: Value(id),
      trackerId: Value(trackerId),
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      name: Value(name),
      totalAmount: Value(totalAmount),
      installmentAmount: Value(installmentAmount),
      startDate: Value(startDate),
      createdAt: Value(createdAt),
    );
  }

  factory ExpenseInstallment.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseInstallment(
      id: serializer.fromJson<String>(json['id']),
      trackerId: serializer.fromJson<String>(json['trackerId']),
      accountId: serializer.fromJson<String?>(json['accountId']),
      name: serializer.fromJson<String>(json['name']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      installmentAmount: serializer.fromJson<double>(json['installmentAmount']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'trackerId': serializer.toJson<String>(trackerId),
      'accountId': serializer.toJson<String?>(accountId),
      'name': serializer.toJson<String>(name),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'installmentAmount': serializer.toJson<double>(installmentAmount),
      'startDate': serializer.toJson<DateTime>(startDate),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ExpenseInstallment copyWith(
          {String? id,
          String? trackerId,
          Value<String?> accountId = const Value.absent(),
          String? name,
          double? totalAmount,
          double? installmentAmount,
          DateTime? startDate,
          DateTime? createdAt}) =>
      ExpenseInstallment(
        id: id ?? this.id,
        trackerId: trackerId ?? this.trackerId,
        accountId: accountId.present ? accountId.value : this.accountId,
        name: name ?? this.name,
        totalAmount: totalAmount ?? this.totalAmount,
        installmentAmount: installmentAmount ?? this.installmentAmount,
        startDate: startDate ?? this.startDate,
        createdAt: createdAt ?? this.createdAt,
      );
  ExpenseInstallment copyWithCompanion(ExpenseInstallmentsCompanion data) {
    return ExpenseInstallment(
      id: data.id.present ? data.id.value : this.id,
      trackerId: data.trackerId.present ? data.trackerId.value : this.trackerId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      name: data.name.present ? data.name.value : this.name,
      totalAmount:
          data.totalAmount.present ? data.totalAmount.value : this.totalAmount,
      installmentAmount: data.installmentAmount.present
          ? data.installmentAmount.value
          : this.installmentAmount,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseInstallment(')
          ..write('id: $id, ')
          ..write('trackerId: $trackerId, ')
          ..write('accountId: $accountId, ')
          ..write('name: $name, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('installmentAmount: $installmentAmount, ')
          ..write('startDate: $startDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, trackerId, accountId, name, totalAmount,
      installmentAmount, startDate, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseInstallment &&
          other.id == this.id &&
          other.trackerId == this.trackerId &&
          other.accountId == this.accountId &&
          other.name == this.name &&
          other.totalAmount == this.totalAmount &&
          other.installmentAmount == this.installmentAmount &&
          other.startDate == this.startDate &&
          other.createdAt == this.createdAt);
}

class ExpenseInstallmentsCompanion extends UpdateCompanion<ExpenseInstallment> {
  final Value<String> id;
  final Value<String> trackerId;
  final Value<String?> accountId;
  final Value<String> name;
  final Value<double> totalAmount;
  final Value<double> installmentAmount;
  final Value<DateTime> startDate;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ExpenseInstallmentsCompanion({
    this.id = const Value.absent(),
    this.trackerId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.name = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.installmentAmount = const Value.absent(),
    this.startDate = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExpenseInstallmentsCompanion.insert({
    this.id = const Value.absent(),
    required String trackerId,
    this.accountId = const Value.absent(),
    required String name,
    required double totalAmount,
    required double installmentAmount,
    required DateTime startDate,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : trackerId = Value(trackerId),
        name = Value(name),
        totalAmount = Value(totalAmount),
        installmentAmount = Value(installmentAmount),
        startDate = Value(startDate);
  static Insertable<ExpenseInstallment> custom({
    Expression<String>? id,
    Expression<String>? trackerId,
    Expression<String>? accountId,
    Expression<String>? name,
    Expression<double>? totalAmount,
    Expression<double>? installmentAmount,
    Expression<DateTime>? startDate,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (trackerId != null) 'tracker_id': trackerId,
      if (accountId != null) 'account_id': accountId,
      if (name != null) 'name': name,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (installmentAmount != null) 'installment_amount': installmentAmount,
      if (startDate != null) 'start_date': startDate,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExpenseInstallmentsCompanion copyWith(
      {Value<String>? id,
      Value<String>? trackerId,
      Value<String?>? accountId,
      Value<String>? name,
      Value<double>? totalAmount,
      Value<double>? installmentAmount,
      Value<DateTime>? startDate,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return ExpenseInstallmentsCompanion(
      id: id ?? this.id,
      trackerId: trackerId ?? this.trackerId,
      accountId: accountId ?? this.accountId,
      name: name ?? this.name,
      totalAmount: totalAmount ?? this.totalAmount,
      installmentAmount: installmentAmount ?? this.installmentAmount,
      startDate: startDate ?? this.startDate,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (trackerId.present) {
      map['tracker_id'] = Variable<String>(trackerId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (installmentAmount.present) {
      map['installment_amount'] = Variable<double>(installmentAmount.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseInstallmentsCompanion(')
          ..write('id: $id, ')
          ..write('trackerId: $trackerId, ')
          ..write('accountId: $accountId, ')
          ..write('name: $name, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('installmentAmount: $installmentAmount, ')
          ..write('startDate: $startDate, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExpenseTransactionsTable extends ExpenseTransactions
    with TableInfo<$ExpenseTransactionsTable, ExpenseTransaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpenseTransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => '${DateTime.now().millisecondsSinceEpoch}');
  static const VerificationMeta _trackerIdMeta =
      const VerificationMeta('trackerId');
  @override
  late final GeneratedColumn<String> trackerId = GeneratedColumn<String>(
      'tracker_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES expense_trackers (id) ON DELETE CASCADE'));
  static const VerificationMeta _accountIdMeta =
      const VerificationMeta('accountId');
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
      'account_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES expense_accounts (id) ON DELETE SET NULL'));
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
      'category_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES expense_categories (id) ON DELETE CASCADE'));
  static const VerificationMeta _memberIdMeta =
      const VerificationMeta('memberId');
  @override
  late final GeneratedColumn<String> memberId = GeneratedColumn<String>(
      'member_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES expense_members (id) ON DELETE SET NULL'));
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _isIncomeMeta =
      const VerificationMeta('isIncome');
  @override
  late final GeneratedColumn<bool> isIncome = GeneratedColumn<bool>(
      'is_income', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_income" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _attachmentsMeta =
      const VerificationMeta('attachments');
  @override
  late final GeneratedColumn<String> attachments = GeneratedColumn<String>(
      'attachments', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  @override
  List<GeneratedColumn> get $columns => [
        id,
        trackerId,
        accountId,
        categoryId,
        memberId,
        amount,
        isIncome,
        date,
        note,
        attachments,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expense_transactions';
  @override
  VerificationContext validateIntegrity(Insertable<ExpenseTransaction> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tracker_id')) {
      context.handle(_trackerIdMeta,
          trackerId.isAcceptableOrUnknown(data['tracker_id']!, _trackerIdMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(_accountIdMeta,
          accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('member_id')) {
      context.handle(_memberIdMeta,
          memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('is_income')) {
      context.handle(_isIncomeMeta,
          isIncome.isAcceptableOrUnknown(data['is_income']!, _isIncomeMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('attachments')) {
      context.handle(
          _attachmentsMeta,
          attachments.isAcceptableOrUnknown(
              data['attachments']!, _attachmentsMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpenseTransaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseTransaction(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      trackerId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tracker_id']),
      accountId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_id']),
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_id'])!,
      memberId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}member_id']),
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      isIncome: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_income'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      attachments: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}attachments']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ExpenseTransactionsTable createAlias(String alias) {
    return $ExpenseTransactionsTable(attachedDatabase, alias);
  }
}

class ExpenseTransaction extends DataClass
    implements Insertable<ExpenseTransaction> {
  final String id;
  final String? trackerId;
  final String? accountId;
  final String categoryId;
  final String? memberId;
  final double amount;
  final bool isIncome;
  final DateTime date;
  final String? note;
  final String? attachments;
  final DateTime createdAt;
  const ExpenseTransaction(
      {required this.id,
      this.trackerId,
      this.accountId,
      required this.categoryId,
      this.memberId,
      required this.amount,
      required this.isIncome,
      required this.date,
      this.note,
      this.attachments,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || trackerId != null) {
      map['tracker_id'] = Variable<String>(trackerId);
    }
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<String>(accountId);
    }
    map['category_id'] = Variable<String>(categoryId);
    if (!nullToAbsent || memberId != null) {
      map['member_id'] = Variable<String>(memberId);
    }
    map['amount'] = Variable<double>(amount);
    map['is_income'] = Variable<bool>(isIncome);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || attachments != null) {
      map['attachments'] = Variable<String>(attachments);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ExpenseTransactionsCompanion toCompanion(bool nullToAbsent) {
    return ExpenseTransactionsCompanion(
      id: Value(id),
      trackerId: trackerId == null && nullToAbsent
          ? const Value.absent()
          : Value(trackerId),
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      categoryId: Value(categoryId),
      memberId: memberId == null && nullToAbsent
          ? const Value.absent()
          : Value(memberId),
      amount: Value(amount),
      isIncome: Value(isIncome),
      date: Value(date),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      attachments: attachments == null && nullToAbsent
          ? const Value.absent()
          : Value(attachments),
      createdAt: Value(createdAt),
    );
  }

  factory ExpenseTransaction.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseTransaction(
      id: serializer.fromJson<String>(json['id']),
      trackerId: serializer.fromJson<String?>(json['trackerId']),
      accountId: serializer.fromJson<String?>(json['accountId']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      memberId: serializer.fromJson<String?>(json['memberId']),
      amount: serializer.fromJson<double>(json['amount']),
      isIncome: serializer.fromJson<bool>(json['isIncome']),
      date: serializer.fromJson<DateTime>(json['date']),
      note: serializer.fromJson<String?>(json['note']),
      attachments: serializer.fromJson<String?>(json['attachments']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'trackerId': serializer.toJson<String?>(trackerId),
      'accountId': serializer.toJson<String?>(accountId),
      'categoryId': serializer.toJson<String>(categoryId),
      'memberId': serializer.toJson<String?>(memberId),
      'amount': serializer.toJson<double>(amount),
      'isIncome': serializer.toJson<bool>(isIncome),
      'date': serializer.toJson<DateTime>(date),
      'note': serializer.toJson<String?>(note),
      'attachments': serializer.toJson<String?>(attachments),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ExpenseTransaction copyWith(
          {String? id,
          Value<String?> trackerId = const Value.absent(),
          Value<String?> accountId = const Value.absent(),
          String? categoryId,
          Value<String?> memberId = const Value.absent(),
          double? amount,
          bool? isIncome,
          DateTime? date,
          Value<String?> note = const Value.absent(),
          Value<String?> attachments = const Value.absent(),
          DateTime? createdAt}) =>
      ExpenseTransaction(
        id: id ?? this.id,
        trackerId: trackerId.present ? trackerId.value : this.trackerId,
        accountId: accountId.present ? accountId.value : this.accountId,
        categoryId: categoryId ?? this.categoryId,
        memberId: memberId.present ? memberId.value : this.memberId,
        amount: amount ?? this.amount,
        isIncome: isIncome ?? this.isIncome,
        date: date ?? this.date,
        note: note.present ? note.value : this.note,
        attachments: attachments.present ? attachments.value : this.attachments,
        createdAt: createdAt ?? this.createdAt,
      );
  ExpenseTransaction copyWithCompanion(ExpenseTransactionsCompanion data) {
    return ExpenseTransaction(
      id: data.id.present ? data.id.value : this.id,
      trackerId: data.trackerId.present ? data.trackerId.value : this.trackerId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      amount: data.amount.present ? data.amount.value : this.amount,
      isIncome: data.isIncome.present ? data.isIncome.value : this.isIncome,
      date: data.date.present ? data.date.value : this.date,
      note: data.note.present ? data.note.value : this.note,
      attachments:
          data.attachments.present ? data.attachments.value : this.attachments,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseTransaction(')
          ..write('id: $id, ')
          ..write('trackerId: $trackerId, ')
          ..write('accountId: $accountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('memberId: $memberId, ')
          ..write('amount: $amount, ')
          ..write('isIncome: $isIncome, ')
          ..write('date: $date, ')
          ..write('note: $note, ')
          ..write('attachments: $attachments, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, trackerId, accountId, categoryId,
      memberId, amount, isIncome, date, note, attachments, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseTransaction &&
          other.id == this.id &&
          other.trackerId == this.trackerId &&
          other.accountId == this.accountId &&
          other.categoryId == this.categoryId &&
          other.memberId == this.memberId &&
          other.amount == this.amount &&
          other.isIncome == this.isIncome &&
          other.date == this.date &&
          other.note == this.note &&
          other.attachments == this.attachments &&
          other.createdAt == this.createdAt);
}

class ExpenseTransactionsCompanion extends UpdateCompanion<ExpenseTransaction> {
  final Value<String> id;
  final Value<String?> trackerId;
  final Value<String?> accountId;
  final Value<String> categoryId;
  final Value<String?> memberId;
  final Value<double> amount;
  final Value<bool> isIncome;
  final Value<DateTime> date;
  final Value<String?> note;
  final Value<String?> attachments;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ExpenseTransactionsCompanion({
    this.id = const Value.absent(),
    this.trackerId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.memberId = const Value.absent(),
    this.amount = const Value.absent(),
    this.isIncome = const Value.absent(),
    this.date = const Value.absent(),
    this.note = const Value.absent(),
    this.attachments = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExpenseTransactionsCompanion.insert({
    this.id = const Value.absent(),
    this.trackerId = const Value.absent(),
    this.accountId = const Value.absent(),
    required String categoryId,
    this.memberId = const Value.absent(),
    required double amount,
    this.isIncome = const Value.absent(),
    required DateTime date,
    this.note = const Value.absent(),
    this.attachments = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : categoryId = Value(categoryId),
        amount = Value(amount),
        date = Value(date);
  static Insertable<ExpenseTransaction> custom({
    Expression<String>? id,
    Expression<String>? trackerId,
    Expression<String>? accountId,
    Expression<String>? categoryId,
    Expression<String>? memberId,
    Expression<double>? amount,
    Expression<bool>? isIncome,
    Expression<DateTime>? date,
    Expression<String>? note,
    Expression<String>? attachments,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (trackerId != null) 'tracker_id': trackerId,
      if (accountId != null) 'account_id': accountId,
      if (categoryId != null) 'category_id': categoryId,
      if (memberId != null) 'member_id': memberId,
      if (amount != null) 'amount': amount,
      if (isIncome != null) 'is_income': isIncome,
      if (date != null) 'date': date,
      if (note != null) 'note': note,
      if (attachments != null) 'attachments': attachments,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExpenseTransactionsCompanion copyWith(
      {Value<String>? id,
      Value<String?>? trackerId,
      Value<String?>? accountId,
      Value<String>? categoryId,
      Value<String?>? memberId,
      Value<double>? amount,
      Value<bool>? isIncome,
      Value<DateTime>? date,
      Value<String?>? note,
      Value<String?>? attachments,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return ExpenseTransactionsCompanion(
      id: id ?? this.id,
      trackerId: trackerId ?? this.trackerId,
      accountId: accountId ?? this.accountId,
      categoryId: categoryId ?? this.categoryId,
      memberId: memberId ?? this.memberId,
      amount: amount ?? this.amount,
      isIncome: isIncome ?? this.isIncome,
      date: date ?? this.date,
      note: note ?? this.note,
      attachments: attachments ?? this.attachments,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (trackerId.present) {
      map['tracker_id'] = Variable<String>(trackerId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<String>(memberId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (isIncome.present) {
      map['is_income'] = Variable<bool>(isIncome.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (attachments.present) {
      map['attachments'] = Variable<String>(attachments.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseTransactionsCompanion(')
          ..write('id: $id, ')
          ..write('trackerId: $trackerId, ')
          ..write('accountId: $accountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('memberId: $memberId, ')
          ..write('amount: $amount, ')
          ..write('isIncome: $isIncome, ')
          ..write('date: $date, ')
          ..write('note: $note, ')
          ..write('attachments: $attachments, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$ExpenseDatabase extends GeneratedDatabase {
  _$ExpenseDatabase(QueryExecutor e) : super(e);
  $ExpenseDatabaseManager get managers => $ExpenseDatabaseManager(this);
  late final $ExpenseTrackersTable expenseTrackers =
      $ExpenseTrackersTable(this);
  late final $ExpenseMembersTable expenseMembers = $ExpenseMembersTable(this);
  late final $ExpenseAccountsTable expenseAccounts =
      $ExpenseAccountsTable(this);
  late final $ExpenseCategoriesTable expenseCategories =
      $ExpenseCategoriesTable(this);
  late final $ExpenseSubscriptionsTable expenseSubscriptions =
      $ExpenseSubscriptionsTable(this);
  late final $ExpenseInstallmentsTable expenseInstallments =
      $ExpenseInstallmentsTable(this);
  late final $ExpenseTransactionsTable expenseTransactions =
      $ExpenseTransactionsTable(this);
  late final ExpenseDao expenseDao = ExpenseDao(this as ExpenseDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        expenseTrackers,
        expenseMembers,
        expenseAccounts,
        expenseCategories,
        expenseSubscriptions,
        expenseInstallments,
        expenseTransactions
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('expense_trackers',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('expense_members', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('expense_trackers',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('expense_subscriptions', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('expense_accounts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('expense_subscriptions', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('expense_trackers',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('expense_installments', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('expense_accounts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('expense_installments', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('expense_trackers',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('expense_transactions', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('expense_accounts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('expense_transactions', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('expense_categories',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('expense_transactions', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('expense_members',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('expense_transactions', kind: UpdateKind.update),
            ],
          ),
        ],
      );
}

typedef $$ExpenseTrackersTableCreateCompanionBuilder = ExpenseTrackersCompanion
    Function({
  Value<String> id,
  required String name,
  Value<double?> budget,
  Value<String> cycleType,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$ExpenseTrackersTableUpdateCompanionBuilder = ExpenseTrackersCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<double?> budget,
  Value<String> cycleType,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$ExpenseTrackersTableReferences extends BaseReferences<
    _$ExpenseDatabase, $ExpenseTrackersTable, ExpenseTracker> {
  $$ExpenseTrackersTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ExpenseMembersTable, List<ExpenseMember>>
      _expenseMembersRefsTable(_$ExpenseDatabase db) =>
          MultiTypedResultKey.fromTable(db.expenseMembers,
              aliasName: $_aliasNameGenerator(
                  db.expenseTrackers.id, db.expenseMembers.trackerId));

  $$ExpenseMembersTableProcessedTableManager get expenseMembersRefs {
    final manager = $$ExpenseMembersTableTableManager($_db, $_db.expenseMembers)
        .filter((f) => f.trackerId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_expenseMembersRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ExpenseSubscriptionsTable,
      List<ExpenseSubscription>> _expenseSubscriptionsRefsTable(
          _$ExpenseDatabase db) =>
      MultiTypedResultKey.fromTable(db.expenseSubscriptions,
          aliasName: $_aliasNameGenerator(
              db.expenseTrackers.id, db.expenseSubscriptions.trackerId));

  $$ExpenseSubscriptionsTableProcessedTableManager
      get expenseSubscriptionsRefs {
    final manager = $$ExpenseSubscriptionsTableTableManager(
            $_db, $_db.expenseSubscriptions)
        .filter((f) => f.trackerId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_expenseSubscriptionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ExpenseInstallmentsTable,
      List<ExpenseInstallment>> _expenseInstallmentsRefsTable(
          _$ExpenseDatabase db) =>
      MultiTypedResultKey.fromTable(db.expenseInstallments,
          aliasName: $_aliasNameGenerator(
              db.expenseTrackers.id, db.expenseInstallments.trackerId));

  $$ExpenseInstallmentsTableProcessedTableManager get expenseInstallmentsRefs {
    final manager = $$ExpenseInstallmentsTableTableManager(
            $_db, $_db.expenseInstallments)
        .filter((f) => f.trackerId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_expenseInstallmentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ExpenseTransactionsTable,
      List<ExpenseTransaction>> _expenseTransactionsRefsTable(
          _$ExpenseDatabase db) =>
      MultiTypedResultKey.fromTable(db.expenseTransactions,
          aliasName: $_aliasNameGenerator(
              db.expenseTrackers.id, db.expenseTransactions.trackerId));

  $$ExpenseTransactionsTableProcessedTableManager get expenseTransactionsRefs {
    final manager = $$ExpenseTransactionsTableTableManager(
            $_db, $_db.expenseTransactions)
        .filter((f) => f.trackerId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_expenseTransactionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ExpenseTrackersTableFilterComposer
    extends Composer<_$ExpenseDatabase, $ExpenseTrackersTable> {
  $$ExpenseTrackersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get budget => $composableBuilder(
      column: $table.budget, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get cycleType => $composableBuilder(
      column: $table.cycleType, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> expenseMembersRefs(
      Expression<bool> Function($$ExpenseMembersTableFilterComposer f) f) {
    final $$ExpenseMembersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.expenseMembers,
        getReferencedColumn: (t) => t.trackerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpenseMembersTableFilterComposer(
              $db: $db,
              $table: $db.expenseMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> expenseSubscriptionsRefs(
      Expression<bool> Function($$ExpenseSubscriptionsTableFilterComposer f)
          f) {
    final $$ExpenseSubscriptionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.expenseSubscriptions,
        getReferencedColumn: (t) => t.trackerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpenseSubscriptionsTableFilterComposer(
              $db: $db,
              $table: $db.expenseSubscriptions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> expenseInstallmentsRefs(
      Expression<bool> Function($$ExpenseInstallmentsTableFilterComposer f) f) {
    final $$ExpenseInstallmentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.expenseInstallments,
        getReferencedColumn: (t) => t.trackerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpenseInstallmentsTableFilterComposer(
              $db: $db,
              $table: $db.expenseInstallments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> expenseTransactionsRefs(
      Expression<bool> Function($$ExpenseTransactionsTableFilterComposer f) f) {
    final $$ExpenseTransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.expenseTransactions,
        getReferencedColumn: (t) => t.trackerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpenseTransactionsTableFilterComposer(
              $db: $db,
              $table: $db.expenseTransactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ExpenseTrackersTableOrderingComposer
    extends Composer<_$ExpenseDatabase, $ExpenseTrackersTable> {
  $$ExpenseTrackersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get budget => $composableBuilder(
      column: $table.budget, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get cycleType => $composableBuilder(
      column: $table.cycleType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ExpenseTrackersTableAnnotationComposer
    extends Composer<_$ExpenseDatabase, $ExpenseTrackersTable> {
  $$ExpenseTrackersTableAnnotationComposer({
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

  GeneratedColumn<double> get budget =>
      $composableBuilder(column: $table.budget, builder: (column) => column);

  GeneratedColumn<String> get cycleType =>
      $composableBuilder(column: $table.cycleType, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> expenseMembersRefs<T extends Object>(
      Expression<T> Function($$ExpenseMembersTableAnnotationComposer a) f) {
    final $$ExpenseMembersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.expenseMembers,
        getReferencedColumn: (t) => t.trackerId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpenseMembersTableAnnotationComposer(
              $db: $db,
              $table: $db.expenseMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> expenseSubscriptionsRefs<T extends Object>(
      Expression<T> Function($$ExpenseSubscriptionsTableAnnotationComposer a)
          f) {
    final $$ExpenseSubscriptionsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.expenseSubscriptions,
            getReferencedColumn: (t) => t.trackerId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ExpenseSubscriptionsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.expenseSubscriptions,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> expenseInstallmentsRefs<T extends Object>(
      Expression<T> Function($$ExpenseInstallmentsTableAnnotationComposer a)
          f) {
    final $$ExpenseInstallmentsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.expenseInstallments,
            getReferencedColumn: (t) => t.trackerId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ExpenseInstallmentsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.expenseInstallments,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> expenseTransactionsRefs<T extends Object>(
      Expression<T> Function($$ExpenseTransactionsTableAnnotationComposer a)
          f) {
    final $$ExpenseTransactionsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.expenseTransactions,
            getReferencedColumn: (t) => t.trackerId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ExpenseTransactionsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.expenseTransactions,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$ExpenseTrackersTableTableManager extends RootTableManager<
    _$ExpenseDatabase,
    $ExpenseTrackersTable,
    ExpenseTracker,
    $$ExpenseTrackersTableFilterComposer,
    $$ExpenseTrackersTableOrderingComposer,
    $$ExpenseTrackersTableAnnotationComposer,
    $$ExpenseTrackersTableCreateCompanionBuilder,
    $$ExpenseTrackersTableUpdateCompanionBuilder,
    (ExpenseTracker, $$ExpenseTrackersTableReferences),
    ExpenseTracker,
    PrefetchHooks Function(
        {bool expenseMembersRefs,
        bool expenseSubscriptionsRefs,
        bool expenseInstallmentsRefs,
        bool expenseTransactionsRefs})> {
  $$ExpenseTrackersTableTableManager(
      _$ExpenseDatabase db, $ExpenseTrackersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpenseTrackersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpenseTrackersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpenseTrackersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double?> budget = const Value.absent(),
            Value<String> cycleType = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExpenseTrackersCompanion(
            id: id,
            name: name,
            budget: budget,
            cycleType: cycleType,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String name,
            Value<double?> budget = const Value.absent(),
            Value<String> cycleType = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExpenseTrackersCompanion.insert(
            id: id,
            name: name,
            budget: budget,
            cycleType: cycleType,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ExpenseTrackersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {expenseMembersRefs = false,
              expenseSubscriptionsRefs = false,
              expenseInstallmentsRefs = false,
              expenseTransactionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (expenseMembersRefs) db.expenseMembers,
                if (expenseSubscriptionsRefs) db.expenseSubscriptions,
                if (expenseInstallmentsRefs) db.expenseInstallments,
                if (expenseTransactionsRefs) db.expenseTransactions
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (expenseMembersRefs)
                    await $_getPrefetchedData<ExpenseTracker,
                            $ExpenseTrackersTable, ExpenseMember>(
                        currentTable: table,
                        referencedTable: $$ExpenseTrackersTableReferences
                            ._expenseMembersRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ExpenseTrackersTableReferences(db, table, p0)
                                .expenseMembersRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.trackerId == item.id),
                        typedResults: items),
                  if (expenseSubscriptionsRefs)
                    await $_getPrefetchedData<ExpenseTracker,
                            $ExpenseTrackersTable, ExpenseSubscription>(
                        currentTable: table,
                        referencedTable: $$ExpenseTrackersTableReferences
                            ._expenseSubscriptionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ExpenseTrackersTableReferences(db, table, p0)
                                .expenseSubscriptionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.trackerId == item.id),
                        typedResults: items),
                  if (expenseInstallmentsRefs)
                    await $_getPrefetchedData<ExpenseTracker,
                            $ExpenseTrackersTable, ExpenseInstallment>(
                        currentTable: table,
                        referencedTable: $$ExpenseTrackersTableReferences
                            ._expenseInstallmentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ExpenseTrackersTableReferences(db, table, p0)
                                .expenseInstallmentsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.trackerId == item.id),
                        typedResults: items),
                  if (expenseTransactionsRefs)
                    await $_getPrefetchedData<ExpenseTracker,
                            $ExpenseTrackersTable, ExpenseTransaction>(
                        currentTable: table,
                        referencedTable: $$ExpenseTrackersTableReferences
                            ._expenseTransactionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ExpenseTrackersTableReferences(db, table, p0)
                                .expenseTransactionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.trackerId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ExpenseTrackersTableProcessedTableManager = ProcessedTableManager<
    _$ExpenseDatabase,
    $ExpenseTrackersTable,
    ExpenseTracker,
    $$ExpenseTrackersTableFilterComposer,
    $$ExpenseTrackersTableOrderingComposer,
    $$ExpenseTrackersTableAnnotationComposer,
    $$ExpenseTrackersTableCreateCompanionBuilder,
    $$ExpenseTrackersTableUpdateCompanionBuilder,
    (ExpenseTracker, $$ExpenseTrackersTableReferences),
    ExpenseTracker,
    PrefetchHooks Function(
        {bool expenseMembersRefs,
        bool expenseSubscriptionsRefs,
        bool expenseInstallmentsRefs,
        bool expenseTransactionsRefs})>;
typedef $$ExpenseMembersTableCreateCompanionBuilder = ExpenseMembersCompanion
    Function({
  Value<String> id,
  required String trackerId,
  required String name,
  Value<String?> avatarPath,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$ExpenseMembersTableUpdateCompanionBuilder = ExpenseMembersCompanion
    Function({
  Value<String> id,
  Value<String> trackerId,
  Value<String> name,
  Value<String?> avatarPath,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$ExpenseMembersTableReferences extends BaseReferences<
    _$ExpenseDatabase, $ExpenseMembersTable, ExpenseMember> {
  $$ExpenseMembersTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ExpenseTrackersTable _trackerIdTable(_$ExpenseDatabase db) =>
      db.expenseTrackers.createAlias($_aliasNameGenerator(
          db.expenseMembers.trackerId, db.expenseTrackers.id));

  $$ExpenseTrackersTableProcessedTableManager get trackerId {
    final $_column = $_itemColumn<String>('tracker_id')!;

    final manager =
        $$ExpenseTrackersTableTableManager($_db, $_db.expenseTrackers)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_trackerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$ExpenseTransactionsTable,
      List<ExpenseTransaction>> _expenseTransactionsRefsTable(
          _$ExpenseDatabase db) =>
      MultiTypedResultKey.fromTable(db.expenseTransactions,
          aliasName: $_aliasNameGenerator(
              db.expenseMembers.id, db.expenseTransactions.memberId));

  $$ExpenseTransactionsTableProcessedTableManager get expenseTransactionsRefs {
    final manager = $$ExpenseTransactionsTableTableManager(
            $_db, $_db.expenseTransactions)
        .filter((f) => f.memberId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_expenseTransactionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ExpenseMembersTableFilterComposer
    extends Composer<_$ExpenseDatabase, $ExpenseMembersTable> {
  $$ExpenseMembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get avatarPath => $composableBuilder(
      column: $table.avatarPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$ExpenseTrackersTableFilterComposer get trackerId {
    final $$ExpenseTrackersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.trackerId,
        referencedTable: $db.expenseTrackers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpenseTrackersTableFilterComposer(
              $db: $db,
              $table: $db.expenseTrackers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> expenseTransactionsRefs(
      Expression<bool> Function($$ExpenseTransactionsTableFilterComposer f) f) {
    final $$ExpenseTransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.expenseTransactions,
        getReferencedColumn: (t) => t.memberId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpenseTransactionsTableFilterComposer(
              $db: $db,
              $table: $db.expenseTransactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ExpenseMembersTableOrderingComposer
    extends Composer<_$ExpenseDatabase, $ExpenseMembersTable> {
  $$ExpenseMembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get avatarPath => $composableBuilder(
      column: $table.avatarPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$ExpenseTrackersTableOrderingComposer get trackerId {
    final $$ExpenseTrackersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.trackerId,
        referencedTable: $db.expenseTrackers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpenseTrackersTableOrderingComposer(
              $db: $db,
              $table: $db.expenseTrackers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExpenseMembersTableAnnotationComposer
    extends Composer<_$ExpenseDatabase, $ExpenseMembersTable> {
  $$ExpenseMembersTableAnnotationComposer({
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

  GeneratedColumn<String> get avatarPath => $composableBuilder(
      column: $table.avatarPath, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ExpenseTrackersTableAnnotationComposer get trackerId {
    final $$ExpenseTrackersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.trackerId,
        referencedTable: $db.expenseTrackers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpenseTrackersTableAnnotationComposer(
              $db: $db,
              $table: $db.expenseTrackers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> expenseTransactionsRefs<T extends Object>(
      Expression<T> Function($$ExpenseTransactionsTableAnnotationComposer a)
          f) {
    final $$ExpenseTransactionsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.expenseTransactions,
            getReferencedColumn: (t) => t.memberId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ExpenseTransactionsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.expenseTransactions,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$ExpenseMembersTableTableManager extends RootTableManager<
    _$ExpenseDatabase,
    $ExpenseMembersTable,
    ExpenseMember,
    $$ExpenseMembersTableFilterComposer,
    $$ExpenseMembersTableOrderingComposer,
    $$ExpenseMembersTableAnnotationComposer,
    $$ExpenseMembersTableCreateCompanionBuilder,
    $$ExpenseMembersTableUpdateCompanionBuilder,
    (ExpenseMember, $$ExpenseMembersTableReferences),
    ExpenseMember,
    PrefetchHooks Function({bool trackerId, bool expenseTransactionsRefs})> {
  $$ExpenseMembersTableTableManager(
      _$ExpenseDatabase db, $ExpenseMembersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpenseMembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpenseMembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpenseMembersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> trackerId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> avatarPath = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExpenseMembersCompanion(
            id: id,
            trackerId: trackerId,
            name: name,
            avatarPath: avatarPath,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String trackerId,
            required String name,
            Value<String?> avatarPath = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExpenseMembersCompanion.insert(
            id: id,
            trackerId: trackerId,
            name: name,
            avatarPath: avatarPath,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ExpenseMembersTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {trackerId = false, expenseTransactionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (expenseTransactionsRefs) db.expenseTransactions
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (trackerId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.trackerId,
                    referencedTable:
                        $$ExpenseMembersTableReferences._trackerIdTable(db),
                    referencedColumn:
                        $$ExpenseMembersTableReferences._trackerIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (expenseTransactionsRefs)
                    await $_getPrefetchedData<ExpenseMember,
                            $ExpenseMembersTable, ExpenseTransaction>(
                        currentTable: table,
                        referencedTable: $$ExpenseMembersTableReferences
                            ._expenseTransactionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ExpenseMembersTableReferences(db, table, p0)
                                .expenseTransactionsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.memberId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ExpenseMembersTableProcessedTableManager = ProcessedTableManager<
    _$ExpenseDatabase,
    $ExpenseMembersTable,
    ExpenseMember,
    $$ExpenseMembersTableFilterComposer,
    $$ExpenseMembersTableOrderingComposer,
    $$ExpenseMembersTableAnnotationComposer,
    $$ExpenseMembersTableCreateCompanionBuilder,
    $$ExpenseMembersTableUpdateCompanionBuilder,
    (ExpenseMember, $$ExpenseMembersTableReferences),
    ExpenseMember,
    PrefetchHooks Function({bool trackerId, bool expenseTransactionsRefs})>;
typedef $$ExpenseAccountsTableCreateCompanionBuilder = ExpenseAccountsCompanion
    Function({
  Value<String> id,
  required String name,
  Value<String> icon,
  Value<double> initialBalance,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$ExpenseAccountsTableUpdateCompanionBuilder = ExpenseAccountsCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String> icon,
  Value<double> initialBalance,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$ExpenseAccountsTableReferences extends BaseReferences<
    _$ExpenseDatabase, $ExpenseAccountsTable, ExpenseAccount> {
  $$ExpenseAccountsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ExpenseSubscriptionsTable,
      List<ExpenseSubscription>> _expenseSubscriptionsRefsTable(
          _$ExpenseDatabase db) =>
      MultiTypedResultKey.fromTable(db.expenseSubscriptions,
          aliasName: $_aliasNameGenerator(
              db.expenseAccounts.id, db.expenseSubscriptions.accountId));

  $$ExpenseSubscriptionsTableProcessedTableManager
      get expenseSubscriptionsRefs {
    final manager = $$ExpenseSubscriptionsTableTableManager(
            $_db, $_db.expenseSubscriptions)
        .filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_expenseSubscriptionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ExpenseInstallmentsTable,
      List<ExpenseInstallment>> _expenseInstallmentsRefsTable(
          _$ExpenseDatabase db) =>
      MultiTypedResultKey.fromTable(db.expenseInstallments,
          aliasName: $_aliasNameGenerator(
              db.expenseAccounts.id, db.expenseInstallments.accountId));

  $$ExpenseInstallmentsTableProcessedTableManager get expenseInstallmentsRefs {
    final manager = $$ExpenseInstallmentsTableTableManager(
            $_db, $_db.expenseInstallments)
        .filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_expenseInstallmentsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ExpenseTransactionsTable,
      List<ExpenseTransaction>> _expenseTransactionsRefsTable(
          _$ExpenseDatabase db) =>
      MultiTypedResultKey.fromTable(db.expenseTransactions,
          aliasName: $_aliasNameGenerator(
              db.expenseAccounts.id, db.expenseTransactions.accountId));

  $$ExpenseTransactionsTableProcessedTableManager get expenseTransactionsRefs {
    final manager = $$ExpenseTransactionsTableTableManager(
            $_db, $_db.expenseTransactions)
        .filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_expenseTransactionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ExpenseAccountsTableFilterComposer
    extends Composer<_$ExpenseDatabase, $ExpenseAccountsTable> {
  $$ExpenseAccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get initialBalance => $composableBuilder(
      column: $table.initialBalance,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> expenseSubscriptionsRefs(
      Expression<bool> Function($$ExpenseSubscriptionsTableFilterComposer f)
          f) {
    final $$ExpenseSubscriptionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.expenseSubscriptions,
        getReferencedColumn: (t) => t.accountId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpenseSubscriptionsTableFilterComposer(
              $db: $db,
              $table: $db.expenseSubscriptions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> expenseInstallmentsRefs(
      Expression<bool> Function($$ExpenseInstallmentsTableFilterComposer f) f) {
    final $$ExpenseInstallmentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.expenseInstallments,
        getReferencedColumn: (t) => t.accountId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpenseInstallmentsTableFilterComposer(
              $db: $db,
              $table: $db.expenseInstallments,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> expenseTransactionsRefs(
      Expression<bool> Function($$ExpenseTransactionsTableFilterComposer f) f) {
    final $$ExpenseTransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.expenseTransactions,
        getReferencedColumn: (t) => t.accountId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpenseTransactionsTableFilterComposer(
              $db: $db,
              $table: $db.expenseTransactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ExpenseAccountsTableOrderingComposer
    extends Composer<_$ExpenseDatabase, $ExpenseAccountsTable> {
  $$ExpenseAccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get initialBalance => $composableBuilder(
      column: $table.initialBalance,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ExpenseAccountsTableAnnotationComposer
    extends Composer<_$ExpenseDatabase, $ExpenseAccountsTable> {
  $$ExpenseAccountsTableAnnotationComposer({
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

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<double> get initialBalance => $composableBuilder(
      column: $table.initialBalance, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> expenseSubscriptionsRefs<T extends Object>(
      Expression<T> Function($$ExpenseSubscriptionsTableAnnotationComposer a)
          f) {
    final $$ExpenseSubscriptionsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.expenseSubscriptions,
            getReferencedColumn: (t) => t.accountId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ExpenseSubscriptionsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.expenseSubscriptions,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> expenseInstallmentsRefs<T extends Object>(
      Expression<T> Function($$ExpenseInstallmentsTableAnnotationComposer a)
          f) {
    final $$ExpenseInstallmentsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.expenseInstallments,
            getReferencedColumn: (t) => t.accountId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ExpenseInstallmentsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.expenseInstallments,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }

  Expression<T> expenseTransactionsRefs<T extends Object>(
      Expression<T> Function($$ExpenseTransactionsTableAnnotationComposer a)
          f) {
    final $$ExpenseTransactionsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.expenseTransactions,
            getReferencedColumn: (t) => t.accountId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ExpenseTransactionsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.expenseTransactions,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$ExpenseAccountsTableTableManager extends RootTableManager<
    _$ExpenseDatabase,
    $ExpenseAccountsTable,
    ExpenseAccount,
    $$ExpenseAccountsTableFilterComposer,
    $$ExpenseAccountsTableOrderingComposer,
    $$ExpenseAccountsTableAnnotationComposer,
    $$ExpenseAccountsTableCreateCompanionBuilder,
    $$ExpenseAccountsTableUpdateCompanionBuilder,
    (ExpenseAccount, $$ExpenseAccountsTableReferences),
    ExpenseAccount,
    PrefetchHooks Function(
        {bool expenseSubscriptionsRefs,
        bool expenseInstallmentsRefs,
        bool expenseTransactionsRefs})> {
  $$ExpenseAccountsTableTableManager(
      _$ExpenseDatabase db, $ExpenseAccountsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpenseAccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpenseAccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpenseAccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> icon = const Value.absent(),
            Value<double> initialBalance = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExpenseAccountsCompanion(
            id: id,
            name: name,
            icon: icon,
            initialBalance: initialBalance,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String name,
            Value<String> icon = const Value.absent(),
            Value<double> initialBalance = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExpenseAccountsCompanion.insert(
            id: id,
            name: name,
            icon: icon,
            initialBalance: initialBalance,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ExpenseAccountsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {expenseSubscriptionsRefs = false,
              expenseInstallmentsRefs = false,
              expenseTransactionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (expenseSubscriptionsRefs) db.expenseSubscriptions,
                if (expenseInstallmentsRefs) db.expenseInstallments,
                if (expenseTransactionsRefs) db.expenseTransactions
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (expenseSubscriptionsRefs)
                    await $_getPrefetchedData<ExpenseAccount,
                            $ExpenseAccountsTable, ExpenseSubscription>(
                        currentTable: table,
                        referencedTable: $$ExpenseAccountsTableReferences
                            ._expenseSubscriptionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ExpenseAccountsTableReferences(db, table, p0)
                                .expenseSubscriptionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.accountId == item.id),
                        typedResults: items),
                  if (expenseInstallmentsRefs)
                    await $_getPrefetchedData<ExpenseAccount,
                            $ExpenseAccountsTable, ExpenseInstallment>(
                        currentTable: table,
                        referencedTable: $$ExpenseAccountsTableReferences
                            ._expenseInstallmentsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ExpenseAccountsTableReferences(db, table, p0)
                                .expenseInstallmentsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.accountId == item.id),
                        typedResults: items),
                  if (expenseTransactionsRefs)
                    await $_getPrefetchedData<ExpenseAccount,
                            $ExpenseAccountsTable, ExpenseTransaction>(
                        currentTable: table,
                        referencedTable: $$ExpenseAccountsTableReferences
                            ._expenseTransactionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ExpenseAccountsTableReferences(db, table, p0)
                                .expenseTransactionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.accountId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ExpenseAccountsTableProcessedTableManager = ProcessedTableManager<
    _$ExpenseDatabase,
    $ExpenseAccountsTable,
    ExpenseAccount,
    $$ExpenseAccountsTableFilterComposer,
    $$ExpenseAccountsTableOrderingComposer,
    $$ExpenseAccountsTableAnnotationComposer,
    $$ExpenseAccountsTableCreateCompanionBuilder,
    $$ExpenseAccountsTableUpdateCompanionBuilder,
    (ExpenseAccount, $$ExpenseAccountsTableReferences),
    ExpenseAccount,
    PrefetchHooks Function(
        {bool expenseSubscriptionsRefs,
        bool expenseInstallmentsRefs,
        bool expenseTransactionsRefs})>;
typedef $$ExpenseCategoriesTableCreateCompanionBuilder
    = ExpenseCategoriesCompanion Function({
  Value<String> id,
  required String name,
  required String icon,
  required String colorHex,
  Value<bool> isIncome,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$ExpenseCategoriesTableUpdateCompanionBuilder
    = ExpenseCategoriesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> icon,
  Value<String> colorHex,
  Value<bool> isIncome,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$ExpenseCategoriesTableReferences extends BaseReferences<
    _$ExpenseDatabase, $ExpenseCategoriesTable, ExpenseCategory> {
  $$ExpenseCategoriesTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ExpenseTransactionsTable,
      List<ExpenseTransaction>> _expenseTransactionsRefsTable(
          _$ExpenseDatabase db) =>
      MultiTypedResultKey.fromTable(db.expenseTransactions,
          aliasName: $_aliasNameGenerator(
              db.expenseCategories.id, db.expenseTransactions.categoryId));

  $$ExpenseTransactionsTableProcessedTableManager get expenseTransactionsRefs {
    final manager = $$ExpenseTransactionsTableTableManager(
            $_db, $_db.expenseTransactions)
        .filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_expenseTransactionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ExpenseCategoriesTableFilterComposer
    extends Composer<_$ExpenseDatabase, $ExpenseCategoriesTable> {
  $$ExpenseCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get colorHex => $composableBuilder(
      column: $table.colorHex, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isIncome => $composableBuilder(
      column: $table.isIncome, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> expenseTransactionsRefs(
      Expression<bool> Function($$ExpenseTransactionsTableFilterComposer f) f) {
    final $$ExpenseTransactionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.expenseTransactions,
        getReferencedColumn: (t) => t.categoryId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpenseTransactionsTableFilterComposer(
              $db: $db,
              $table: $db.expenseTransactions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ExpenseCategoriesTableOrderingComposer
    extends Composer<_$ExpenseDatabase, $ExpenseCategoriesTable> {
  $$ExpenseCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get icon => $composableBuilder(
      column: $table.icon, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get colorHex => $composableBuilder(
      column: $table.colorHex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isIncome => $composableBuilder(
      column: $table.isIncome, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ExpenseCategoriesTableAnnotationComposer
    extends Composer<_$ExpenseDatabase, $ExpenseCategoriesTable> {
  $$ExpenseCategoriesTableAnnotationComposer({
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

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<bool> get isIncome =>
      $composableBuilder(column: $table.isIncome, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> expenseTransactionsRefs<T extends Object>(
      Expression<T> Function($$ExpenseTransactionsTableAnnotationComposer a)
          f) {
    final $$ExpenseTransactionsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.expenseTransactions,
            getReferencedColumn: (t) => t.categoryId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ExpenseTransactionsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.expenseTransactions,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$ExpenseCategoriesTableTableManager extends RootTableManager<
    _$ExpenseDatabase,
    $ExpenseCategoriesTable,
    ExpenseCategory,
    $$ExpenseCategoriesTableFilterComposer,
    $$ExpenseCategoriesTableOrderingComposer,
    $$ExpenseCategoriesTableAnnotationComposer,
    $$ExpenseCategoriesTableCreateCompanionBuilder,
    $$ExpenseCategoriesTableUpdateCompanionBuilder,
    (ExpenseCategory, $$ExpenseCategoriesTableReferences),
    ExpenseCategory,
    PrefetchHooks Function({bool expenseTransactionsRefs})> {
  $$ExpenseCategoriesTableTableManager(
      _$ExpenseDatabase db, $ExpenseCategoriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpenseCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpenseCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpenseCategoriesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> icon = const Value.absent(),
            Value<String> colorHex = const Value.absent(),
            Value<bool> isIncome = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExpenseCategoriesCompanion(
            id: id,
            name: name,
            icon: icon,
            colorHex: colorHex,
            isIncome: isIncome,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String name,
            required String icon,
            required String colorHex,
            Value<bool> isIncome = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExpenseCategoriesCompanion.insert(
            id: id,
            name: name,
            icon: icon,
            colorHex: colorHex,
            isIncome: isIncome,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ExpenseCategoriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({expenseTransactionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (expenseTransactionsRefs) db.expenseTransactions
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (expenseTransactionsRefs)
                    await $_getPrefetchedData<ExpenseCategory,
                            $ExpenseCategoriesTable, ExpenseTransaction>(
                        currentTable: table,
                        referencedTable: $$ExpenseCategoriesTableReferences
                            ._expenseTransactionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ExpenseCategoriesTableReferences(db, table, p0)
                                .expenseTransactionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.categoryId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ExpenseCategoriesTableProcessedTableManager = ProcessedTableManager<
    _$ExpenseDatabase,
    $ExpenseCategoriesTable,
    ExpenseCategory,
    $$ExpenseCategoriesTableFilterComposer,
    $$ExpenseCategoriesTableOrderingComposer,
    $$ExpenseCategoriesTableAnnotationComposer,
    $$ExpenseCategoriesTableCreateCompanionBuilder,
    $$ExpenseCategoriesTableUpdateCompanionBuilder,
    (ExpenseCategory, $$ExpenseCategoriesTableReferences),
    ExpenseCategory,
    PrefetchHooks Function({bool expenseTransactionsRefs})>;
typedef $$ExpenseSubscriptionsTableCreateCompanionBuilder
    = ExpenseSubscriptionsCompanion Function({
  Value<String> id,
  required String trackerId,
  Value<String?> accountId,
  required String name,
  required double amount,
  required DateTime startDate,
  Value<DateTime?> endDate,
  Value<String> interval,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$ExpenseSubscriptionsTableUpdateCompanionBuilder
    = ExpenseSubscriptionsCompanion Function({
  Value<String> id,
  Value<String> trackerId,
  Value<String?> accountId,
  Value<String> name,
  Value<double> amount,
  Value<DateTime> startDate,
  Value<DateTime?> endDate,
  Value<String> interval,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$ExpenseSubscriptionsTableReferences extends BaseReferences<
    _$ExpenseDatabase, $ExpenseSubscriptionsTable, ExpenseSubscription> {
  $$ExpenseSubscriptionsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ExpenseTrackersTable _trackerIdTable(_$ExpenseDatabase db) =>
      db.expenseTrackers.createAlias($_aliasNameGenerator(
          db.expenseSubscriptions.trackerId, db.expenseTrackers.id));

  $$ExpenseTrackersTableProcessedTableManager get trackerId {
    final $_column = $_itemColumn<String>('tracker_id')!;

    final manager =
        $$ExpenseTrackersTableTableManager($_db, $_db.expenseTrackers)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_trackerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ExpenseAccountsTable _accountIdTable(_$ExpenseDatabase db) =>
      db.expenseAccounts.createAlias($_aliasNameGenerator(
          db.expenseSubscriptions.accountId, db.expenseAccounts.id));

  $$ExpenseAccountsTableProcessedTableManager? get accountId {
    final $_column = $_itemColumn<String>('account_id');
    if ($_column == null) return null;
    final manager =
        $$ExpenseAccountsTableTableManager($_db, $_db.expenseAccounts)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ExpenseSubscriptionsTableFilterComposer
    extends Composer<_$ExpenseDatabase, $ExpenseSubscriptionsTable> {
  $$ExpenseSubscriptionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get interval => $composableBuilder(
      column: $table.interval, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$ExpenseTrackersTableFilterComposer get trackerId {
    final $$ExpenseTrackersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.trackerId,
        referencedTable: $db.expenseTrackers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpenseTrackersTableFilterComposer(
              $db: $db,
              $table: $db.expenseTrackers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ExpenseAccountsTableFilterComposer get accountId {
    final $$ExpenseAccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $db.expenseAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpenseAccountsTableFilterComposer(
              $db: $db,
              $table: $db.expenseAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExpenseSubscriptionsTableOrderingComposer
    extends Composer<_$ExpenseDatabase, $ExpenseSubscriptionsTable> {
  $$ExpenseSubscriptionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
      column: $table.endDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get interval => $composableBuilder(
      column: $table.interval, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$ExpenseTrackersTableOrderingComposer get trackerId {
    final $$ExpenseTrackersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.trackerId,
        referencedTable: $db.expenseTrackers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpenseTrackersTableOrderingComposer(
              $db: $db,
              $table: $db.expenseTrackers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ExpenseAccountsTableOrderingComposer get accountId {
    final $$ExpenseAccountsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $db.expenseAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpenseAccountsTableOrderingComposer(
              $db: $db,
              $table: $db.expenseAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExpenseSubscriptionsTableAnnotationComposer
    extends Composer<_$ExpenseDatabase, $ExpenseSubscriptionsTable> {
  $$ExpenseSubscriptionsTableAnnotationComposer({
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

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<String> get interval =>
      $composableBuilder(column: $table.interval, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ExpenseTrackersTableAnnotationComposer get trackerId {
    final $$ExpenseTrackersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.trackerId,
        referencedTable: $db.expenseTrackers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpenseTrackersTableAnnotationComposer(
              $db: $db,
              $table: $db.expenseTrackers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ExpenseAccountsTableAnnotationComposer get accountId {
    final $$ExpenseAccountsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $db.expenseAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpenseAccountsTableAnnotationComposer(
              $db: $db,
              $table: $db.expenseAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExpenseSubscriptionsTableTableManager extends RootTableManager<
    _$ExpenseDatabase,
    $ExpenseSubscriptionsTable,
    ExpenseSubscription,
    $$ExpenseSubscriptionsTableFilterComposer,
    $$ExpenseSubscriptionsTableOrderingComposer,
    $$ExpenseSubscriptionsTableAnnotationComposer,
    $$ExpenseSubscriptionsTableCreateCompanionBuilder,
    $$ExpenseSubscriptionsTableUpdateCompanionBuilder,
    (ExpenseSubscription, $$ExpenseSubscriptionsTableReferences),
    ExpenseSubscription,
    PrefetchHooks Function({bool trackerId, bool accountId})> {
  $$ExpenseSubscriptionsTableTableManager(
      _$ExpenseDatabase db, $ExpenseSubscriptionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpenseSubscriptionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpenseSubscriptionsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpenseSubscriptionsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> trackerId = const Value.absent(),
            Value<String?> accountId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<DateTime> startDate = const Value.absent(),
            Value<DateTime?> endDate = const Value.absent(),
            Value<String> interval = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExpenseSubscriptionsCompanion(
            id: id,
            trackerId: trackerId,
            accountId: accountId,
            name: name,
            amount: amount,
            startDate: startDate,
            endDate: endDate,
            interval: interval,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String trackerId,
            Value<String?> accountId = const Value.absent(),
            required String name,
            required double amount,
            required DateTime startDate,
            Value<DateTime?> endDate = const Value.absent(),
            Value<String> interval = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExpenseSubscriptionsCompanion.insert(
            id: id,
            trackerId: trackerId,
            accountId: accountId,
            name: name,
            amount: amount,
            startDate: startDate,
            endDate: endDate,
            interval: interval,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ExpenseSubscriptionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({trackerId = false, accountId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (trackerId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.trackerId,
                    referencedTable: $$ExpenseSubscriptionsTableReferences
                        ._trackerIdTable(db),
                    referencedColumn: $$ExpenseSubscriptionsTableReferences
                        ._trackerIdTable(db)
                        .id,
                  ) as T;
                }
                if (accountId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.accountId,
                    referencedTable: $$ExpenseSubscriptionsTableReferences
                        ._accountIdTable(db),
                    referencedColumn: $$ExpenseSubscriptionsTableReferences
                        ._accountIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ExpenseSubscriptionsTableProcessedTableManager
    = ProcessedTableManager<
        _$ExpenseDatabase,
        $ExpenseSubscriptionsTable,
        ExpenseSubscription,
        $$ExpenseSubscriptionsTableFilterComposer,
        $$ExpenseSubscriptionsTableOrderingComposer,
        $$ExpenseSubscriptionsTableAnnotationComposer,
        $$ExpenseSubscriptionsTableCreateCompanionBuilder,
        $$ExpenseSubscriptionsTableUpdateCompanionBuilder,
        (ExpenseSubscription, $$ExpenseSubscriptionsTableReferences),
        ExpenseSubscription,
        PrefetchHooks Function({bool trackerId, bool accountId})>;
typedef $$ExpenseInstallmentsTableCreateCompanionBuilder
    = ExpenseInstallmentsCompanion Function({
  Value<String> id,
  required String trackerId,
  Value<String?> accountId,
  required String name,
  required double totalAmount,
  required double installmentAmount,
  required DateTime startDate,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$ExpenseInstallmentsTableUpdateCompanionBuilder
    = ExpenseInstallmentsCompanion Function({
  Value<String> id,
  Value<String> trackerId,
  Value<String?> accountId,
  Value<String> name,
  Value<double> totalAmount,
  Value<double> installmentAmount,
  Value<DateTime> startDate,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$ExpenseInstallmentsTableReferences extends BaseReferences<
    _$ExpenseDatabase, $ExpenseInstallmentsTable, ExpenseInstallment> {
  $$ExpenseInstallmentsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ExpenseTrackersTable _trackerIdTable(_$ExpenseDatabase db) =>
      db.expenseTrackers.createAlias($_aliasNameGenerator(
          db.expenseInstallments.trackerId, db.expenseTrackers.id));

  $$ExpenseTrackersTableProcessedTableManager get trackerId {
    final $_column = $_itemColumn<String>('tracker_id')!;

    final manager =
        $$ExpenseTrackersTableTableManager($_db, $_db.expenseTrackers)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_trackerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ExpenseAccountsTable _accountIdTable(_$ExpenseDatabase db) =>
      db.expenseAccounts.createAlias($_aliasNameGenerator(
          db.expenseInstallments.accountId, db.expenseAccounts.id));

  $$ExpenseAccountsTableProcessedTableManager? get accountId {
    final $_column = $_itemColumn<String>('account_id');
    if ($_column == null) return null;
    final manager =
        $$ExpenseAccountsTableTableManager($_db, $_db.expenseAccounts)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ExpenseInstallmentsTableFilterComposer
    extends Composer<_$ExpenseDatabase, $ExpenseInstallmentsTable> {
  $$ExpenseInstallmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get installmentAmount => $composableBuilder(
      column: $table.installmentAmount,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$ExpenseTrackersTableFilterComposer get trackerId {
    final $$ExpenseTrackersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.trackerId,
        referencedTable: $db.expenseTrackers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpenseTrackersTableFilterComposer(
              $db: $db,
              $table: $db.expenseTrackers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ExpenseAccountsTableFilterComposer get accountId {
    final $$ExpenseAccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $db.expenseAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpenseAccountsTableFilterComposer(
              $db: $db,
              $table: $db.expenseAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExpenseInstallmentsTableOrderingComposer
    extends Composer<_$ExpenseDatabase, $ExpenseInstallmentsTable> {
  $$ExpenseInstallmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get installmentAmount => $composableBuilder(
      column: $table.installmentAmount,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
      column: $table.startDate, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$ExpenseTrackersTableOrderingComposer get trackerId {
    final $$ExpenseTrackersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.trackerId,
        referencedTable: $db.expenseTrackers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpenseTrackersTableOrderingComposer(
              $db: $db,
              $table: $db.expenseTrackers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ExpenseAccountsTableOrderingComposer get accountId {
    final $$ExpenseAccountsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $db.expenseAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpenseAccountsTableOrderingComposer(
              $db: $db,
              $table: $db.expenseAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExpenseInstallmentsTableAnnotationComposer
    extends Composer<_$ExpenseDatabase, $ExpenseInstallmentsTable> {
  $$ExpenseInstallmentsTableAnnotationComposer({
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

  GeneratedColumn<double> get totalAmount => $composableBuilder(
      column: $table.totalAmount, builder: (column) => column);

  GeneratedColumn<double> get installmentAmount => $composableBuilder(
      column: $table.installmentAmount, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ExpenseTrackersTableAnnotationComposer get trackerId {
    final $$ExpenseTrackersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.trackerId,
        referencedTable: $db.expenseTrackers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpenseTrackersTableAnnotationComposer(
              $db: $db,
              $table: $db.expenseTrackers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ExpenseAccountsTableAnnotationComposer get accountId {
    final $$ExpenseAccountsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $db.expenseAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpenseAccountsTableAnnotationComposer(
              $db: $db,
              $table: $db.expenseAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExpenseInstallmentsTableTableManager extends RootTableManager<
    _$ExpenseDatabase,
    $ExpenseInstallmentsTable,
    ExpenseInstallment,
    $$ExpenseInstallmentsTableFilterComposer,
    $$ExpenseInstallmentsTableOrderingComposer,
    $$ExpenseInstallmentsTableAnnotationComposer,
    $$ExpenseInstallmentsTableCreateCompanionBuilder,
    $$ExpenseInstallmentsTableUpdateCompanionBuilder,
    (ExpenseInstallment, $$ExpenseInstallmentsTableReferences),
    ExpenseInstallment,
    PrefetchHooks Function({bool trackerId, bool accountId})> {
  $$ExpenseInstallmentsTableTableManager(
      _$ExpenseDatabase db, $ExpenseInstallmentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpenseInstallmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpenseInstallmentsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpenseInstallmentsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> trackerId = const Value.absent(),
            Value<String?> accountId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> totalAmount = const Value.absent(),
            Value<double> installmentAmount = const Value.absent(),
            Value<DateTime> startDate = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExpenseInstallmentsCompanion(
            id: id,
            trackerId: trackerId,
            accountId: accountId,
            name: name,
            totalAmount: totalAmount,
            installmentAmount: installmentAmount,
            startDate: startDate,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String trackerId,
            Value<String?> accountId = const Value.absent(),
            required String name,
            required double totalAmount,
            required double installmentAmount,
            required DateTime startDate,
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExpenseInstallmentsCompanion.insert(
            id: id,
            trackerId: trackerId,
            accountId: accountId,
            name: name,
            totalAmount: totalAmount,
            installmentAmount: installmentAmount,
            startDate: startDate,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ExpenseInstallmentsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({trackerId = false, accountId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (trackerId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.trackerId,
                    referencedTable: $$ExpenseInstallmentsTableReferences
                        ._trackerIdTable(db),
                    referencedColumn: $$ExpenseInstallmentsTableReferences
                        ._trackerIdTable(db)
                        .id,
                  ) as T;
                }
                if (accountId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.accountId,
                    referencedTable: $$ExpenseInstallmentsTableReferences
                        ._accountIdTable(db),
                    referencedColumn: $$ExpenseInstallmentsTableReferences
                        ._accountIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ExpenseInstallmentsTableProcessedTableManager = ProcessedTableManager<
    _$ExpenseDatabase,
    $ExpenseInstallmentsTable,
    ExpenseInstallment,
    $$ExpenseInstallmentsTableFilterComposer,
    $$ExpenseInstallmentsTableOrderingComposer,
    $$ExpenseInstallmentsTableAnnotationComposer,
    $$ExpenseInstallmentsTableCreateCompanionBuilder,
    $$ExpenseInstallmentsTableUpdateCompanionBuilder,
    (ExpenseInstallment, $$ExpenseInstallmentsTableReferences),
    ExpenseInstallment,
    PrefetchHooks Function({bool trackerId, bool accountId})>;
typedef $$ExpenseTransactionsTableCreateCompanionBuilder
    = ExpenseTransactionsCompanion Function({
  Value<String> id,
  Value<String?> trackerId,
  Value<String?> accountId,
  required String categoryId,
  Value<String?> memberId,
  required double amount,
  Value<bool> isIncome,
  required DateTime date,
  Value<String?> note,
  Value<String?> attachments,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$ExpenseTransactionsTableUpdateCompanionBuilder
    = ExpenseTransactionsCompanion Function({
  Value<String> id,
  Value<String?> trackerId,
  Value<String?> accountId,
  Value<String> categoryId,
  Value<String?> memberId,
  Value<double> amount,
  Value<bool> isIncome,
  Value<DateTime> date,
  Value<String?> note,
  Value<String?> attachments,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$ExpenseTransactionsTableReferences extends BaseReferences<
    _$ExpenseDatabase, $ExpenseTransactionsTable, ExpenseTransaction> {
  $$ExpenseTransactionsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ExpenseTrackersTable _trackerIdTable(_$ExpenseDatabase db) =>
      db.expenseTrackers.createAlias($_aliasNameGenerator(
          db.expenseTransactions.trackerId, db.expenseTrackers.id));

  $$ExpenseTrackersTableProcessedTableManager? get trackerId {
    final $_column = $_itemColumn<String>('tracker_id');
    if ($_column == null) return null;
    final manager =
        $$ExpenseTrackersTableTableManager($_db, $_db.expenseTrackers)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_trackerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ExpenseAccountsTable _accountIdTable(_$ExpenseDatabase db) =>
      db.expenseAccounts.createAlias($_aliasNameGenerator(
          db.expenseTransactions.accountId, db.expenseAccounts.id));

  $$ExpenseAccountsTableProcessedTableManager? get accountId {
    final $_column = $_itemColumn<String>('account_id');
    if ($_column == null) return null;
    final manager =
        $$ExpenseAccountsTableTableManager($_db, $_db.expenseAccounts)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ExpenseCategoriesTable _categoryIdTable(_$ExpenseDatabase db) =>
      db.expenseCategories.createAlias($_aliasNameGenerator(
          db.expenseTransactions.categoryId, db.expenseCategories.id));

  $$ExpenseCategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<String>('category_id')!;

    final manager =
        $$ExpenseCategoriesTableTableManager($_db, $_db.expenseCategories)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ExpenseMembersTable _memberIdTable(_$ExpenseDatabase db) =>
      db.expenseMembers.createAlias($_aliasNameGenerator(
          db.expenseTransactions.memberId, db.expenseMembers.id));

  $$ExpenseMembersTableProcessedTableManager? get memberId {
    final $_column = $_itemColumn<String>('member_id');
    if ($_column == null) return null;
    final manager = $$ExpenseMembersTableTableManager($_db, $_db.expenseMembers)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_memberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ExpenseTransactionsTableFilterComposer
    extends Composer<_$ExpenseDatabase, $ExpenseTransactionsTable> {
  $$ExpenseTransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isIncome => $composableBuilder(
      column: $table.isIncome, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get attachments => $composableBuilder(
      column: $table.attachments, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$ExpenseTrackersTableFilterComposer get trackerId {
    final $$ExpenseTrackersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.trackerId,
        referencedTable: $db.expenseTrackers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpenseTrackersTableFilterComposer(
              $db: $db,
              $table: $db.expenseTrackers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ExpenseAccountsTableFilterComposer get accountId {
    final $$ExpenseAccountsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $db.expenseAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpenseAccountsTableFilterComposer(
              $db: $db,
              $table: $db.expenseAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ExpenseCategoriesTableFilterComposer get categoryId {
    final $$ExpenseCategoriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.expenseCategories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpenseCategoriesTableFilterComposer(
              $db: $db,
              $table: $db.expenseCategories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ExpenseMembersTableFilterComposer get memberId {
    final $$ExpenseMembersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.memberId,
        referencedTable: $db.expenseMembers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpenseMembersTableFilterComposer(
              $db: $db,
              $table: $db.expenseMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExpenseTransactionsTableOrderingComposer
    extends Composer<_$ExpenseDatabase, $ExpenseTransactionsTable> {
  $$ExpenseTransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get amount => $composableBuilder(
      column: $table.amount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isIncome => $composableBuilder(
      column: $table.isIncome, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get attachments => $composableBuilder(
      column: $table.attachments, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$ExpenseTrackersTableOrderingComposer get trackerId {
    final $$ExpenseTrackersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.trackerId,
        referencedTable: $db.expenseTrackers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpenseTrackersTableOrderingComposer(
              $db: $db,
              $table: $db.expenseTrackers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ExpenseAccountsTableOrderingComposer get accountId {
    final $$ExpenseAccountsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $db.expenseAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpenseAccountsTableOrderingComposer(
              $db: $db,
              $table: $db.expenseAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ExpenseCategoriesTableOrderingComposer get categoryId {
    final $$ExpenseCategoriesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.categoryId,
        referencedTable: $db.expenseCategories,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpenseCategoriesTableOrderingComposer(
              $db: $db,
              $table: $db.expenseCategories,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ExpenseMembersTableOrderingComposer get memberId {
    final $$ExpenseMembersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.memberId,
        referencedTable: $db.expenseMembers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpenseMembersTableOrderingComposer(
              $db: $db,
              $table: $db.expenseMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExpenseTransactionsTableAnnotationComposer
    extends Composer<_$ExpenseDatabase, $ExpenseTransactionsTable> {
  $$ExpenseTransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<bool> get isIncome =>
      $composableBuilder(column: $table.isIncome, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get attachments => $composableBuilder(
      column: $table.attachments, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ExpenseTrackersTableAnnotationComposer get trackerId {
    final $$ExpenseTrackersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.trackerId,
        referencedTable: $db.expenseTrackers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpenseTrackersTableAnnotationComposer(
              $db: $db,
              $table: $db.expenseTrackers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ExpenseAccountsTableAnnotationComposer get accountId {
    final $$ExpenseAccountsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.accountId,
        referencedTable: $db.expenseAccounts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpenseAccountsTableAnnotationComposer(
              $db: $db,
              $table: $db.expenseAccounts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ExpenseCategoriesTableAnnotationComposer get categoryId {
    final $$ExpenseCategoriesTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.categoryId,
            referencedTable: $db.expenseCategories,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ExpenseCategoriesTableAnnotationComposer(
                  $db: $db,
                  $table: $db.expenseCategories,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  $$ExpenseMembersTableAnnotationComposer get memberId {
    final $$ExpenseMembersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.memberId,
        referencedTable: $db.expenseMembers,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExpenseMembersTableAnnotationComposer(
              $db: $db,
              $table: $db.expenseMembers,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ExpenseTransactionsTableTableManager extends RootTableManager<
    _$ExpenseDatabase,
    $ExpenseTransactionsTable,
    ExpenseTransaction,
    $$ExpenseTransactionsTableFilterComposer,
    $$ExpenseTransactionsTableOrderingComposer,
    $$ExpenseTransactionsTableAnnotationComposer,
    $$ExpenseTransactionsTableCreateCompanionBuilder,
    $$ExpenseTransactionsTableUpdateCompanionBuilder,
    (ExpenseTransaction, $$ExpenseTransactionsTableReferences),
    ExpenseTransaction,
    PrefetchHooks Function(
        {bool trackerId, bool accountId, bool categoryId, bool memberId})> {
  $$ExpenseTransactionsTableTableManager(
      _$ExpenseDatabase db, $ExpenseTransactionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpenseTransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpenseTransactionsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpenseTransactionsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> trackerId = const Value.absent(),
            Value<String?> accountId = const Value.absent(),
            Value<String> categoryId = const Value.absent(),
            Value<String?> memberId = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<bool> isIncome = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<String?> attachments = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExpenseTransactionsCompanion(
            id: id,
            trackerId: trackerId,
            accountId: accountId,
            categoryId: categoryId,
            memberId: memberId,
            amount: amount,
            isIncome: isIncome,
            date: date,
            note: note,
            attachments: attachments,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> trackerId = const Value.absent(),
            Value<String?> accountId = const Value.absent(),
            required String categoryId,
            Value<String?> memberId = const Value.absent(),
            required double amount,
            Value<bool> isIncome = const Value.absent(),
            required DateTime date,
            Value<String?> note = const Value.absent(),
            Value<String?> attachments = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExpenseTransactionsCompanion.insert(
            id: id,
            trackerId: trackerId,
            accountId: accountId,
            categoryId: categoryId,
            memberId: memberId,
            amount: amount,
            isIncome: isIncome,
            date: date,
            note: note,
            attachments: attachments,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ExpenseTransactionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {trackerId = false,
              accountId = false,
              categoryId = false,
              memberId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (trackerId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.trackerId,
                    referencedTable: $$ExpenseTransactionsTableReferences
                        ._trackerIdTable(db),
                    referencedColumn: $$ExpenseTransactionsTableReferences
                        ._trackerIdTable(db)
                        .id,
                  ) as T;
                }
                if (accountId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.accountId,
                    referencedTable: $$ExpenseTransactionsTableReferences
                        ._accountIdTable(db),
                    referencedColumn: $$ExpenseTransactionsTableReferences
                        ._accountIdTable(db)
                        .id,
                  ) as T;
                }
                if (categoryId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.categoryId,
                    referencedTable: $$ExpenseTransactionsTableReferences
                        ._categoryIdTable(db),
                    referencedColumn: $$ExpenseTransactionsTableReferences
                        ._categoryIdTable(db)
                        .id,
                  ) as T;
                }
                if (memberId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.memberId,
                    referencedTable:
                        $$ExpenseTransactionsTableReferences._memberIdTable(db),
                    referencedColumn: $$ExpenseTransactionsTableReferences
                        ._memberIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ExpenseTransactionsTableProcessedTableManager = ProcessedTableManager<
    _$ExpenseDatabase,
    $ExpenseTransactionsTable,
    ExpenseTransaction,
    $$ExpenseTransactionsTableFilterComposer,
    $$ExpenseTransactionsTableOrderingComposer,
    $$ExpenseTransactionsTableAnnotationComposer,
    $$ExpenseTransactionsTableCreateCompanionBuilder,
    $$ExpenseTransactionsTableUpdateCompanionBuilder,
    (ExpenseTransaction, $$ExpenseTransactionsTableReferences),
    ExpenseTransaction,
    PrefetchHooks Function(
        {bool trackerId, bool accountId, bool categoryId, bool memberId})>;

class $ExpenseDatabaseManager {
  final _$ExpenseDatabase _db;
  $ExpenseDatabaseManager(this._db);
  $$ExpenseTrackersTableTableManager get expenseTrackers =>
      $$ExpenseTrackersTableTableManager(_db, _db.expenseTrackers);
  $$ExpenseMembersTableTableManager get expenseMembers =>
      $$ExpenseMembersTableTableManager(_db, _db.expenseMembers);
  $$ExpenseAccountsTableTableManager get expenseAccounts =>
      $$ExpenseAccountsTableTableManager(_db, _db.expenseAccounts);
  $$ExpenseCategoriesTableTableManager get expenseCategories =>
      $$ExpenseCategoriesTableTableManager(_db, _db.expenseCategories);
  $$ExpenseSubscriptionsTableTableManager get expenseSubscriptions =>
      $$ExpenseSubscriptionsTableTableManager(_db, _db.expenseSubscriptions);
  $$ExpenseInstallmentsTableTableManager get expenseInstallments =>
      $$ExpenseInstallmentsTableTableManager(_db, _db.expenseInstallments);
  $$ExpenseTransactionsTableTableManager get expenseTransactions =>
      $$ExpenseTransactionsTableTableManager(_db, _db.expenseTransactions);
}
