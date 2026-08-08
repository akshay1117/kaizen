// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gym_database.dart';

// ignore_for_file: type=lint
class $ExercisesTable extends Exercises
    with TableInfo<$ExercisesTable, Exercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExercisesTable(this.attachedDatabase, [this._alias]);
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
  @override
  late final GeneratedColumnWithTypeConverter<List<MuscleGroup>, String>
      primaryMuscles = GeneratedColumn<String>(
              'primary_muscles', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<MuscleGroup>>(
              $ExercisesTable.$converterprimaryMuscles);
  @override
  late final GeneratedColumnWithTypeConverter<List<MuscleGroup>, String>
      secondaryMuscles = GeneratedColumn<String>(
              'secondary_muscles', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<MuscleGroup>>(
              $ExercisesTable.$convertersecondaryMuscles);
  static const VerificationMeta _defaultFormulaIndexMeta =
      const VerificationMeta('defaultFormulaIndex');
  @override
  late final GeneratedColumn<int> defaultFormulaIndex = GeneratedColumn<int>(
      'default_formula_index', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(OneRmFormula.average.index));
  static const VerificationMeta _oneRmEnabledMeta =
      const VerificationMeta('oneRmEnabled');
  @override
  late final GeneratedColumn<bool> oneRmEnabled = GeneratedColumn<bool>(
      'one_rm_enabled', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("one_rm_enabled" IN (0, 1))'),
      defaultValue: const Constant(true));
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
        name,
        primaryMuscles,
        secondaryMuscles,
        defaultFormulaIndex,
        oneRmEnabled,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercises';
  @override
  VerificationContext validateIntegrity(Insertable<Exercise> instance,
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
    if (data.containsKey('default_formula_index')) {
      context.handle(
          _defaultFormulaIndexMeta,
          defaultFormulaIndex.isAcceptableOrUnknown(
              data['default_formula_index']!, _defaultFormulaIndexMeta));
    }
    if (data.containsKey('one_rm_enabled')) {
      context.handle(
          _oneRmEnabledMeta,
          oneRmEnabled.isAcceptableOrUnknown(
              data['one_rm_enabled']!, _oneRmEnabledMeta));
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
  Exercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Exercise(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      primaryMuscles: $ExercisesTable.$converterprimaryMuscles.fromSql(
          attachedDatabase.typeMapping.read(
              DriftSqlType.string, data['${effectivePrefix}primary_muscles'])!),
      secondaryMuscles: $ExercisesTable.$convertersecondaryMuscles.fromSql(
          attachedDatabase.typeMapping.read(DriftSqlType.string,
              data['${effectivePrefix}secondary_muscles'])!),
      defaultFormulaIndex: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}default_formula_index'])!,
      oneRmEnabled: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}one_rm_enabled'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ExercisesTable createAlias(String alias) {
    return $ExercisesTable(attachedDatabase, alias);
  }

  static TypeConverter<List<MuscleGroup>, String> $converterprimaryMuscles =
      const MuscleGroupListConverter();
  static TypeConverter<List<MuscleGroup>, String> $convertersecondaryMuscles =
      const MuscleGroupListConverter();
}

class Exercise extends DataClass implements Insertable<Exercise> {
  final String id;
  final String name;
  final List<MuscleGroup> primaryMuscles;
  final List<MuscleGroup> secondaryMuscles;
  final int defaultFormulaIndex;
  final bool oneRmEnabled;
  final DateTime createdAt;
  const Exercise(
      {required this.id,
      required this.name,
      required this.primaryMuscles,
      required this.secondaryMuscles,
      required this.defaultFormulaIndex,
      required this.oneRmEnabled,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    {
      map['primary_muscles'] = Variable<String>(
          $ExercisesTable.$converterprimaryMuscles.toSql(primaryMuscles));
    }
    {
      map['secondary_muscles'] = Variable<String>(
          $ExercisesTable.$convertersecondaryMuscles.toSql(secondaryMuscles));
    }
    map['default_formula_index'] = Variable<int>(defaultFormulaIndex);
    map['one_rm_enabled'] = Variable<bool>(oneRmEnabled);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ExercisesCompanion toCompanion(bool nullToAbsent) {
    return ExercisesCompanion(
      id: Value(id),
      name: Value(name),
      primaryMuscles: Value(primaryMuscles),
      secondaryMuscles: Value(secondaryMuscles),
      defaultFormulaIndex: Value(defaultFormulaIndex),
      oneRmEnabled: Value(oneRmEnabled),
      createdAt: Value(createdAt),
    );
  }

  factory Exercise.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Exercise(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      primaryMuscles:
          serializer.fromJson<List<MuscleGroup>>(json['primaryMuscles']),
      secondaryMuscles:
          serializer.fromJson<List<MuscleGroup>>(json['secondaryMuscles']),
      defaultFormulaIndex:
          serializer.fromJson<int>(json['defaultFormulaIndex']),
      oneRmEnabled: serializer.fromJson<bool>(json['oneRmEnabled']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'primaryMuscles': serializer.toJson<List<MuscleGroup>>(primaryMuscles),
      'secondaryMuscles':
          serializer.toJson<List<MuscleGroup>>(secondaryMuscles),
      'defaultFormulaIndex': serializer.toJson<int>(defaultFormulaIndex),
      'oneRmEnabled': serializer.toJson<bool>(oneRmEnabled),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Exercise copyWith(
          {String? id,
          String? name,
          List<MuscleGroup>? primaryMuscles,
          List<MuscleGroup>? secondaryMuscles,
          int? defaultFormulaIndex,
          bool? oneRmEnabled,
          DateTime? createdAt}) =>
      Exercise(
        id: id ?? this.id,
        name: name ?? this.name,
        primaryMuscles: primaryMuscles ?? this.primaryMuscles,
        secondaryMuscles: secondaryMuscles ?? this.secondaryMuscles,
        defaultFormulaIndex: defaultFormulaIndex ?? this.defaultFormulaIndex,
        oneRmEnabled: oneRmEnabled ?? this.oneRmEnabled,
        createdAt: createdAt ?? this.createdAt,
      );
  Exercise copyWithCompanion(ExercisesCompanion data) {
    return Exercise(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      primaryMuscles: data.primaryMuscles.present
          ? data.primaryMuscles.value
          : this.primaryMuscles,
      secondaryMuscles: data.secondaryMuscles.present
          ? data.secondaryMuscles.value
          : this.secondaryMuscles,
      defaultFormulaIndex: data.defaultFormulaIndex.present
          ? data.defaultFormulaIndex.value
          : this.defaultFormulaIndex,
      oneRmEnabled: data.oneRmEnabled.present
          ? data.oneRmEnabled.value
          : this.oneRmEnabled,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Exercise(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('primaryMuscles: $primaryMuscles, ')
          ..write('secondaryMuscles: $secondaryMuscles, ')
          ..write('defaultFormulaIndex: $defaultFormulaIndex, ')
          ..write('oneRmEnabled: $oneRmEnabled, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, primaryMuscles, secondaryMuscles,
      defaultFormulaIndex, oneRmEnabled, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Exercise &&
          other.id == this.id &&
          other.name == this.name &&
          other.primaryMuscles == this.primaryMuscles &&
          other.secondaryMuscles == this.secondaryMuscles &&
          other.defaultFormulaIndex == this.defaultFormulaIndex &&
          other.oneRmEnabled == this.oneRmEnabled &&
          other.createdAt == this.createdAt);
}

class ExercisesCompanion extends UpdateCompanion<Exercise> {
  final Value<String> id;
  final Value<String> name;
  final Value<List<MuscleGroup>> primaryMuscles;
  final Value<List<MuscleGroup>> secondaryMuscles;
  final Value<int> defaultFormulaIndex;
  final Value<bool> oneRmEnabled;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ExercisesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.primaryMuscles = const Value.absent(),
    this.secondaryMuscles = const Value.absent(),
    this.defaultFormulaIndex = const Value.absent(),
    this.oneRmEnabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExercisesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required List<MuscleGroup> primaryMuscles,
    required List<MuscleGroup> secondaryMuscles,
    this.defaultFormulaIndex = const Value.absent(),
    this.oneRmEnabled = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : name = Value(name),
        primaryMuscles = Value(primaryMuscles),
        secondaryMuscles = Value(secondaryMuscles);
  static Insertable<Exercise> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? primaryMuscles,
    Expression<String>? secondaryMuscles,
    Expression<int>? defaultFormulaIndex,
    Expression<bool>? oneRmEnabled,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (primaryMuscles != null) 'primary_muscles': primaryMuscles,
      if (secondaryMuscles != null) 'secondary_muscles': secondaryMuscles,
      if (defaultFormulaIndex != null)
        'default_formula_index': defaultFormulaIndex,
      if (oneRmEnabled != null) 'one_rm_enabled': oneRmEnabled,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExercisesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<List<MuscleGroup>>? primaryMuscles,
      Value<List<MuscleGroup>>? secondaryMuscles,
      Value<int>? defaultFormulaIndex,
      Value<bool>? oneRmEnabled,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return ExercisesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      primaryMuscles: primaryMuscles ?? this.primaryMuscles,
      secondaryMuscles: secondaryMuscles ?? this.secondaryMuscles,
      defaultFormulaIndex: defaultFormulaIndex ?? this.defaultFormulaIndex,
      oneRmEnabled: oneRmEnabled ?? this.oneRmEnabled,
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
    if (primaryMuscles.present) {
      map['primary_muscles'] = Variable<String>(
          $ExercisesTable.$converterprimaryMuscles.toSql(primaryMuscles.value));
    }
    if (secondaryMuscles.present) {
      map['secondary_muscles'] = Variable<String>($ExercisesTable
          .$convertersecondaryMuscles
          .toSql(secondaryMuscles.value));
    }
    if (defaultFormulaIndex.present) {
      map['default_formula_index'] = Variable<int>(defaultFormulaIndex.value);
    }
    if (oneRmEnabled.present) {
      map['one_rm_enabled'] = Variable<bool>(oneRmEnabled.value);
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
    return (StringBuffer('ExercisesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('primaryMuscles: $primaryMuscles, ')
          ..write('secondaryMuscles: $secondaryMuscles, ')
          ..write('defaultFormulaIndex: $defaultFormulaIndex, ')
          ..write('oneRmEnabled: $oneRmEnabled, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SetEntriesTable extends SetEntries
    with TableInfo<$SetEntriesTable, SetEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SetEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => '${DateTime.now().millisecondsSinceEpoch}');
  static const VerificationMeta _exerciseIdMeta =
      const VerificationMeta('exerciseId');
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
      'exercise_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES exercises (id) ON DELETE CASCADE'));
  static const VerificationMeta _workoutSessionIdMeta =
      const VerificationMeta('workoutSessionId');
  @override
  late final GeneratedColumn<String> workoutSessionId = GeneratedColumn<String>(
      'workout_session_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _multisetIdMeta =
      const VerificationMeta('multisetId');
  @override
  late final GeneratedColumn<String> multisetId = GeneratedColumn<String>(
      'multiset_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _weightKgMeta =
      const VerificationMeta('weightKg');
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
      'weight_kg', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
      'reps', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _labelIndexMeta =
      const VerificationMeta('labelIndex');
  @override
  late final GeneratedColumn<int> labelIndex = GeneratedColumn<int>(
      'label_index', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(SetLabel.none.index));
  static const VerificationMeta _performedAtMeta =
      const VerificationMeta('performedAt');
  @override
  late final GeneratedColumn<DateTime> performedAt = GeneratedColumn<DateTime>(
      'performed_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _restSecondsBeforeMeta =
      const VerificationMeta('restSecondsBefore');
  @override
  late final GeneratedColumn<int> restSecondsBefore = GeneratedColumn<int>(
      'rest_seconds_before', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        exerciseId,
        workoutSessionId,
        multisetId,
        weightKg,
        reps,
        labelIndex,
        performedAt,
        note,
        restSecondsBefore
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'set_entries';
  @override
  VerificationContext validateIntegrity(Insertable<SetEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
          _exerciseIdMeta,
          exerciseId.isAcceptableOrUnknown(
              data['exercise_id']!, _exerciseIdMeta));
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('workout_session_id')) {
      context.handle(
          _workoutSessionIdMeta,
          workoutSessionId.isAcceptableOrUnknown(
              data['workout_session_id']!, _workoutSessionIdMeta));
    }
    if (data.containsKey('multiset_id')) {
      context.handle(
          _multisetIdMeta,
          multisetId.isAcceptableOrUnknown(
              data['multiset_id']!, _multisetIdMeta));
    }
    if (data.containsKey('weight_kg')) {
      context.handle(_weightKgMeta,
          weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta));
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('reps')) {
      context.handle(
          _repsMeta, reps.isAcceptableOrUnknown(data['reps']!, _repsMeta));
    } else if (isInserting) {
      context.missing(_repsMeta);
    }
    if (data.containsKey('label_index')) {
      context.handle(
          _labelIndexMeta,
          labelIndex.isAcceptableOrUnknown(
              data['label_index']!, _labelIndexMeta));
    }
    if (data.containsKey('performed_at')) {
      context.handle(
          _performedAtMeta,
          performedAt.isAcceptableOrUnknown(
              data['performed_at']!, _performedAtMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('rest_seconds_before')) {
      context.handle(
          _restSecondsBeforeMeta,
          restSecondsBefore.isAcceptableOrUnknown(
              data['rest_seconds_before']!, _restSecondsBeforeMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SetEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SetEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      exerciseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}exercise_id'])!,
      workoutSessionId: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}workout_session_id']),
      multisetId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}multiset_id']),
      weightKg: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}weight_kg'])!,
      reps: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reps'])!,
      labelIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}label_index'])!,
      performedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}performed_at'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      restSecondsBefore: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}rest_seconds_before']),
    );
  }

  @override
  $SetEntriesTable createAlias(String alias) {
    return $SetEntriesTable(attachedDatabase, alias);
  }
}

class SetEntry extends DataClass implements Insertable<SetEntry> {
  final String id;
  final String exerciseId;
  final String? workoutSessionId;
  final String? multisetId;
  final double weightKg;
  final int reps;
  final int labelIndex;
  final DateTime performedAt;
  final String? note;
  final int? restSecondsBefore;
  const SetEntry(
      {required this.id,
      required this.exerciseId,
      this.workoutSessionId,
      this.multisetId,
      required this.weightKg,
      required this.reps,
      required this.labelIndex,
      required this.performedAt,
      this.note,
      this.restSecondsBefore});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['exercise_id'] = Variable<String>(exerciseId);
    if (!nullToAbsent || workoutSessionId != null) {
      map['workout_session_id'] = Variable<String>(workoutSessionId);
    }
    if (!nullToAbsent || multisetId != null) {
      map['multiset_id'] = Variable<String>(multisetId);
    }
    map['weight_kg'] = Variable<double>(weightKg);
    map['reps'] = Variable<int>(reps);
    map['label_index'] = Variable<int>(labelIndex);
    map['performed_at'] = Variable<DateTime>(performedAt);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || restSecondsBefore != null) {
      map['rest_seconds_before'] = Variable<int>(restSecondsBefore);
    }
    return map;
  }

  SetEntriesCompanion toCompanion(bool nullToAbsent) {
    return SetEntriesCompanion(
      id: Value(id),
      exerciseId: Value(exerciseId),
      workoutSessionId: workoutSessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(workoutSessionId),
      multisetId: multisetId == null && nullToAbsent
          ? const Value.absent()
          : Value(multisetId),
      weightKg: Value(weightKg),
      reps: Value(reps),
      labelIndex: Value(labelIndex),
      performedAt: Value(performedAt),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      restSecondsBefore: restSecondsBefore == null && nullToAbsent
          ? const Value.absent()
          : Value(restSecondsBefore),
    );
  }

  factory SetEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SetEntry(
      id: serializer.fromJson<String>(json['id']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      workoutSessionId: serializer.fromJson<String?>(json['workoutSessionId']),
      multisetId: serializer.fromJson<String?>(json['multisetId']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      reps: serializer.fromJson<int>(json['reps']),
      labelIndex: serializer.fromJson<int>(json['labelIndex']),
      performedAt: serializer.fromJson<DateTime>(json['performedAt']),
      note: serializer.fromJson<String?>(json['note']),
      restSecondsBefore: serializer.fromJson<int?>(json['restSecondsBefore']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'workoutSessionId': serializer.toJson<String?>(workoutSessionId),
      'multisetId': serializer.toJson<String?>(multisetId),
      'weightKg': serializer.toJson<double>(weightKg),
      'reps': serializer.toJson<int>(reps),
      'labelIndex': serializer.toJson<int>(labelIndex),
      'performedAt': serializer.toJson<DateTime>(performedAt),
      'note': serializer.toJson<String?>(note),
      'restSecondsBefore': serializer.toJson<int?>(restSecondsBefore),
    };
  }

  SetEntry copyWith(
          {String? id,
          String? exerciseId,
          Value<String?> workoutSessionId = const Value.absent(),
          Value<String?> multisetId = const Value.absent(),
          double? weightKg,
          int? reps,
          int? labelIndex,
          DateTime? performedAt,
          Value<String?> note = const Value.absent(),
          Value<int?> restSecondsBefore = const Value.absent()}) =>
      SetEntry(
        id: id ?? this.id,
        exerciseId: exerciseId ?? this.exerciseId,
        workoutSessionId: workoutSessionId.present
            ? workoutSessionId.value
            : this.workoutSessionId,
        multisetId: multisetId.present ? multisetId.value : this.multisetId,
        weightKg: weightKg ?? this.weightKg,
        reps: reps ?? this.reps,
        labelIndex: labelIndex ?? this.labelIndex,
        performedAt: performedAt ?? this.performedAt,
        note: note.present ? note.value : this.note,
        restSecondsBefore: restSecondsBefore.present
            ? restSecondsBefore.value
            : this.restSecondsBefore,
      );
  SetEntry copyWithCompanion(SetEntriesCompanion data) {
    return SetEntry(
      id: data.id.present ? data.id.value : this.id,
      exerciseId:
          data.exerciseId.present ? data.exerciseId.value : this.exerciseId,
      workoutSessionId: data.workoutSessionId.present
          ? data.workoutSessionId.value
          : this.workoutSessionId,
      multisetId:
          data.multisetId.present ? data.multisetId.value : this.multisetId,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      reps: data.reps.present ? data.reps.value : this.reps,
      labelIndex:
          data.labelIndex.present ? data.labelIndex.value : this.labelIndex,
      performedAt:
          data.performedAt.present ? data.performedAt.value : this.performedAt,
      note: data.note.present ? data.note.value : this.note,
      restSecondsBefore: data.restSecondsBefore.present
          ? data.restSecondsBefore.value
          : this.restSecondsBefore,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SetEntry(')
          ..write('id: $id, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('workoutSessionId: $workoutSessionId, ')
          ..write('multisetId: $multisetId, ')
          ..write('weightKg: $weightKg, ')
          ..write('reps: $reps, ')
          ..write('labelIndex: $labelIndex, ')
          ..write('performedAt: $performedAt, ')
          ..write('note: $note, ')
          ..write('restSecondsBefore: $restSecondsBefore')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, exerciseId, workoutSessionId, multisetId,
      weightKg, reps, labelIndex, performedAt, note, restSecondsBefore);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SetEntry &&
          other.id == this.id &&
          other.exerciseId == this.exerciseId &&
          other.workoutSessionId == this.workoutSessionId &&
          other.multisetId == this.multisetId &&
          other.weightKg == this.weightKg &&
          other.reps == this.reps &&
          other.labelIndex == this.labelIndex &&
          other.performedAt == this.performedAt &&
          other.note == this.note &&
          other.restSecondsBefore == this.restSecondsBefore);
}

class SetEntriesCompanion extends UpdateCompanion<SetEntry> {
  final Value<String> id;
  final Value<String> exerciseId;
  final Value<String?> workoutSessionId;
  final Value<String?> multisetId;
  final Value<double> weightKg;
  final Value<int> reps;
  final Value<int> labelIndex;
  final Value<DateTime> performedAt;
  final Value<String?> note;
  final Value<int?> restSecondsBefore;
  final Value<int> rowid;
  const SetEntriesCompanion({
    this.id = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.workoutSessionId = const Value.absent(),
    this.multisetId = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.reps = const Value.absent(),
    this.labelIndex = const Value.absent(),
    this.performedAt = const Value.absent(),
    this.note = const Value.absent(),
    this.restSecondsBefore = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SetEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String exerciseId,
    this.workoutSessionId = const Value.absent(),
    this.multisetId = const Value.absent(),
    required double weightKg,
    required int reps,
    this.labelIndex = const Value.absent(),
    this.performedAt = const Value.absent(),
    this.note = const Value.absent(),
    this.restSecondsBefore = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : exerciseId = Value(exerciseId),
        weightKg = Value(weightKg),
        reps = Value(reps);
  static Insertable<SetEntry> custom({
    Expression<String>? id,
    Expression<String>? exerciseId,
    Expression<String>? workoutSessionId,
    Expression<String>? multisetId,
    Expression<double>? weightKg,
    Expression<int>? reps,
    Expression<int>? labelIndex,
    Expression<DateTime>? performedAt,
    Expression<String>? note,
    Expression<int>? restSecondsBefore,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (workoutSessionId != null) 'workout_session_id': workoutSessionId,
      if (multisetId != null) 'multiset_id': multisetId,
      if (weightKg != null) 'weight_kg': weightKg,
      if (reps != null) 'reps': reps,
      if (labelIndex != null) 'label_index': labelIndex,
      if (performedAt != null) 'performed_at': performedAt,
      if (note != null) 'note': note,
      if (restSecondsBefore != null) 'rest_seconds_before': restSecondsBefore,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SetEntriesCompanion copyWith(
      {Value<String>? id,
      Value<String>? exerciseId,
      Value<String?>? workoutSessionId,
      Value<String?>? multisetId,
      Value<double>? weightKg,
      Value<int>? reps,
      Value<int>? labelIndex,
      Value<DateTime>? performedAt,
      Value<String?>? note,
      Value<int?>? restSecondsBefore,
      Value<int>? rowid}) {
    return SetEntriesCompanion(
      id: id ?? this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      workoutSessionId: workoutSessionId ?? this.workoutSessionId,
      multisetId: multisetId ?? this.multisetId,
      weightKg: weightKg ?? this.weightKg,
      reps: reps ?? this.reps,
      labelIndex: labelIndex ?? this.labelIndex,
      performedAt: performedAt ?? this.performedAt,
      note: note ?? this.note,
      restSecondsBefore: restSecondsBefore ?? this.restSecondsBefore,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (workoutSessionId.present) {
      map['workout_session_id'] = Variable<String>(workoutSessionId.value);
    }
    if (multisetId.present) {
      map['multiset_id'] = Variable<String>(multisetId.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (labelIndex.present) {
      map['label_index'] = Variable<int>(labelIndex.value);
    }
    if (performedAt.present) {
      map['performed_at'] = Variable<DateTime>(performedAt.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (restSecondsBefore.present) {
      map['rest_seconds_before'] = Variable<int>(restSecondsBefore.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SetEntriesCompanion(')
          ..write('id: $id, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('workoutSessionId: $workoutSessionId, ')
          ..write('multisetId: $multisetId, ')
          ..write('weightKg: $weightKg, ')
          ..write('reps: $reps, ')
          ..write('labelIndex: $labelIndex, ')
          ..write('performedAt: $performedAt, ')
          ..write('note: $note, ')
          ..write('restSecondsBefore: $restSecondsBefore, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutsTable extends Workouts with TableInfo<$WorkoutsTable, Workout> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _groupIdMeta =
      const VerificationMeta('groupId');
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
      'group_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sortIndexMeta =
      const VerificationMeta('sortIndex');
  @override
  late final GeneratedColumn<int> sortIndex = GeneratedColumn<int>(
      'sort_index', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
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
      [id, name, description, groupId, sortIndex, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workouts';
  @override
  VerificationContext validateIntegrity(Insertable<Workout> instance,
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
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta,
          groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    }
    if (data.containsKey('sort_index')) {
      context.handle(_sortIndexMeta,
          sortIndex.isAcceptableOrUnknown(data['sort_index']!, _sortIndexMeta));
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
  Workout map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Workout(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      groupId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}group_id']),
      sortIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sort_index'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $WorkoutsTable createAlias(String alias) {
    return $WorkoutsTable(attachedDatabase, alias);
  }
}

class Workout extends DataClass implements Insertable<Workout> {
  final String id;
  final String name;
  final String? description;
  final String? groupId;
  final int sortIndex;
  final DateTime createdAt;
  const Workout(
      {required this.id,
      required this.name,
      this.description,
      this.groupId,
      required this.sortIndex,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || groupId != null) {
      map['group_id'] = Variable<String>(groupId);
    }
    map['sort_index'] = Variable<int>(sortIndex);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  WorkoutsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      groupId: groupId == null && nullToAbsent
          ? const Value.absent()
          : Value(groupId),
      sortIndex: Value(sortIndex),
      createdAt: Value(createdAt),
    );
  }

  factory Workout.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Workout(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      groupId: serializer.fromJson<String?>(json['groupId']),
      sortIndex: serializer.fromJson<int>(json['sortIndex']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'groupId': serializer.toJson<String?>(groupId),
      'sortIndex': serializer.toJson<int>(sortIndex),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Workout copyWith(
          {String? id,
          String? name,
          Value<String?> description = const Value.absent(),
          Value<String?> groupId = const Value.absent(),
          int? sortIndex,
          DateTime? createdAt}) =>
      Workout(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        groupId: groupId.present ? groupId.value : this.groupId,
        sortIndex: sortIndex ?? this.sortIndex,
        createdAt: createdAt ?? this.createdAt,
      );
  Workout copyWithCompanion(WorkoutsCompanion data) {
    return Workout(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      sortIndex: data.sortIndex.present ? data.sortIndex.value : this.sortIndex,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Workout(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('groupId: $groupId, ')
          ..write('sortIndex: $sortIndex, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, description, groupId, sortIndex, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Workout &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.groupId == this.groupId &&
          other.sortIndex == this.sortIndex &&
          other.createdAt == this.createdAt);
}

class WorkoutsCompanion extends UpdateCompanion<Workout> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> groupId;
  final Value<int> sortIndex;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const WorkoutsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.groupId = const Value.absent(),
    this.sortIndex = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.groupId = const Value.absent(),
    this.sortIndex = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Workout> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? groupId,
    Expression<int>? sortIndex,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (groupId != null) 'group_id': groupId,
      if (sortIndex != null) 'sort_index': sortIndex,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? description,
      Value<String?>? groupId,
      Value<int>? sortIndex,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return WorkoutsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      groupId: groupId ?? this.groupId,
      sortIndex: sortIndex ?? this.sortIndex,
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
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (sortIndex.present) {
      map['sort_index'] = Variable<int>(sortIndex.value);
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
    return (StringBuffer('WorkoutsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('groupId: $groupId, ')
          ..write('sortIndex: $sortIndex, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutStepsTable extends WorkoutSteps
    with TableInfo<$WorkoutStepsTable, WorkoutStep> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutStepsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => '${DateTime.now().millisecondsSinceEpoch}');
  static const VerificationMeta _workoutIdMeta =
      const VerificationMeta('workoutId');
  @override
  late final GeneratedColumn<String> workoutId = GeneratedColumn<String>(
      'workout_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES workouts (id) ON DELETE CASCADE'));
  static const VerificationMeta _stepTypeMeta =
      const VerificationMeta('stepType');
  @override
  late final GeneratedColumn<int> stepType = GeneratedColumn<int>(
      'step_type', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _refIdMeta = const VerificationMeta('refId');
  @override
  late final GeneratedColumn<String> refId = GeneratedColumn<String>(
      'ref_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _stepOrderMeta =
      const VerificationMeta('stepOrder');
  @override
  late final GeneratedColumn<int> stepOrder = GeneratedColumn<int>(
      'step_order', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, workoutId, stepType, refId, stepOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_steps';
  @override
  VerificationContext validateIntegrity(Insertable<WorkoutStep> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('workout_id')) {
      context.handle(_workoutIdMeta,
          workoutId.isAcceptableOrUnknown(data['workout_id']!, _workoutIdMeta));
    } else if (isInserting) {
      context.missing(_workoutIdMeta);
    }
    if (data.containsKey('step_type')) {
      context.handle(_stepTypeMeta,
          stepType.isAcceptableOrUnknown(data['step_type']!, _stepTypeMeta));
    } else if (isInserting) {
      context.missing(_stepTypeMeta);
    }
    if (data.containsKey('ref_id')) {
      context.handle(
          _refIdMeta, refId.isAcceptableOrUnknown(data['ref_id']!, _refIdMeta));
    } else if (isInserting) {
      context.missing(_refIdMeta);
    }
    if (data.containsKey('step_order')) {
      context.handle(_stepOrderMeta,
          stepOrder.isAcceptableOrUnknown(data['step_order']!, _stepOrderMeta));
    } else if (isInserting) {
      context.missing(_stepOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutStep map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutStep(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      workoutId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}workout_id'])!,
      stepType: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}step_type'])!,
      refId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}ref_id'])!,
      stepOrder: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}step_order'])!,
    );
  }

  @override
  $WorkoutStepsTable createAlias(String alias) {
    return $WorkoutStepsTable(attachedDatabase, alias);
  }
}

class WorkoutStep extends DataClass implements Insertable<WorkoutStep> {
  final String id;
  final String workoutId;
  final int stepType;
  final String refId;
  final int stepOrder;
  const WorkoutStep(
      {required this.id,
      required this.workoutId,
      required this.stepType,
      required this.refId,
      required this.stepOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['workout_id'] = Variable<String>(workoutId);
    map['step_type'] = Variable<int>(stepType);
    map['ref_id'] = Variable<String>(refId);
    map['step_order'] = Variable<int>(stepOrder);
    return map;
  }

  WorkoutStepsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutStepsCompanion(
      id: Value(id),
      workoutId: Value(workoutId),
      stepType: Value(stepType),
      refId: Value(refId),
      stepOrder: Value(stepOrder),
    );
  }

  factory WorkoutStep.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutStep(
      id: serializer.fromJson<String>(json['id']),
      workoutId: serializer.fromJson<String>(json['workoutId']),
      stepType: serializer.fromJson<int>(json['stepType']),
      refId: serializer.fromJson<String>(json['refId']),
      stepOrder: serializer.fromJson<int>(json['stepOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workoutId': serializer.toJson<String>(workoutId),
      'stepType': serializer.toJson<int>(stepType),
      'refId': serializer.toJson<String>(refId),
      'stepOrder': serializer.toJson<int>(stepOrder),
    };
  }

  WorkoutStep copyWith(
          {String? id,
          String? workoutId,
          int? stepType,
          String? refId,
          int? stepOrder}) =>
      WorkoutStep(
        id: id ?? this.id,
        workoutId: workoutId ?? this.workoutId,
        stepType: stepType ?? this.stepType,
        refId: refId ?? this.refId,
        stepOrder: stepOrder ?? this.stepOrder,
      );
  WorkoutStep copyWithCompanion(WorkoutStepsCompanion data) {
    return WorkoutStep(
      id: data.id.present ? data.id.value : this.id,
      workoutId: data.workoutId.present ? data.workoutId.value : this.workoutId,
      stepType: data.stepType.present ? data.stepType.value : this.stepType,
      refId: data.refId.present ? data.refId.value : this.refId,
      stepOrder: data.stepOrder.present ? data.stepOrder.value : this.stepOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutStep(')
          ..write('id: $id, ')
          ..write('workoutId: $workoutId, ')
          ..write('stepType: $stepType, ')
          ..write('refId: $refId, ')
          ..write('stepOrder: $stepOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, workoutId, stepType, refId, stepOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutStep &&
          other.id == this.id &&
          other.workoutId == this.workoutId &&
          other.stepType == this.stepType &&
          other.refId == this.refId &&
          other.stepOrder == this.stepOrder);
}

class WorkoutStepsCompanion extends UpdateCompanion<WorkoutStep> {
  final Value<String> id;
  final Value<String> workoutId;
  final Value<int> stepType;
  final Value<String> refId;
  final Value<int> stepOrder;
  final Value<int> rowid;
  const WorkoutStepsCompanion({
    this.id = const Value.absent(),
    this.workoutId = const Value.absent(),
    this.stepType = const Value.absent(),
    this.refId = const Value.absent(),
    this.stepOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutStepsCompanion.insert({
    this.id = const Value.absent(),
    required String workoutId,
    required int stepType,
    required String refId,
    required int stepOrder,
    this.rowid = const Value.absent(),
  })  : workoutId = Value(workoutId),
        stepType = Value(stepType),
        refId = Value(refId),
        stepOrder = Value(stepOrder);
  static Insertable<WorkoutStep> custom({
    Expression<String>? id,
    Expression<String>? workoutId,
    Expression<int>? stepType,
    Expression<String>? refId,
    Expression<int>? stepOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workoutId != null) 'workout_id': workoutId,
      if (stepType != null) 'step_type': stepType,
      if (refId != null) 'ref_id': refId,
      if (stepOrder != null) 'step_order': stepOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutStepsCompanion copyWith(
      {Value<String>? id,
      Value<String>? workoutId,
      Value<int>? stepType,
      Value<String>? refId,
      Value<int>? stepOrder,
      Value<int>? rowid}) {
    return WorkoutStepsCompanion(
      id: id ?? this.id,
      workoutId: workoutId ?? this.workoutId,
      stepType: stepType ?? this.stepType,
      refId: refId ?? this.refId,
      stepOrder: stepOrder ?? this.stepOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workoutId.present) {
      map['workout_id'] = Variable<String>(workoutId.value);
    }
    if (stepType.present) {
      map['step_type'] = Variable<int>(stepType.value);
    }
    if (refId.present) {
      map['ref_id'] = Variable<String>(refId.value);
    }
    if (stepOrder.present) {
      map['step_order'] = Variable<int>(stepOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutStepsCompanion(')
          ..write('id: $id, ')
          ..write('workoutId: $workoutId, ')
          ..write('stepType: $stepType, ')
          ..write('refId: $refId, ')
          ..write('stepOrder: $stepOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MultisetsTable extends Multisets
    with TableInfo<$MultisetsTable, Multiset> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MultisetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => '${DateTime.now().millisecondsSinceEpoch}');
  static const VerificationMeta _templateIndexMeta =
      const VerificationMeta('templateIndex');
  @override
  late final GeneratedColumn<int> templateIndex = GeneratedColumn<int>(
      'template_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _setsMeta = const VerificationMeta('sets');
  @override
  late final GeneratedColumn<int> sets = GeneratedColumn<int>(
      'sets', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _restBetweenIsDefaultMeta =
      const VerificationMeta('restBetweenIsDefault');
  @override
  late final GeneratedColumn<bool> restBetweenIsDefault = GeneratedColumn<bool>(
      'rest_between_is_default', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("rest_between_is_default" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _restBetweenSecondsMeta =
      const VerificationMeta('restBetweenSeconds');
  @override
  late final GeneratedColumn<int> restBetweenSeconds = GeneratedColumn<int>(
      'rest_between_seconds', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _hasRestAfterMeta =
      const VerificationMeta('hasRestAfter');
  @override
  late final GeneratedColumn<bool> hasRestAfter = GeneratedColumn<bool>(
      'has_rest_after', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("has_rest_after" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _restAfterSecondsMeta =
      const VerificationMeta('restAfterSeconds');
  @override
  late final GeneratedColumn<int> restAfterSeconds = GeneratedColumn<int>(
      'rest_after_seconds', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _checkOffEachSetMeta =
      const VerificationMeta('checkOffEachSet');
  @override
  late final GeneratedColumn<bool> checkOffEachSet = GeneratedColumn<bool>(
      'check_off_each_set', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("check_off_each_set" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _iconIndexMeta =
      const VerificationMeta('iconIndex');
  @override
  late final GeneratedColumn<int> iconIndex = GeneratedColumn<int>(
      'icon_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        templateIndex,
        name,
        sets,
        restBetweenIsDefault,
        restBetweenSeconds,
        hasRestAfter,
        restAfterSeconds,
        checkOffEachSet,
        iconIndex
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'multisets';
  @override
  VerificationContext validateIntegrity(Insertable<Multiset> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('template_index')) {
      context.handle(
          _templateIndexMeta,
          templateIndex.isAcceptableOrUnknown(
              data['template_index']!, _templateIndexMeta));
    } else if (isInserting) {
      context.missing(_templateIndexMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    }
    if (data.containsKey('sets')) {
      context.handle(
          _setsMeta, sets.isAcceptableOrUnknown(data['sets']!, _setsMeta));
    }
    if (data.containsKey('rest_between_is_default')) {
      context.handle(
          _restBetweenIsDefaultMeta,
          restBetweenIsDefault.isAcceptableOrUnknown(
              data['rest_between_is_default']!, _restBetweenIsDefaultMeta));
    }
    if (data.containsKey('rest_between_seconds')) {
      context.handle(
          _restBetweenSecondsMeta,
          restBetweenSeconds.isAcceptableOrUnknown(
              data['rest_between_seconds']!, _restBetweenSecondsMeta));
    }
    if (data.containsKey('has_rest_after')) {
      context.handle(
          _hasRestAfterMeta,
          hasRestAfter.isAcceptableOrUnknown(
              data['has_rest_after']!, _hasRestAfterMeta));
    }
    if (data.containsKey('rest_after_seconds')) {
      context.handle(
          _restAfterSecondsMeta,
          restAfterSeconds.isAcceptableOrUnknown(
              data['rest_after_seconds']!, _restAfterSecondsMeta));
    }
    if (data.containsKey('check_off_each_set')) {
      context.handle(
          _checkOffEachSetMeta,
          checkOffEachSet.isAcceptableOrUnknown(
              data['check_off_each_set']!, _checkOffEachSetMeta));
    }
    if (data.containsKey('icon_index')) {
      context.handle(_iconIndexMeta,
          iconIndex.isAcceptableOrUnknown(data['icon_index']!, _iconIndexMeta));
    } else if (isInserting) {
      context.missing(_iconIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Multiset map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Multiset(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      templateIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}template_index'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name']),
      sets: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}sets'])!,
      restBetweenIsDefault: attachedDatabase.typeMapping.read(DriftSqlType.bool,
          data['${effectivePrefix}rest_between_is_default'])!,
      restBetweenSeconds: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}rest_between_seconds']),
      hasRestAfter: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}has_rest_after'])!,
      restAfterSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}rest_after_seconds']),
      checkOffEachSet: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}check_off_each_set'])!,
      iconIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}icon_index'])!,
    );
  }

  @override
  $MultisetsTable createAlias(String alias) {
    return $MultisetsTable(attachedDatabase, alias);
  }
}

class Multiset extends DataClass implements Insertable<Multiset> {
  final String id;
  final int templateIndex;
  final String? name;
  final int sets;
  final bool restBetweenIsDefault;
  final int? restBetweenSeconds;
  final bool hasRestAfter;
  final int? restAfterSeconds;
  final bool checkOffEachSet;
  final int iconIndex;
  const Multiset(
      {required this.id,
      required this.templateIndex,
      this.name,
      required this.sets,
      required this.restBetweenIsDefault,
      this.restBetweenSeconds,
      required this.hasRestAfter,
      this.restAfterSeconds,
      required this.checkOffEachSet,
      required this.iconIndex});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['template_index'] = Variable<int>(templateIndex);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    map['sets'] = Variable<int>(sets);
    map['rest_between_is_default'] = Variable<bool>(restBetweenIsDefault);
    if (!nullToAbsent || restBetweenSeconds != null) {
      map['rest_between_seconds'] = Variable<int>(restBetweenSeconds);
    }
    map['has_rest_after'] = Variable<bool>(hasRestAfter);
    if (!nullToAbsent || restAfterSeconds != null) {
      map['rest_after_seconds'] = Variable<int>(restAfterSeconds);
    }
    map['check_off_each_set'] = Variable<bool>(checkOffEachSet);
    map['icon_index'] = Variable<int>(iconIndex);
    return map;
  }

  MultisetsCompanion toCompanion(bool nullToAbsent) {
    return MultisetsCompanion(
      id: Value(id),
      templateIndex: Value(templateIndex),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      sets: Value(sets),
      restBetweenIsDefault: Value(restBetweenIsDefault),
      restBetweenSeconds: restBetweenSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(restBetweenSeconds),
      hasRestAfter: Value(hasRestAfter),
      restAfterSeconds: restAfterSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(restAfterSeconds),
      checkOffEachSet: Value(checkOffEachSet),
      iconIndex: Value(iconIndex),
    );
  }

  factory Multiset.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Multiset(
      id: serializer.fromJson<String>(json['id']),
      templateIndex: serializer.fromJson<int>(json['templateIndex']),
      name: serializer.fromJson<String?>(json['name']),
      sets: serializer.fromJson<int>(json['sets']),
      restBetweenIsDefault:
          serializer.fromJson<bool>(json['restBetweenIsDefault']),
      restBetweenSeconds: serializer.fromJson<int?>(json['restBetweenSeconds']),
      hasRestAfter: serializer.fromJson<bool>(json['hasRestAfter']),
      restAfterSeconds: serializer.fromJson<int?>(json['restAfterSeconds']),
      checkOffEachSet: serializer.fromJson<bool>(json['checkOffEachSet']),
      iconIndex: serializer.fromJson<int>(json['iconIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'templateIndex': serializer.toJson<int>(templateIndex),
      'name': serializer.toJson<String?>(name),
      'sets': serializer.toJson<int>(sets),
      'restBetweenIsDefault': serializer.toJson<bool>(restBetweenIsDefault),
      'restBetweenSeconds': serializer.toJson<int?>(restBetweenSeconds),
      'hasRestAfter': serializer.toJson<bool>(hasRestAfter),
      'restAfterSeconds': serializer.toJson<int?>(restAfterSeconds),
      'checkOffEachSet': serializer.toJson<bool>(checkOffEachSet),
      'iconIndex': serializer.toJson<int>(iconIndex),
    };
  }

  Multiset copyWith(
          {String? id,
          int? templateIndex,
          Value<String?> name = const Value.absent(),
          int? sets,
          bool? restBetweenIsDefault,
          Value<int?> restBetweenSeconds = const Value.absent(),
          bool? hasRestAfter,
          Value<int?> restAfterSeconds = const Value.absent(),
          bool? checkOffEachSet,
          int? iconIndex}) =>
      Multiset(
        id: id ?? this.id,
        templateIndex: templateIndex ?? this.templateIndex,
        name: name.present ? name.value : this.name,
        sets: sets ?? this.sets,
        restBetweenIsDefault: restBetweenIsDefault ?? this.restBetweenIsDefault,
        restBetweenSeconds: restBetweenSeconds.present
            ? restBetweenSeconds.value
            : this.restBetweenSeconds,
        hasRestAfter: hasRestAfter ?? this.hasRestAfter,
        restAfterSeconds: restAfterSeconds.present
            ? restAfterSeconds.value
            : this.restAfterSeconds,
        checkOffEachSet: checkOffEachSet ?? this.checkOffEachSet,
        iconIndex: iconIndex ?? this.iconIndex,
      );
  Multiset copyWithCompanion(MultisetsCompanion data) {
    return Multiset(
      id: data.id.present ? data.id.value : this.id,
      templateIndex: data.templateIndex.present
          ? data.templateIndex.value
          : this.templateIndex,
      name: data.name.present ? data.name.value : this.name,
      sets: data.sets.present ? data.sets.value : this.sets,
      restBetweenIsDefault: data.restBetweenIsDefault.present
          ? data.restBetweenIsDefault.value
          : this.restBetweenIsDefault,
      restBetweenSeconds: data.restBetweenSeconds.present
          ? data.restBetweenSeconds.value
          : this.restBetweenSeconds,
      hasRestAfter: data.hasRestAfter.present
          ? data.hasRestAfter.value
          : this.hasRestAfter,
      restAfterSeconds: data.restAfterSeconds.present
          ? data.restAfterSeconds.value
          : this.restAfterSeconds,
      checkOffEachSet: data.checkOffEachSet.present
          ? data.checkOffEachSet.value
          : this.checkOffEachSet,
      iconIndex: data.iconIndex.present ? data.iconIndex.value : this.iconIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Multiset(')
          ..write('id: $id, ')
          ..write('templateIndex: $templateIndex, ')
          ..write('name: $name, ')
          ..write('sets: $sets, ')
          ..write('restBetweenIsDefault: $restBetweenIsDefault, ')
          ..write('restBetweenSeconds: $restBetweenSeconds, ')
          ..write('hasRestAfter: $hasRestAfter, ')
          ..write('restAfterSeconds: $restAfterSeconds, ')
          ..write('checkOffEachSet: $checkOffEachSet, ')
          ..write('iconIndex: $iconIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      templateIndex,
      name,
      sets,
      restBetweenIsDefault,
      restBetweenSeconds,
      hasRestAfter,
      restAfterSeconds,
      checkOffEachSet,
      iconIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Multiset &&
          other.id == this.id &&
          other.templateIndex == this.templateIndex &&
          other.name == this.name &&
          other.sets == this.sets &&
          other.restBetweenIsDefault == this.restBetweenIsDefault &&
          other.restBetweenSeconds == this.restBetweenSeconds &&
          other.hasRestAfter == this.hasRestAfter &&
          other.restAfterSeconds == this.restAfterSeconds &&
          other.checkOffEachSet == this.checkOffEachSet &&
          other.iconIndex == this.iconIndex);
}

class MultisetsCompanion extends UpdateCompanion<Multiset> {
  final Value<String> id;
  final Value<int> templateIndex;
  final Value<String?> name;
  final Value<int> sets;
  final Value<bool> restBetweenIsDefault;
  final Value<int?> restBetweenSeconds;
  final Value<bool> hasRestAfter;
  final Value<int?> restAfterSeconds;
  final Value<bool> checkOffEachSet;
  final Value<int> iconIndex;
  final Value<int> rowid;
  const MultisetsCompanion({
    this.id = const Value.absent(),
    this.templateIndex = const Value.absent(),
    this.name = const Value.absent(),
    this.sets = const Value.absent(),
    this.restBetweenIsDefault = const Value.absent(),
    this.restBetweenSeconds = const Value.absent(),
    this.hasRestAfter = const Value.absent(),
    this.restAfterSeconds = const Value.absent(),
    this.checkOffEachSet = const Value.absent(),
    this.iconIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MultisetsCompanion.insert({
    this.id = const Value.absent(),
    required int templateIndex,
    this.name = const Value.absent(),
    this.sets = const Value.absent(),
    this.restBetweenIsDefault = const Value.absent(),
    this.restBetweenSeconds = const Value.absent(),
    this.hasRestAfter = const Value.absent(),
    this.restAfterSeconds = const Value.absent(),
    this.checkOffEachSet = const Value.absent(),
    required int iconIndex,
    this.rowid = const Value.absent(),
  })  : templateIndex = Value(templateIndex),
        iconIndex = Value(iconIndex);
  static Insertable<Multiset> custom({
    Expression<String>? id,
    Expression<int>? templateIndex,
    Expression<String>? name,
    Expression<int>? sets,
    Expression<bool>? restBetweenIsDefault,
    Expression<int>? restBetweenSeconds,
    Expression<bool>? hasRestAfter,
    Expression<int>? restAfterSeconds,
    Expression<bool>? checkOffEachSet,
    Expression<int>? iconIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (templateIndex != null) 'template_index': templateIndex,
      if (name != null) 'name': name,
      if (sets != null) 'sets': sets,
      if (restBetweenIsDefault != null)
        'rest_between_is_default': restBetweenIsDefault,
      if (restBetweenSeconds != null)
        'rest_between_seconds': restBetweenSeconds,
      if (hasRestAfter != null) 'has_rest_after': hasRestAfter,
      if (restAfterSeconds != null) 'rest_after_seconds': restAfterSeconds,
      if (checkOffEachSet != null) 'check_off_each_set': checkOffEachSet,
      if (iconIndex != null) 'icon_index': iconIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MultisetsCompanion copyWith(
      {Value<String>? id,
      Value<int>? templateIndex,
      Value<String?>? name,
      Value<int>? sets,
      Value<bool>? restBetweenIsDefault,
      Value<int?>? restBetweenSeconds,
      Value<bool>? hasRestAfter,
      Value<int?>? restAfterSeconds,
      Value<bool>? checkOffEachSet,
      Value<int>? iconIndex,
      Value<int>? rowid}) {
    return MultisetsCompanion(
      id: id ?? this.id,
      templateIndex: templateIndex ?? this.templateIndex,
      name: name ?? this.name,
      sets: sets ?? this.sets,
      restBetweenIsDefault: restBetweenIsDefault ?? this.restBetweenIsDefault,
      restBetweenSeconds: restBetweenSeconds ?? this.restBetweenSeconds,
      hasRestAfter: hasRestAfter ?? this.hasRestAfter,
      restAfterSeconds: restAfterSeconds ?? this.restAfterSeconds,
      checkOffEachSet: checkOffEachSet ?? this.checkOffEachSet,
      iconIndex: iconIndex ?? this.iconIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (templateIndex.present) {
      map['template_index'] = Variable<int>(templateIndex.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sets.present) {
      map['sets'] = Variable<int>(sets.value);
    }
    if (restBetweenIsDefault.present) {
      map['rest_between_is_default'] =
          Variable<bool>(restBetweenIsDefault.value);
    }
    if (restBetweenSeconds.present) {
      map['rest_between_seconds'] = Variable<int>(restBetweenSeconds.value);
    }
    if (hasRestAfter.present) {
      map['has_rest_after'] = Variable<bool>(hasRestAfter.value);
    }
    if (restAfterSeconds.present) {
      map['rest_after_seconds'] = Variable<int>(restAfterSeconds.value);
    }
    if (checkOffEachSet.present) {
      map['check_off_each_set'] = Variable<bool>(checkOffEachSet.value);
    }
    if (iconIndex.present) {
      map['icon_index'] = Variable<int>(iconIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MultisetsCompanion(')
          ..write('id: $id, ')
          ..write('templateIndex: $templateIndex, ')
          ..write('name: $name, ')
          ..write('sets: $sets, ')
          ..write('restBetweenIsDefault: $restBetweenIsDefault, ')
          ..write('restBetweenSeconds: $restBetweenSeconds, ')
          ..write('hasRestAfter: $hasRestAfter, ')
          ..write('restAfterSeconds: $restAfterSeconds, ')
          ..write('checkOffEachSet: $checkOffEachSet, ')
          ..write('iconIndex: $iconIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MultisetExerciseConfigsTable extends MultisetExerciseConfigs
    with TableInfo<$MultisetExerciseConfigsTable, MultisetExerciseConfig> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MultisetExerciseConfigsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => '${DateTime.now().millisecondsSinceEpoch}');
  static const VerificationMeta _multisetIdMeta =
      const VerificationMeta('multisetId');
  @override
  late final GeneratedColumn<String> multisetId = GeneratedColumn<String>(
      'multiset_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES multisets (id) ON DELETE CASCADE'));
  static const VerificationMeta _exerciseIdMeta =
      const VerificationMeta('exerciseId');
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
      'exercise_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES exercises (id) ON DELETE CASCADE'));
  static const VerificationMeta _orderIndexMeta =
      const VerificationMeta('orderIndex');
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
      'order_index', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, multisetId, exerciseId, orderIndex];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'multiset_exercise_configs';
  @override
  VerificationContext validateIntegrity(
      Insertable<MultisetExerciseConfig> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('multiset_id')) {
      context.handle(
          _multisetIdMeta,
          multisetId.isAcceptableOrUnknown(
              data['multiset_id']!, _multisetIdMeta));
    } else if (isInserting) {
      context.missing(_multisetIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
          _exerciseIdMeta,
          exerciseId.isAcceptableOrUnknown(
              data['exercise_id']!, _exerciseIdMeta));
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
          _orderIndexMeta,
          orderIndex.isAcceptableOrUnknown(
              data['order_index']!, _orderIndexMeta));
    } else if (isInserting) {
      context.missing(_orderIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MultisetExerciseConfig map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MultisetExerciseConfig(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      multisetId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}multiset_id'])!,
      exerciseId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}exercise_id'])!,
      orderIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order_index'])!,
    );
  }

  @override
  $MultisetExerciseConfigsTable createAlias(String alias) {
    return $MultisetExerciseConfigsTable(attachedDatabase, alias);
  }
}

class MultisetExerciseConfig extends DataClass
    implements Insertable<MultisetExerciseConfig> {
  final String id;
  final String multisetId;
  final String exerciseId;
  final int orderIndex;
  const MultisetExerciseConfig(
      {required this.id,
      required this.multisetId,
      required this.exerciseId,
      required this.orderIndex});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['multiset_id'] = Variable<String>(multisetId);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['order_index'] = Variable<int>(orderIndex);
    return map;
  }

  MultisetExerciseConfigsCompanion toCompanion(bool nullToAbsent) {
    return MultisetExerciseConfigsCompanion(
      id: Value(id),
      multisetId: Value(multisetId),
      exerciseId: Value(exerciseId),
      orderIndex: Value(orderIndex),
    );
  }

  factory MultisetExerciseConfig.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MultisetExerciseConfig(
      id: serializer.fromJson<String>(json['id']),
      multisetId: serializer.fromJson<String>(json['multisetId']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'multisetId': serializer.toJson<String>(multisetId),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'orderIndex': serializer.toJson<int>(orderIndex),
    };
  }

  MultisetExerciseConfig copyWith(
          {String? id,
          String? multisetId,
          String? exerciseId,
          int? orderIndex}) =>
      MultisetExerciseConfig(
        id: id ?? this.id,
        multisetId: multisetId ?? this.multisetId,
        exerciseId: exerciseId ?? this.exerciseId,
        orderIndex: orderIndex ?? this.orderIndex,
      );
  MultisetExerciseConfig copyWithCompanion(
      MultisetExerciseConfigsCompanion data) {
    return MultisetExerciseConfig(
      id: data.id.present ? data.id.value : this.id,
      multisetId:
          data.multisetId.present ? data.multisetId.value : this.multisetId,
      exerciseId:
          data.exerciseId.present ? data.exerciseId.value : this.exerciseId,
      orderIndex:
          data.orderIndex.present ? data.orderIndex.value : this.orderIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MultisetExerciseConfig(')
          ..write('id: $id, ')
          ..write('multisetId: $multisetId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('orderIndex: $orderIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, multisetId, exerciseId, orderIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MultisetExerciseConfig &&
          other.id == this.id &&
          other.multisetId == this.multisetId &&
          other.exerciseId == this.exerciseId &&
          other.orderIndex == this.orderIndex);
}

class MultisetExerciseConfigsCompanion
    extends UpdateCompanion<MultisetExerciseConfig> {
  final Value<String> id;
  final Value<String> multisetId;
  final Value<String> exerciseId;
  final Value<int> orderIndex;
  final Value<int> rowid;
  const MultisetExerciseConfigsCompanion({
    this.id = const Value.absent(),
    this.multisetId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MultisetExerciseConfigsCompanion.insert({
    this.id = const Value.absent(),
    required String multisetId,
    required String exerciseId,
    required int orderIndex,
    this.rowid = const Value.absent(),
  })  : multisetId = Value(multisetId),
        exerciseId = Value(exerciseId),
        orderIndex = Value(orderIndex);
  static Insertable<MultisetExerciseConfig> custom({
    Expression<String>? id,
    Expression<String>? multisetId,
    Expression<String>? exerciseId,
    Expression<int>? orderIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (multisetId != null) 'multiset_id': multisetId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (orderIndex != null) 'order_index': orderIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MultisetExerciseConfigsCompanion copyWith(
      {Value<String>? id,
      Value<String>? multisetId,
      Value<String>? exerciseId,
      Value<int>? orderIndex,
      Value<int>? rowid}) {
    return MultisetExerciseConfigsCompanion(
      id: id ?? this.id,
      multisetId: multisetId ?? this.multisetId,
      exerciseId: exerciseId ?? this.exerciseId,
      orderIndex: orderIndex ?? this.orderIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (multisetId.present) {
      map['multiset_id'] = Variable<String>(multisetId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MultisetExerciseConfigsCompanion(')
          ..write('id: $id, ')
          ..write('multisetId: $multisetId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutGroupsTable extends WorkoutGroups
    with TableInfo<$WorkoutGroupsTable, WorkoutGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutGroupsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _colorIndexMeta =
      const VerificationMeta('colorIndex');
  @override
  late final GeneratedColumn<int> colorIndex = GeneratedColumn<int>(
      'color_index', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [id, name, description, colorIndex];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_groups';
  @override
  VerificationContext validateIntegrity(Insertable<WorkoutGroup> instance,
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
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('color_index')) {
      context.handle(
          _colorIndexMeta,
          colorIndex.isAcceptableOrUnknown(
              data['color_index']!, _colorIndexMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutGroup(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      colorIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color_index'])!,
    );
  }

  @override
  $WorkoutGroupsTable createAlias(String alias) {
    return $WorkoutGroupsTable(attachedDatabase, alias);
  }
}

class WorkoutGroup extends DataClass implements Insertable<WorkoutGroup> {
  final String id;
  final String name;
  final String? description;
  final int colorIndex;
  const WorkoutGroup(
      {required this.id,
      required this.name,
      this.description,
      required this.colorIndex});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['color_index'] = Variable<int>(colorIndex);
    return map;
  }

  WorkoutGroupsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutGroupsCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      colorIndex: Value(colorIndex),
    );
  }

  factory WorkoutGroup.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutGroup(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      colorIndex: serializer.fromJson<int>(json['colorIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'colorIndex': serializer.toJson<int>(colorIndex),
    };
  }

  WorkoutGroup copyWith(
          {String? id,
          String? name,
          Value<String?> description = const Value.absent(),
          int? colorIndex}) =>
      WorkoutGroup(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        colorIndex: colorIndex ?? this.colorIndex,
      );
  WorkoutGroup copyWithCompanion(WorkoutGroupsCompanion data) {
    return WorkoutGroup(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      colorIndex:
          data.colorIndex.present ? data.colorIndex.value : this.colorIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutGroup(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('colorIndex: $colorIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, colorIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutGroup &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.colorIndex == this.colorIndex);
}

class WorkoutGroupsCompanion extends UpdateCompanion<WorkoutGroup> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<int> colorIndex;
  final Value<int> rowid;
  const WorkoutGroupsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.colorIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutGroupsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.colorIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<WorkoutGroup> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? colorIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (colorIndex != null) 'color_index': colorIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutGroupsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? description,
      Value<int>? colorIndex,
      Value<int>? rowid}) {
    return WorkoutGroupsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      colorIndex: colorIndex ?? this.colorIndex,
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
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (colorIndex.present) {
      map['color_index'] = Variable<int>(colorIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutGroupsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('colorIndex: $colorIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSessionsTable extends WorkoutSessions
    with TableInfo<$WorkoutSessionsTable, WorkoutSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => '${DateTime.now().millisecondsSinceEpoch}');
  static const VerificationMeta _workoutIdMeta =
      const VerificationMeta('workoutId');
  @override
  late final GeneratedColumn<String> workoutId = GeneratedColumn<String>(
      'workout_id', aliasedName, true,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES workouts (id) ON DELETE SET NULL'));
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _durationSecondsMeta =
      const VerificationMeta('durationSeconds');
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
      'duration_seconds', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [id, workoutId, date, durationSeconds];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_sessions';
  @override
  VerificationContext validateIntegrity(Insertable<WorkoutSession> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('workout_id')) {
      context.handle(_workoutIdMeta,
          workoutId.isAcceptableOrUnknown(data['workout_id']!, _workoutIdMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
          _durationSecondsMeta,
          durationSeconds.isAcceptableOrUnknown(
              data['duration_seconds']!, _durationSecondsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSession(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      workoutId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}workout_id']),
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      durationSeconds: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_seconds']),
    );
  }

  @override
  $WorkoutSessionsTable createAlias(String alias) {
    return $WorkoutSessionsTable(attachedDatabase, alias);
  }
}

class WorkoutSession extends DataClass implements Insertable<WorkoutSession> {
  final String id;
  final String? workoutId;
  final DateTime date;
  final int? durationSeconds;
  const WorkoutSession(
      {required this.id,
      this.workoutId,
      required this.date,
      this.durationSeconds});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || workoutId != null) {
      map['workout_id'] = Variable<String>(workoutId);
    }
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || durationSeconds != null) {
      map['duration_seconds'] = Variable<int>(durationSeconds);
    }
    return map;
  }

  WorkoutSessionsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSessionsCompanion(
      id: Value(id),
      workoutId: workoutId == null && nullToAbsent
          ? const Value.absent()
          : Value(workoutId),
      date: Value(date),
      durationSeconds: durationSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(durationSeconds),
    );
  }

  factory WorkoutSession.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSession(
      id: serializer.fromJson<String>(json['id']),
      workoutId: serializer.fromJson<String?>(json['workoutId']),
      date: serializer.fromJson<DateTime>(json['date']),
      durationSeconds: serializer.fromJson<int?>(json['durationSeconds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workoutId': serializer.toJson<String?>(workoutId),
      'date': serializer.toJson<DateTime>(date),
      'durationSeconds': serializer.toJson<int?>(durationSeconds),
    };
  }

  WorkoutSession copyWith(
          {String? id,
          Value<String?> workoutId = const Value.absent(),
          DateTime? date,
          Value<int?> durationSeconds = const Value.absent()}) =>
      WorkoutSession(
        id: id ?? this.id,
        workoutId: workoutId.present ? workoutId.value : this.workoutId,
        date: date ?? this.date,
        durationSeconds: durationSeconds.present
            ? durationSeconds.value
            : this.durationSeconds,
      );
  WorkoutSession copyWithCompanion(WorkoutSessionsCompanion data) {
    return WorkoutSession(
      id: data.id.present ? data.id.value : this.id,
      workoutId: data.workoutId.present ? data.workoutId.value : this.workoutId,
      date: data.date.present ? data.date.value : this.date,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSession(')
          ..write('id: $id, ')
          ..write('workoutId: $workoutId, ')
          ..write('date: $date, ')
          ..write('durationSeconds: $durationSeconds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, workoutId, date, durationSeconds);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSession &&
          other.id == this.id &&
          other.workoutId == this.workoutId &&
          other.date == this.date &&
          other.durationSeconds == this.durationSeconds);
}

class WorkoutSessionsCompanion extends UpdateCompanion<WorkoutSession> {
  final Value<String> id;
  final Value<String?> workoutId;
  final Value<DateTime> date;
  final Value<int?> durationSeconds;
  final Value<int> rowid;
  const WorkoutSessionsCompanion({
    this.id = const Value.absent(),
    this.workoutId = const Value.absent(),
    this.date = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutSessionsCompanion.insert({
    this.id = const Value.absent(),
    this.workoutId = const Value.absent(),
    this.date = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<WorkoutSession> custom({
    Expression<String>? id,
    Expression<String>? workoutId,
    Expression<DateTime>? date,
    Expression<int>? durationSeconds,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workoutId != null) 'workout_id': workoutId,
      if (date != null) 'date': date,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutSessionsCompanion copyWith(
      {Value<String>? id,
      Value<String?>? workoutId,
      Value<DateTime>? date,
      Value<int?>? durationSeconds,
      Value<int>? rowid}) {
    return WorkoutSessionsCompanion(
      id: id ?? this.id,
      workoutId: workoutId ?? this.workoutId,
      date: date ?? this.date,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workoutId.present) {
      map['workout_id'] = Variable<String>(workoutId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSessionsCompanion(')
          ..write('id: $id, ')
          ..write('workoutId: $workoutId, ')
          ..write('date: $date, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BodyWeightEntriesTable extends BodyWeightEntries
    with TableInfo<$BodyWeightEntriesTable, BodyWeightEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BodyWeightEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => '${DateTime.now().millisecondsSinceEpoch}');
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      clientDefault: () => DateTime.now());
  static const VerificationMeta _weightKgMeta =
      const VerificationMeta('weightKg');
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
      'weight_kg', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, date, weightKg];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'body_weight_entries';
  @override
  VerificationContext validateIntegrity(Insertable<BodyWeightEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    }
    if (data.containsKey('weight_kg')) {
      context.handle(_weightKgMeta,
          weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta));
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BodyWeightEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BodyWeightEntry(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      weightKg: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}weight_kg'])!,
    );
  }

  @override
  $BodyWeightEntriesTable createAlias(String alias) {
    return $BodyWeightEntriesTable(attachedDatabase, alias);
  }
}

class BodyWeightEntry extends DataClass implements Insertable<BodyWeightEntry> {
  final String id;
  final DateTime date;
  final double weightKg;
  const BodyWeightEntry(
      {required this.id, required this.date, required this.weightKg});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<DateTime>(date);
    map['weight_kg'] = Variable<double>(weightKg);
    return map;
  }

  BodyWeightEntriesCompanion toCompanion(bool nullToAbsent) {
    return BodyWeightEntriesCompanion(
      id: Value(id),
      date: Value(date),
      weightKg: Value(weightKg),
    );
  }

  factory BodyWeightEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BodyWeightEntry(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<DateTime>(date),
      'weightKg': serializer.toJson<double>(weightKg),
    };
  }

  BodyWeightEntry copyWith({String? id, DateTime? date, double? weightKg}) =>
      BodyWeightEntry(
        id: id ?? this.id,
        date: date ?? this.date,
        weightKg: weightKg ?? this.weightKg,
      );
  BodyWeightEntry copyWithCompanion(BodyWeightEntriesCompanion data) {
    return BodyWeightEntry(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BodyWeightEntry(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('weightKg: $weightKg')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, weightKg);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BodyWeightEntry &&
          other.id == this.id &&
          other.date == this.date &&
          other.weightKg == this.weightKg);
}

class BodyWeightEntriesCompanion extends UpdateCompanion<BodyWeightEntry> {
  final Value<String> id;
  final Value<DateTime> date;
  final Value<double> weightKg;
  final Value<int> rowid;
  const BodyWeightEntriesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BodyWeightEntriesCompanion.insert({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    required double weightKg,
    this.rowid = const Value.absent(),
  }) : weightKg = Value(weightKg);
  static Insertable<BodyWeightEntry> custom({
    Expression<String>? id,
    Expression<DateTime>? date,
    Expression<double>? weightKg,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (weightKg != null) 'weight_kg': weightKg,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BodyWeightEntriesCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? date,
      Value<double>? weightKg,
      Value<int>? rowid}) {
    return BodyWeightEntriesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      weightKg: weightKg ?? this.weightKg,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BodyWeightEntriesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('weightKg: $weightKg, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProgrammesTable extends Programmes
    with TableInfo<$ProgrammesTable, Programme> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProgrammesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _durationWeeksMeta =
      const VerificationMeta('durationWeeks');
  @override
  late final GeneratedColumn<int> durationWeeks = GeneratedColumn<int>(
      'duration_weeks', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(4));
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
      [id, name, description, durationWeeks, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'programmes';
  @override
  VerificationContext validateIntegrity(Insertable<Programme> instance,
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
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('duration_weeks')) {
      context.handle(
          _durationWeeksMeta,
          durationWeeks.isAcceptableOrUnknown(
              data['duration_weeks']!, _durationWeeksMeta));
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
  Programme map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Programme(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      durationWeeks: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_weeks'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ProgrammesTable createAlias(String alias) {
    return $ProgrammesTable(attachedDatabase, alias);
  }
}

class Programme extends DataClass implements Insertable<Programme> {
  final String id;
  final String name;
  final String? description;
  final int durationWeeks;
  final DateTime createdAt;
  const Programme(
      {required this.id,
      required this.name,
      this.description,
      required this.durationWeeks,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['duration_weeks'] = Variable<int>(durationWeeks);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProgrammesCompanion toCompanion(bool nullToAbsent) {
    return ProgrammesCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      durationWeeks: Value(durationWeeks),
      createdAt: Value(createdAt),
    );
  }

  factory Programme.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Programme(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      durationWeeks: serializer.fromJson<int>(json['durationWeeks']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'durationWeeks': serializer.toJson<int>(durationWeeks),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Programme copyWith(
          {String? id,
          String? name,
          Value<String?> description = const Value.absent(),
          int? durationWeeks,
          DateTime? createdAt}) =>
      Programme(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description.present ? description.value : this.description,
        durationWeeks: durationWeeks ?? this.durationWeeks,
        createdAt: createdAt ?? this.createdAt,
      );
  Programme copyWithCompanion(ProgrammesCompanion data) {
    return Programme(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      durationWeeks: data.durationWeeks.present
          ? data.durationWeeks.value
          : this.durationWeeks,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Programme(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('durationWeeks: $durationWeeks, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, description, durationWeeks, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Programme &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.durationWeeks == this.durationWeeks &&
          other.createdAt == this.createdAt);
}

class ProgrammesCompanion extends UpdateCompanion<Programme> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<int> durationWeeks;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ProgrammesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.durationWeeks = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProgrammesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.durationWeeks = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Programme> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? durationWeeks,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (durationWeeks != null) 'duration_weeks': durationWeeks,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProgrammesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? description,
      Value<int>? durationWeeks,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return ProgrammesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      durationWeeks: durationWeeks ?? this.durationWeeks,
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
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (durationWeeks.present) {
      map['duration_weeks'] = Variable<int>(durationWeeks.value);
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
    return (StringBuffer('ProgrammesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('durationWeeks: $durationWeeks, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProgrammeWorkoutsTable extends ProgrammeWorkouts
    with TableInfo<$ProgrammeWorkoutsTable, ProgrammeWorkout> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProgrammeWorkoutsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      clientDefault: () => '${DateTime.now().millisecondsSinceEpoch}');
  static const VerificationMeta _programmeIdMeta =
      const VerificationMeta('programmeId');
  @override
  late final GeneratedColumn<String> programmeId = GeneratedColumn<String>(
      'programme_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES programmes (id) ON DELETE CASCADE'));
  static const VerificationMeta _workoutIdMeta =
      const VerificationMeta('workoutId');
  @override
  late final GeneratedColumn<String> workoutId = GeneratedColumn<String>(
      'workout_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES workouts (id) ON DELETE CASCADE'));
  static const VerificationMeta _weekNumberMeta =
      const VerificationMeta('weekNumber');
  @override
  late final GeneratedColumn<int> weekNumber = GeneratedColumn<int>(
      'week_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _dayOfWeekMeta =
      const VerificationMeta('dayOfWeek');
  @override
  late final GeneratedColumn<int> dayOfWeek = GeneratedColumn<int>(
      'day_of_week', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, programmeId, workoutId, weekNumber, dayOfWeek];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'programme_workouts';
  @override
  VerificationContext validateIntegrity(Insertable<ProgrammeWorkout> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('programme_id')) {
      context.handle(
          _programmeIdMeta,
          programmeId.isAcceptableOrUnknown(
              data['programme_id']!, _programmeIdMeta));
    } else if (isInserting) {
      context.missing(_programmeIdMeta);
    }
    if (data.containsKey('workout_id')) {
      context.handle(_workoutIdMeta,
          workoutId.isAcceptableOrUnknown(data['workout_id']!, _workoutIdMeta));
    } else if (isInserting) {
      context.missing(_workoutIdMeta);
    }
    if (data.containsKey('week_number')) {
      context.handle(
          _weekNumberMeta,
          weekNumber.isAcceptableOrUnknown(
              data['week_number']!, _weekNumberMeta));
    } else if (isInserting) {
      context.missing(_weekNumberMeta);
    }
    if (data.containsKey('day_of_week')) {
      context.handle(
          _dayOfWeekMeta,
          dayOfWeek.isAcceptableOrUnknown(
              data['day_of_week']!, _dayOfWeekMeta));
    } else if (isInserting) {
      context.missing(_dayOfWeekMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProgrammeWorkout map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProgrammeWorkout(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      programmeId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}programme_id'])!,
      workoutId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}workout_id'])!,
      weekNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}week_number'])!,
      dayOfWeek: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}day_of_week'])!,
    );
  }

  @override
  $ProgrammeWorkoutsTable createAlias(String alias) {
    return $ProgrammeWorkoutsTable(attachedDatabase, alias);
  }
}

class ProgrammeWorkout extends DataClass
    implements Insertable<ProgrammeWorkout> {
  final String id;
  final String programmeId;
  final String workoutId;
  final int weekNumber;
  final int dayOfWeek;
  const ProgrammeWorkout(
      {required this.id,
      required this.programmeId,
      required this.workoutId,
      required this.weekNumber,
      required this.dayOfWeek});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['programme_id'] = Variable<String>(programmeId);
    map['workout_id'] = Variable<String>(workoutId);
    map['week_number'] = Variable<int>(weekNumber);
    map['day_of_week'] = Variable<int>(dayOfWeek);
    return map;
  }

  ProgrammeWorkoutsCompanion toCompanion(bool nullToAbsent) {
    return ProgrammeWorkoutsCompanion(
      id: Value(id),
      programmeId: Value(programmeId),
      workoutId: Value(workoutId),
      weekNumber: Value(weekNumber),
      dayOfWeek: Value(dayOfWeek),
    );
  }

  factory ProgrammeWorkout.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProgrammeWorkout(
      id: serializer.fromJson<String>(json['id']),
      programmeId: serializer.fromJson<String>(json['programmeId']),
      workoutId: serializer.fromJson<String>(json['workoutId']),
      weekNumber: serializer.fromJson<int>(json['weekNumber']),
      dayOfWeek: serializer.fromJson<int>(json['dayOfWeek']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'programmeId': serializer.toJson<String>(programmeId),
      'workoutId': serializer.toJson<String>(workoutId),
      'weekNumber': serializer.toJson<int>(weekNumber),
      'dayOfWeek': serializer.toJson<int>(dayOfWeek),
    };
  }

  ProgrammeWorkout copyWith(
          {String? id,
          String? programmeId,
          String? workoutId,
          int? weekNumber,
          int? dayOfWeek}) =>
      ProgrammeWorkout(
        id: id ?? this.id,
        programmeId: programmeId ?? this.programmeId,
        workoutId: workoutId ?? this.workoutId,
        weekNumber: weekNumber ?? this.weekNumber,
        dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      );
  ProgrammeWorkout copyWithCompanion(ProgrammeWorkoutsCompanion data) {
    return ProgrammeWorkout(
      id: data.id.present ? data.id.value : this.id,
      programmeId:
          data.programmeId.present ? data.programmeId.value : this.programmeId,
      workoutId: data.workoutId.present ? data.workoutId.value : this.workoutId,
      weekNumber:
          data.weekNumber.present ? data.weekNumber.value : this.weekNumber,
      dayOfWeek: data.dayOfWeek.present ? data.dayOfWeek.value : this.dayOfWeek,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProgrammeWorkout(')
          ..write('id: $id, ')
          ..write('programmeId: $programmeId, ')
          ..write('workoutId: $workoutId, ')
          ..write('weekNumber: $weekNumber, ')
          ..write('dayOfWeek: $dayOfWeek')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, programmeId, workoutId, weekNumber, dayOfWeek);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProgrammeWorkout &&
          other.id == this.id &&
          other.programmeId == this.programmeId &&
          other.workoutId == this.workoutId &&
          other.weekNumber == this.weekNumber &&
          other.dayOfWeek == this.dayOfWeek);
}

class ProgrammeWorkoutsCompanion extends UpdateCompanion<ProgrammeWorkout> {
  final Value<String> id;
  final Value<String> programmeId;
  final Value<String> workoutId;
  final Value<int> weekNumber;
  final Value<int> dayOfWeek;
  final Value<int> rowid;
  const ProgrammeWorkoutsCompanion({
    this.id = const Value.absent(),
    this.programmeId = const Value.absent(),
    this.workoutId = const Value.absent(),
    this.weekNumber = const Value.absent(),
    this.dayOfWeek = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProgrammeWorkoutsCompanion.insert({
    this.id = const Value.absent(),
    required String programmeId,
    required String workoutId,
    required int weekNumber,
    required int dayOfWeek,
    this.rowid = const Value.absent(),
  })  : programmeId = Value(programmeId),
        workoutId = Value(workoutId),
        weekNumber = Value(weekNumber),
        dayOfWeek = Value(dayOfWeek);
  static Insertable<ProgrammeWorkout> custom({
    Expression<String>? id,
    Expression<String>? programmeId,
    Expression<String>? workoutId,
    Expression<int>? weekNumber,
    Expression<int>? dayOfWeek,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (programmeId != null) 'programme_id': programmeId,
      if (workoutId != null) 'workout_id': workoutId,
      if (weekNumber != null) 'week_number': weekNumber,
      if (dayOfWeek != null) 'day_of_week': dayOfWeek,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProgrammeWorkoutsCompanion copyWith(
      {Value<String>? id,
      Value<String>? programmeId,
      Value<String>? workoutId,
      Value<int>? weekNumber,
      Value<int>? dayOfWeek,
      Value<int>? rowid}) {
    return ProgrammeWorkoutsCompanion(
      id: id ?? this.id,
      programmeId: programmeId ?? this.programmeId,
      workoutId: workoutId ?? this.workoutId,
      weekNumber: weekNumber ?? this.weekNumber,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (programmeId.present) {
      map['programme_id'] = Variable<String>(programmeId.value);
    }
    if (workoutId.present) {
      map['workout_id'] = Variable<String>(workoutId.value);
    }
    if (weekNumber.present) {
      map['week_number'] = Variable<int>(weekNumber.value);
    }
    if (dayOfWeek.present) {
      map['day_of_week'] = Variable<int>(dayOfWeek.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProgrammeWorkoutsCompanion(')
          ..write('id: $id, ')
          ..write('programmeId: $programmeId, ')
          ..write('workoutId: $workoutId, ')
          ..write('weekNumber: $weekNumber, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GymSettingsTableTable extends GymSettingsTable
    with TableInfo<$GymSettingsTableTable, GymSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GymSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('default'));
  static const VerificationMeta _unitIndexMeta =
      const VerificationMeta('unitIndex');
  @override
  late final GeneratedColumn<int> unitIndex = GeneratedColumn<int>(
      'unit_index', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: Constant(GymWeightUnit.kg.index));
  static const VerificationMeta _fullRecoveryDaysMeta =
      const VerificationMeta('fullRecoveryDays');
  @override
  late final GeneratedColumn<int> fullRecoveryDays = GeneratedColumn<int>(
      'full_recovery_days', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(3));
  static const VerificationMeta _defaultPlateSetMeta =
      const VerificationMeta('defaultPlateSet');
  @override
  late final GeneratedColumn<String> defaultPlateSet = GeneratedColumn<String>(
      'default_plate_set', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('2.5,5,10,25,45'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, unitIndex, fullRecoveryDays, defaultPlateSet];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gym_settings_table';
  @override
  VerificationContext validateIntegrity(Insertable<GymSetting> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('unit_index')) {
      context.handle(_unitIndexMeta,
          unitIndex.isAcceptableOrUnknown(data['unit_index']!, _unitIndexMeta));
    }
    if (data.containsKey('full_recovery_days')) {
      context.handle(
          _fullRecoveryDaysMeta,
          fullRecoveryDays.isAcceptableOrUnknown(
              data['full_recovery_days']!, _fullRecoveryDaysMeta));
    }
    if (data.containsKey('default_plate_set')) {
      context.handle(
          _defaultPlateSetMeta,
          defaultPlateSet.isAcceptableOrUnknown(
              data['default_plate_set']!, _defaultPlateSetMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GymSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GymSetting(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      unitIndex: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}unit_index'])!,
      fullRecoveryDays: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}full_recovery_days'])!,
      defaultPlateSet: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}default_plate_set'])!,
    );
  }

  @override
  $GymSettingsTableTable createAlias(String alias) {
    return $GymSettingsTableTable(attachedDatabase, alias);
  }
}

class GymSetting extends DataClass implements Insertable<GymSetting> {
  final String id;
  final int unitIndex;
  final int fullRecoveryDays;
  final String defaultPlateSet;
  const GymSetting(
      {required this.id,
      required this.unitIndex,
      required this.fullRecoveryDays,
      required this.defaultPlateSet});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['unit_index'] = Variable<int>(unitIndex);
    map['full_recovery_days'] = Variable<int>(fullRecoveryDays);
    map['default_plate_set'] = Variable<String>(defaultPlateSet);
    return map;
  }

  GymSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return GymSettingsTableCompanion(
      id: Value(id),
      unitIndex: Value(unitIndex),
      fullRecoveryDays: Value(fullRecoveryDays),
      defaultPlateSet: Value(defaultPlateSet),
    );
  }

  factory GymSetting.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GymSetting(
      id: serializer.fromJson<String>(json['id']),
      unitIndex: serializer.fromJson<int>(json['unitIndex']),
      fullRecoveryDays: serializer.fromJson<int>(json['fullRecoveryDays']),
      defaultPlateSet: serializer.fromJson<String>(json['defaultPlateSet']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'unitIndex': serializer.toJson<int>(unitIndex),
      'fullRecoveryDays': serializer.toJson<int>(fullRecoveryDays),
      'defaultPlateSet': serializer.toJson<String>(defaultPlateSet),
    };
  }

  GymSetting copyWith(
          {String? id,
          int? unitIndex,
          int? fullRecoveryDays,
          String? defaultPlateSet}) =>
      GymSetting(
        id: id ?? this.id,
        unitIndex: unitIndex ?? this.unitIndex,
        fullRecoveryDays: fullRecoveryDays ?? this.fullRecoveryDays,
        defaultPlateSet: defaultPlateSet ?? this.defaultPlateSet,
      );
  GymSetting copyWithCompanion(GymSettingsTableCompanion data) {
    return GymSetting(
      id: data.id.present ? data.id.value : this.id,
      unitIndex: data.unitIndex.present ? data.unitIndex.value : this.unitIndex,
      fullRecoveryDays: data.fullRecoveryDays.present
          ? data.fullRecoveryDays.value
          : this.fullRecoveryDays,
      defaultPlateSet: data.defaultPlateSet.present
          ? data.defaultPlateSet.value
          : this.defaultPlateSet,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GymSetting(')
          ..write('id: $id, ')
          ..write('unitIndex: $unitIndex, ')
          ..write('fullRecoveryDays: $fullRecoveryDays, ')
          ..write('defaultPlateSet: $defaultPlateSet')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, unitIndex, fullRecoveryDays, defaultPlateSet);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GymSetting &&
          other.id == this.id &&
          other.unitIndex == this.unitIndex &&
          other.fullRecoveryDays == this.fullRecoveryDays &&
          other.defaultPlateSet == this.defaultPlateSet);
}

class GymSettingsTableCompanion extends UpdateCompanion<GymSetting> {
  final Value<String> id;
  final Value<int> unitIndex;
  final Value<int> fullRecoveryDays;
  final Value<String> defaultPlateSet;
  final Value<int> rowid;
  const GymSettingsTableCompanion({
    this.id = const Value.absent(),
    this.unitIndex = const Value.absent(),
    this.fullRecoveryDays = const Value.absent(),
    this.defaultPlateSet = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GymSettingsTableCompanion.insert({
    this.id = const Value.absent(),
    this.unitIndex = const Value.absent(),
    this.fullRecoveryDays = const Value.absent(),
    this.defaultPlateSet = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<GymSetting> custom({
    Expression<String>? id,
    Expression<int>? unitIndex,
    Expression<int>? fullRecoveryDays,
    Expression<String>? defaultPlateSet,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (unitIndex != null) 'unit_index': unitIndex,
      if (fullRecoveryDays != null) 'full_recovery_days': fullRecoveryDays,
      if (defaultPlateSet != null) 'default_plate_set': defaultPlateSet,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GymSettingsTableCompanion copyWith(
      {Value<String>? id,
      Value<int>? unitIndex,
      Value<int>? fullRecoveryDays,
      Value<String>? defaultPlateSet,
      Value<int>? rowid}) {
    return GymSettingsTableCompanion(
      id: id ?? this.id,
      unitIndex: unitIndex ?? this.unitIndex,
      fullRecoveryDays: fullRecoveryDays ?? this.fullRecoveryDays,
      defaultPlateSet: defaultPlateSet ?? this.defaultPlateSet,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (unitIndex.present) {
      map['unit_index'] = Variable<int>(unitIndex.value);
    }
    if (fullRecoveryDays.present) {
      map['full_recovery_days'] = Variable<int>(fullRecoveryDays.value);
    }
    if (defaultPlateSet.present) {
      map['default_plate_set'] = Variable<String>(defaultPlateSet.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GymSettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('unitIndex: $unitIndex, ')
          ..write('fullRecoveryDays: $fullRecoveryDays, ')
          ..write('defaultPlateSet: $defaultPlateSet, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$GymDatabase extends GeneratedDatabase {
  _$GymDatabase(QueryExecutor e) : super(e);
  $GymDatabaseManager get managers => $GymDatabaseManager(this);
  late final $ExercisesTable exercises = $ExercisesTable(this);
  late final $SetEntriesTable setEntries = $SetEntriesTable(this);
  late final $WorkoutsTable workouts = $WorkoutsTable(this);
  late final $WorkoutStepsTable workoutSteps = $WorkoutStepsTable(this);
  late final $MultisetsTable multisets = $MultisetsTable(this);
  late final $MultisetExerciseConfigsTable multisetExerciseConfigs =
      $MultisetExerciseConfigsTable(this);
  late final $WorkoutGroupsTable workoutGroups = $WorkoutGroupsTable(this);
  late final $WorkoutSessionsTable workoutSessions =
      $WorkoutSessionsTable(this);
  late final $BodyWeightEntriesTable bodyWeightEntries =
      $BodyWeightEntriesTable(this);
  late final $ProgrammesTable programmes = $ProgrammesTable(this);
  late final $ProgrammeWorkoutsTable programmeWorkouts =
      $ProgrammeWorkoutsTable(this);
  late final $GymSettingsTableTable gymSettingsTable =
      $GymSettingsTableTable(this);
  late final WorkoutDao workoutDao = WorkoutDao(this as GymDatabase);
  late final ExerciseDao exerciseDao = ExerciseDao(this as GymDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        exercises,
        setEntries,
        workouts,
        workoutSteps,
        multisets,
        multisetExerciseConfigs,
        workoutGroups,
        workoutSessions,
        bodyWeightEntries,
        programmes,
        programmeWorkouts,
        gymSettingsTable
      ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('exercises',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('set_entries', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('workouts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('workout_steps', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('multisets',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('multiset_exercise_configs', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('exercises',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('multiset_exercise_configs', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('workouts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('workout_sessions', kind: UpdateKind.update),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('programmes',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('programme_workouts', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('workouts',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('programme_workouts', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$ExercisesTableCreateCompanionBuilder = ExercisesCompanion Function({
  Value<String> id,
  required String name,
  required List<MuscleGroup> primaryMuscles,
  required List<MuscleGroup> secondaryMuscles,
  Value<int> defaultFormulaIndex,
  Value<bool> oneRmEnabled,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$ExercisesTableUpdateCompanionBuilder = ExercisesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<List<MuscleGroup>> primaryMuscles,
  Value<List<MuscleGroup>> secondaryMuscles,
  Value<int> defaultFormulaIndex,
  Value<bool> oneRmEnabled,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$ExercisesTableReferences
    extends BaseReferences<_$GymDatabase, $ExercisesTable, Exercise> {
  $$ExercisesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SetEntriesTable, List<SetEntry>>
      _setEntriesRefsTable(_$GymDatabase db) => MultiTypedResultKey.fromTable(
          db.setEntries,
          aliasName:
              $_aliasNameGenerator(db.exercises.id, db.setEntries.exerciseId));

  $$SetEntriesTableProcessedTableManager get setEntriesRefs {
    final manager = $$SetEntriesTableTableManager($_db, $_db.setEntries)
        .filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_setEntriesRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$MultisetExerciseConfigsTable,
      List<MultisetExerciseConfig>> _multisetExerciseConfigsRefsTable(
          _$GymDatabase db) =>
      MultiTypedResultKey.fromTable(db.multisetExerciseConfigs,
          aliasName: $_aliasNameGenerator(
              db.exercises.id, db.multisetExerciseConfigs.exerciseId));

  $$MultisetExerciseConfigsTableProcessedTableManager
      get multisetExerciseConfigsRefs {
    final manager = $$MultisetExerciseConfigsTableTableManager(
            $_db, $_db.multisetExerciseConfigs)
        .filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_multisetExerciseConfigsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ExercisesTableFilterComposer
    extends Composer<_$GymDatabase, $ExercisesTable> {
  $$ExercisesTableFilterComposer({
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

  ColumnWithTypeConverterFilters<List<MuscleGroup>, List<MuscleGroup>, String>
      get primaryMuscles => $composableBuilder(
          column: $table.primaryMuscles,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnWithTypeConverterFilters<List<MuscleGroup>, List<MuscleGroup>, String>
      get secondaryMuscles => $composableBuilder(
          column: $table.secondaryMuscles,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<int> get defaultFormulaIndex => $composableBuilder(
      column: $table.defaultFormulaIndex,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get oneRmEnabled => $composableBuilder(
      column: $table.oneRmEnabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> setEntriesRefs(
      Expression<bool> Function($$SetEntriesTableFilterComposer f) f) {
    final $$SetEntriesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.setEntries,
        getReferencedColumn: (t) => t.exerciseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SetEntriesTableFilterComposer(
              $db: $db,
              $table: $db.setEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> multisetExerciseConfigsRefs(
      Expression<bool> Function($$MultisetExerciseConfigsTableFilterComposer f)
          f) {
    final $$MultisetExerciseConfigsTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.multisetExerciseConfigs,
            getReferencedColumn: (t) => t.exerciseId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MultisetExerciseConfigsTableFilterComposer(
                  $db: $db,
                  $table: $db.multisetExerciseConfigs,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$ExercisesTableOrderingComposer
    extends Composer<_$GymDatabase, $ExercisesTable> {
  $$ExercisesTableOrderingComposer({
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

  ColumnOrderings<String> get primaryMuscles => $composableBuilder(
      column: $table.primaryMuscles,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get secondaryMuscles => $composableBuilder(
      column: $table.secondaryMuscles,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get defaultFormulaIndex => $composableBuilder(
      column: $table.defaultFormulaIndex,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get oneRmEnabled => $composableBuilder(
      column: $table.oneRmEnabled,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ExercisesTableAnnotationComposer
    extends Composer<_$GymDatabase, $ExercisesTable> {
  $$ExercisesTableAnnotationComposer({
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

  GeneratedColumnWithTypeConverter<List<MuscleGroup>, String>
      get primaryMuscles => $composableBuilder(
          column: $table.primaryMuscles, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<MuscleGroup>, String>
      get secondaryMuscles => $composableBuilder(
          column: $table.secondaryMuscles, builder: (column) => column);

  GeneratedColumn<int> get defaultFormulaIndex => $composableBuilder(
      column: $table.defaultFormulaIndex, builder: (column) => column);

  GeneratedColumn<bool> get oneRmEnabled => $composableBuilder(
      column: $table.oneRmEnabled, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> setEntriesRefs<T extends Object>(
      Expression<T> Function($$SetEntriesTableAnnotationComposer a) f) {
    final $$SetEntriesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.setEntries,
        getReferencedColumn: (t) => t.exerciseId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SetEntriesTableAnnotationComposer(
              $db: $db,
              $table: $db.setEntries,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> multisetExerciseConfigsRefs<T extends Object>(
      Expression<T> Function($$MultisetExerciseConfigsTableAnnotationComposer a)
          f) {
    final $$MultisetExerciseConfigsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.multisetExerciseConfigs,
            getReferencedColumn: (t) => t.exerciseId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MultisetExerciseConfigsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.multisetExerciseConfigs,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$ExercisesTableTableManager extends RootTableManager<
    _$GymDatabase,
    $ExercisesTable,
    Exercise,
    $$ExercisesTableFilterComposer,
    $$ExercisesTableOrderingComposer,
    $$ExercisesTableAnnotationComposer,
    $$ExercisesTableCreateCompanionBuilder,
    $$ExercisesTableUpdateCompanionBuilder,
    (Exercise, $$ExercisesTableReferences),
    Exercise,
    PrefetchHooks Function(
        {bool setEntriesRefs, bool multisetExerciseConfigsRefs})> {
  $$ExercisesTableTableManager(_$GymDatabase db, $ExercisesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<List<MuscleGroup>> primaryMuscles = const Value.absent(),
            Value<List<MuscleGroup>> secondaryMuscles = const Value.absent(),
            Value<int> defaultFormulaIndex = const Value.absent(),
            Value<bool> oneRmEnabled = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExercisesCompanion(
            id: id,
            name: name,
            primaryMuscles: primaryMuscles,
            secondaryMuscles: secondaryMuscles,
            defaultFormulaIndex: defaultFormulaIndex,
            oneRmEnabled: oneRmEnabled,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String name,
            required List<MuscleGroup> primaryMuscles,
            required List<MuscleGroup> secondaryMuscles,
            Value<int> defaultFormulaIndex = const Value.absent(),
            Value<bool> oneRmEnabled = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExercisesCompanion.insert(
            id: id,
            name: name,
            primaryMuscles: primaryMuscles,
            secondaryMuscles: secondaryMuscles,
            defaultFormulaIndex: defaultFormulaIndex,
            oneRmEnabled: oneRmEnabled,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ExercisesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: (
              {setEntriesRefs = false, multisetExerciseConfigsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (setEntriesRefs) db.setEntries,
                if (multisetExerciseConfigsRefs) db.multisetExerciseConfigs
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (setEntriesRefs)
                    await $_getPrefetchedData<Exercise, $ExercisesTable,
                            SetEntry>(
                        currentTable: table,
                        referencedTable:
                            $$ExercisesTableReferences._setEntriesRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ExercisesTableReferences(db, table, p0)
                                .setEntriesRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.exerciseId == item.id),
                        typedResults: items),
                  if (multisetExerciseConfigsRefs)
                    await $_getPrefetchedData<Exercise, $ExercisesTable, MultisetExerciseConfig>(
                        currentTable: table,
                        referencedTable: $$ExercisesTableReferences
                            ._multisetExerciseConfigsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ExercisesTableReferences(db, table, p0)
                                .multisetExerciseConfigsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.exerciseId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ExercisesTableProcessedTableManager = ProcessedTableManager<
    _$GymDatabase,
    $ExercisesTable,
    Exercise,
    $$ExercisesTableFilterComposer,
    $$ExercisesTableOrderingComposer,
    $$ExercisesTableAnnotationComposer,
    $$ExercisesTableCreateCompanionBuilder,
    $$ExercisesTableUpdateCompanionBuilder,
    (Exercise, $$ExercisesTableReferences),
    Exercise,
    PrefetchHooks Function(
        {bool setEntriesRefs, bool multisetExerciseConfigsRefs})>;
typedef $$SetEntriesTableCreateCompanionBuilder = SetEntriesCompanion Function({
  Value<String> id,
  required String exerciseId,
  Value<String?> workoutSessionId,
  Value<String?> multisetId,
  required double weightKg,
  required int reps,
  Value<int> labelIndex,
  Value<DateTime> performedAt,
  Value<String?> note,
  Value<int?> restSecondsBefore,
  Value<int> rowid,
});
typedef $$SetEntriesTableUpdateCompanionBuilder = SetEntriesCompanion Function({
  Value<String> id,
  Value<String> exerciseId,
  Value<String?> workoutSessionId,
  Value<String?> multisetId,
  Value<double> weightKg,
  Value<int> reps,
  Value<int> labelIndex,
  Value<DateTime> performedAt,
  Value<String?> note,
  Value<int?> restSecondsBefore,
  Value<int> rowid,
});

final class $$SetEntriesTableReferences
    extends BaseReferences<_$GymDatabase, $SetEntriesTable, SetEntry> {
  $$SetEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ExercisesTable _exerciseIdTable(_$GymDatabase db) =>
      db.exercises.createAlias(
          $_aliasNameGenerator(db.setEntries.exerciseId, db.exercises.id));

  $$ExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<String>('exercise_id')!;

    final manager = $$ExercisesTableTableManager($_db, $_db.exercises)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$SetEntriesTableFilterComposer
    extends Composer<_$GymDatabase, $SetEntriesTable> {
  $$SetEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get workoutSessionId => $composableBuilder(
      column: $table.workoutSessionId,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get multisetId => $composableBuilder(
      column: $table.multisetId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get weightKg => $composableBuilder(
      column: $table.weightKg, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get reps => $composableBuilder(
      column: $table.reps, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get labelIndex => $composableBuilder(
      column: $table.labelIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get performedAt => $composableBuilder(
      column: $table.performedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get restSecondsBefore => $composableBuilder(
      column: $table.restSecondsBefore,
      builder: (column) => ColumnFilters(column));

  $$ExercisesTableFilterComposer get exerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.exerciseId,
        referencedTable: $db.exercises,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExercisesTableFilterComposer(
              $db: $db,
              $table: $db.exercises,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SetEntriesTableOrderingComposer
    extends Composer<_$GymDatabase, $SetEntriesTable> {
  $$SetEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get workoutSessionId => $composableBuilder(
      column: $table.workoutSessionId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get multisetId => $composableBuilder(
      column: $table.multisetId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get weightKg => $composableBuilder(
      column: $table.weightKg, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get reps => $composableBuilder(
      column: $table.reps, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get labelIndex => $composableBuilder(
      column: $table.labelIndex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get performedAt => $composableBuilder(
      column: $table.performedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get note => $composableBuilder(
      column: $table.note, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get restSecondsBefore => $composableBuilder(
      column: $table.restSecondsBefore,
      builder: (column) => ColumnOrderings(column));

  $$ExercisesTableOrderingComposer get exerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.exerciseId,
        referencedTable: $db.exercises,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExercisesTableOrderingComposer(
              $db: $db,
              $table: $db.exercises,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SetEntriesTableAnnotationComposer
    extends Composer<_$GymDatabase, $SetEntriesTable> {
  $$SetEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get workoutSessionId => $composableBuilder(
      column: $table.workoutSessionId, builder: (column) => column);

  GeneratedColumn<String> get multisetId => $composableBuilder(
      column: $table.multisetId, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<int> get labelIndex => $composableBuilder(
      column: $table.labelIndex, builder: (column) => column);

  GeneratedColumn<DateTime> get performedAt => $composableBuilder(
      column: $table.performedAt, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get restSecondsBefore => $composableBuilder(
      column: $table.restSecondsBefore, builder: (column) => column);

  $$ExercisesTableAnnotationComposer get exerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.exerciseId,
        referencedTable: $db.exercises,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExercisesTableAnnotationComposer(
              $db: $db,
              $table: $db.exercises,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SetEntriesTableTableManager extends RootTableManager<
    _$GymDatabase,
    $SetEntriesTable,
    SetEntry,
    $$SetEntriesTableFilterComposer,
    $$SetEntriesTableOrderingComposer,
    $$SetEntriesTableAnnotationComposer,
    $$SetEntriesTableCreateCompanionBuilder,
    $$SetEntriesTableUpdateCompanionBuilder,
    (SetEntry, $$SetEntriesTableReferences),
    SetEntry,
    PrefetchHooks Function({bool exerciseId})> {
  $$SetEntriesTableTableManager(_$GymDatabase db, $SetEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SetEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SetEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SetEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> exerciseId = const Value.absent(),
            Value<String?> workoutSessionId = const Value.absent(),
            Value<String?> multisetId = const Value.absent(),
            Value<double> weightKg = const Value.absent(),
            Value<int> reps = const Value.absent(),
            Value<int> labelIndex = const Value.absent(),
            Value<DateTime> performedAt = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<int?> restSecondsBefore = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SetEntriesCompanion(
            id: id,
            exerciseId: exerciseId,
            workoutSessionId: workoutSessionId,
            multisetId: multisetId,
            weightKg: weightKg,
            reps: reps,
            labelIndex: labelIndex,
            performedAt: performedAt,
            note: note,
            restSecondsBefore: restSecondsBefore,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String exerciseId,
            Value<String?> workoutSessionId = const Value.absent(),
            Value<String?> multisetId = const Value.absent(),
            required double weightKg,
            required int reps,
            Value<int> labelIndex = const Value.absent(),
            Value<DateTime> performedAt = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<int?> restSecondsBefore = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SetEntriesCompanion.insert(
            id: id,
            exerciseId: exerciseId,
            workoutSessionId: workoutSessionId,
            multisetId: multisetId,
            weightKg: weightKg,
            reps: reps,
            labelIndex: labelIndex,
            performedAt: performedAt,
            note: note,
            restSecondsBefore: restSecondsBefore,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SetEntriesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({exerciseId = false}) {
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
                if (exerciseId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.exerciseId,
                    referencedTable:
                        $$SetEntriesTableReferences._exerciseIdTable(db),
                    referencedColumn:
                        $$SetEntriesTableReferences._exerciseIdTable(db).id,
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

typedef $$SetEntriesTableProcessedTableManager = ProcessedTableManager<
    _$GymDatabase,
    $SetEntriesTable,
    SetEntry,
    $$SetEntriesTableFilterComposer,
    $$SetEntriesTableOrderingComposer,
    $$SetEntriesTableAnnotationComposer,
    $$SetEntriesTableCreateCompanionBuilder,
    $$SetEntriesTableUpdateCompanionBuilder,
    (SetEntry, $$SetEntriesTableReferences),
    SetEntry,
    PrefetchHooks Function({bool exerciseId})>;
typedef $$WorkoutsTableCreateCompanionBuilder = WorkoutsCompanion Function({
  Value<String> id,
  required String name,
  Value<String?> description,
  Value<String?> groupId,
  Value<int> sortIndex,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$WorkoutsTableUpdateCompanionBuilder = WorkoutsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> description,
  Value<String?> groupId,
  Value<int> sortIndex,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$WorkoutsTableReferences
    extends BaseReferences<_$GymDatabase, $WorkoutsTable, Workout> {
  $$WorkoutsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$WorkoutStepsTable, List<WorkoutStep>>
      _workoutStepsRefsTable(_$GymDatabase db) => MultiTypedResultKey.fromTable(
          db.workoutSteps,
          aliasName:
              $_aliasNameGenerator(db.workouts.id, db.workoutSteps.workoutId));

  $$WorkoutStepsTableProcessedTableManager get workoutStepsRefs {
    final manager = $$WorkoutStepsTableTableManager($_db, $_db.workoutSteps)
        .filter((f) => f.workoutId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_workoutStepsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$WorkoutSessionsTable, List<WorkoutSession>>
      _workoutSessionsRefsTable(_$GymDatabase db) =>
          MultiTypedResultKey.fromTable(db.workoutSessions,
              aliasName: $_aliasNameGenerator(
                  db.workouts.id, db.workoutSessions.workoutId));

  $$WorkoutSessionsTableProcessedTableManager get workoutSessionsRefs {
    final manager = $$WorkoutSessionsTableTableManager(
            $_db, $_db.workoutSessions)
        .filter((f) => f.workoutId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_workoutSessionsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }

  static MultiTypedResultKey<$ProgrammeWorkoutsTable, List<ProgrammeWorkout>>
      _programmeWorkoutsRefsTable(_$GymDatabase db) =>
          MultiTypedResultKey.fromTable(db.programmeWorkouts,
              aliasName: $_aliasNameGenerator(
                  db.workouts.id, db.programmeWorkouts.workoutId));

  $$ProgrammeWorkoutsTableProcessedTableManager get programmeWorkoutsRefs {
    final manager = $$ProgrammeWorkoutsTableTableManager(
            $_db, $_db.programmeWorkouts)
        .filter((f) => f.workoutId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_programmeWorkoutsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$WorkoutsTableFilterComposer
    extends Composer<_$GymDatabase, $WorkoutsTable> {
  $$WorkoutsTableFilterComposer({
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

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get groupId => $composableBuilder(
      column: $table.groupId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sortIndex => $composableBuilder(
      column: $table.sortIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> workoutStepsRefs(
      Expression<bool> Function($$WorkoutStepsTableFilterComposer f) f) {
    final $$WorkoutStepsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.workoutSteps,
        getReferencedColumn: (t) => t.workoutId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutStepsTableFilterComposer(
              $db: $db,
              $table: $db.workoutSteps,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> workoutSessionsRefs(
      Expression<bool> Function($$WorkoutSessionsTableFilterComposer f) f) {
    final $$WorkoutSessionsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.workoutSessions,
        getReferencedColumn: (t) => t.workoutId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutSessionsTableFilterComposer(
              $db: $db,
              $table: $db.workoutSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<bool> programmeWorkoutsRefs(
      Expression<bool> Function($$ProgrammeWorkoutsTableFilterComposer f) f) {
    final $$ProgrammeWorkoutsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.programmeWorkouts,
        getReferencedColumn: (t) => t.workoutId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProgrammeWorkoutsTableFilterComposer(
              $db: $db,
              $table: $db.programmeWorkouts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$WorkoutsTableOrderingComposer
    extends Composer<_$GymDatabase, $WorkoutsTable> {
  $$WorkoutsTableOrderingComposer({
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

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get groupId => $composableBuilder(
      column: $table.groupId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sortIndex => $composableBuilder(
      column: $table.sortIndex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$WorkoutsTableAnnotationComposer
    extends Composer<_$GymDatabase, $WorkoutsTable> {
  $$WorkoutsTableAnnotationComposer({
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

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get groupId =>
      $composableBuilder(column: $table.groupId, builder: (column) => column);

  GeneratedColumn<int> get sortIndex =>
      $composableBuilder(column: $table.sortIndex, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> workoutStepsRefs<T extends Object>(
      Expression<T> Function($$WorkoutStepsTableAnnotationComposer a) f) {
    final $$WorkoutStepsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.workoutSteps,
        getReferencedColumn: (t) => t.workoutId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutStepsTableAnnotationComposer(
              $db: $db,
              $table: $db.workoutSteps,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> workoutSessionsRefs<T extends Object>(
      Expression<T> Function($$WorkoutSessionsTableAnnotationComposer a) f) {
    final $$WorkoutSessionsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.workoutSessions,
        getReferencedColumn: (t) => t.workoutId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutSessionsTableAnnotationComposer(
              $db: $db,
              $table: $db.workoutSessions,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }

  Expression<T> programmeWorkoutsRefs<T extends Object>(
      Expression<T> Function($$ProgrammeWorkoutsTableAnnotationComposer a) f) {
    final $$ProgrammeWorkoutsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.programmeWorkouts,
            getReferencedColumn: (t) => t.workoutId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ProgrammeWorkoutsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.programmeWorkouts,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$WorkoutsTableTableManager extends RootTableManager<
    _$GymDatabase,
    $WorkoutsTable,
    Workout,
    $$WorkoutsTableFilterComposer,
    $$WorkoutsTableOrderingComposer,
    $$WorkoutsTableAnnotationComposer,
    $$WorkoutsTableCreateCompanionBuilder,
    $$WorkoutsTableUpdateCompanionBuilder,
    (Workout, $$WorkoutsTableReferences),
    Workout,
    PrefetchHooks Function(
        {bool workoutStepsRefs,
        bool workoutSessionsRefs,
        bool programmeWorkoutsRefs})> {
  $$WorkoutsTableTableManager(_$GymDatabase db, $WorkoutsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String?> groupId = const Value.absent(),
            Value<int> sortIndex = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkoutsCompanion(
            id: id,
            name: name,
            description: description,
            groupId: groupId,
            sortIndex: sortIndex,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String name,
            Value<String?> description = const Value.absent(),
            Value<String?> groupId = const Value.absent(),
            Value<int> sortIndex = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkoutsCompanion.insert(
            id: id,
            name: name,
            description: description,
            groupId: groupId,
            sortIndex: sortIndex,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$WorkoutsTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {workoutStepsRefs = false,
              workoutSessionsRefs = false,
              programmeWorkoutsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (workoutStepsRefs) db.workoutSteps,
                if (workoutSessionsRefs) db.workoutSessions,
                if (programmeWorkoutsRefs) db.programmeWorkouts
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (workoutStepsRefs)
                    await $_getPrefetchedData<Workout, $WorkoutsTable,
                            WorkoutStep>(
                        currentTable: table,
                        referencedTable: $$WorkoutsTableReferences
                            ._workoutStepsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WorkoutsTableReferences(db, table, p0)
                                .workoutStepsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.workoutId == item.id),
                        typedResults: items),
                  if (workoutSessionsRefs)
                    await $_getPrefetchedData<Workout, $WorkoutsTable,
                            WorkoutSession>(
                        currentTable: table,
                        referencedTable: $$WorkoutsTableReferences
                            ._workoutSessionsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WorkoutsTableReferences(db, table, p0)
                                .workoutSessionsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.workoutId == item.id),
                        typedResults: items),
                  if (programmeWorkoutsRefs)
                    await $_getPrefetchedData<Workout, $WorkoutsTable,
                            ProgrammeWorkout>(
                        currentTable: table,
                        referencedTable: $$WorkoutsTableReferences
                            ._programmeWorkoutsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$WorkoutsTableReferences(db, table, p0)
                                .programmeWorkoutsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.workoutId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$WorkoutsTableProcessedTableManager = ProcessedTableManager<
    _$GymDatabase,
    $WorkoutsTable,
    Workout,
    $$WorkoutsTableFilterComposer,
    $$WorkoutsTableOrderingComposer,
    $$WorkoutsTableAnnotationComposer,
    $$WorkoutsTableCreateCompanionBuilder,
    $$WorkoutsTableUpdateCompanionBuilder,
    (Workout, $$WorkoutsTableReferences),
    Workout,
    PrefetchHooks Function(
        {bool workoutStepsRefs,
        bool workoutSessionsRefs,
        bool programmeWorkoutsRefs})>;
typedef $$WorkoutStepsTableCreateCompanionBuilder = WorkoutStepsCompanion
    Function({
  Value<String> id,
  required String workoutId,
  required int stepType,
  required String refId,
  required int stepOrder,
  Value<int> rowid,
});
typedef $$WorkoutStepsTableUpdateCompanionBuilder = WorkoutStepsCompanion
    Function({
  Value<String> id,
  Value<String> workoutId,
  Value<int> stepType,
  Value<String> refId,
  Value<int> stepOrder,
  Value<int> rowid,
});

final class $$WorkoutStepsTableReferences
    extends BaseReferences<_$GymDatabase, $WorkoutStepsTable, WorkoutStep> {
  $$WorkoutStepsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WorkoutsTable _workoutIdTable(_$GymDatabase db) =>
      db.workouts.createAlias(
          $_aliasNameGenerator(db.workoutSteps.workoutId, db.workouts.id));

  $$WorkoutsTableProcessedTableManager get workoutId {
    final $_column = $_itemColumn<String>('workout_id')!;

    final manager = $$WorkoutsTableTableManager($_db, $_db.workouts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workoutIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$WorkoutStepsTableFilterComposer
    extends Composer<_$GymDatabase, $WorkoutStepsTable> {
  $$WorkoutStepsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get stepType => $composableBuilder(
      column: $table.stepType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get refId => $composableBuilder(
      column: $table.refId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get stepOrder => $composableBuilder(
      column: $table.stepOrder, builder: (column) => ColumnFilters(column));

  $$WorkoutsTableFilterComposer get workoutId {
    final $$WorkoutsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.workoutId,
        referencedTable: $db.workouts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutsTableFilterComposer(
              $db: $db,
              $table: $db.workouts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WorkoutStepsTableOrderingComposer
    extends Composer<_$GymDatabase, $WorkoutStepsTable> {
  $$WorkoutStepsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get stepType => $composableBuilder(
      column: $table.stepType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get refId => $composableBuilder(
      column: $table.refId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get stepOrder => $composableBuilder(
      column: $table.stepOrder, builder: (column) => ColumnOrderings(column));

  $$WorkoutsTableOrderingComposer get workoutId {
    final $$WorkoutsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.workoutId,
        referencedTable: $db.workouts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutsTableOrderingComposer(
              $db: $db,
              $table: $db.workouts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WorkoutStepsTableAnnotationComposer
    extends Composer<_$GymDatabase, $WorkoutStepsTable> {
  $$WorkoutStepsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get stepType =>
      $composableBuilder(column: $table.stepType, builder: (column) => column);

  GeneratedColumn<String> get refId =>
      $composableBuilder(column: $table.refId, builder: (column) => column);

  GeneratedColumn<int> get stepOrder =>
      $composableBuilder(column: $table.stepOrder, builder: (column) => column);

  $$WorkoutsTableAnnotationComposer get workoutId {
    final $$WorkoutsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.workoutId,
        referencedTable: $db.workouts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutsTableAnnotationComposer(
              $db: $db,
              $table: $db.workouts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WorkoutStepsTableTableManager extends RootTableManager<
    _$GymDatabase,
    $WorkoutStepsTable,
    WorkoutStep,
    $$WorkoutStepsTableFilterComposer,
    $$WorkoutStepsTableOrderingComposer,
    $$WorkoutStepsTableAnnotationComposer,
    $$WorkoutStepsTableCreateCompanionBuilder,
    $$WorkoutStepsTableUpdateCompanionBuilder,
    (WorkoutStep, $$WorkoutStepsTableReferences),
    WorkoutStep,
    PrefetchHooks Function({bool workoutId})> {
  $$WorkoutStepsTableTableManager(_$GymDatabase db, $WorkoutStepsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutStepsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutStepsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutStepsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> workoutId = const Value.absent(),
            Value<int> stepType = const Value.absent(),
            Value<String> refId = const Value.absent(),
            Value<int> stepOrder = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkoutStepsCompanion(
            id: id,
            workoutId: workoutId,
            stepType: stepType,
            refId: refId,
            stepOrder: stepOrder,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String workoutId,
            required int stepType,
            required String refId,
            required int stepOrder,
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkoutStepsCompanion.insert(
            id: id,
            workoutId: workoutId,
            stepType: stepType,
            refId: refId,
            stepOrder: stepOrder,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$WorkoutStepsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({workoutId = false}) {
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
                if (workoutId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.workoutId,
                    referencedTable:
                        $$WorkoutStepsTableReferences._workoutIdTable(db),
                    referencedColumn:
                        $$WorkoutStepsTableReferences._workoutIdTable(db).id,
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

typedef $$WorkoutStepsTableProcessedTableManager = ProcessedTableManager<
    _$GymDatabase,
    $WorkoutStepsTable,
    WorkoutStep,
    $$WorkoutStepsTableFilterComposer,
    $$WorkoutStepsTableOrderingComposer,
    $$WorkoutStepsTableAnnotationComposer,
    $$WorkoutStepsTableCreateCompanionBuilder,
    $$WorkoutStepsTableUpdateCompanionBuilder,
    (WorkoutStep, $$WorkoutStepsTableReferences),
    WorkoutStep,
    PrefetchHooks Function({bool workoutId})>;
typedef $$MultisetsTableCreateCompanionBuilder = MultisetsCompanion Function({
  Value<String> id,
  required int templateIndex,
  Value<String?> name,
  Value<int> sets,
  Value<bool> restBetweenIsDefault,
  Value<int?> restBetweenSeconds,
  Value<bool> hasRestAfter,
  Value<int?> restAfterSeconds,
  Value<bool> checkOffEachSet,
  required int iconIndex,
  Value<int> rowid,
});
typedef $$MultisetsTableUpdateCompanionBuilder = MultisetsCompanion Function({
  Value<String> id,
  Value<int> templateIndex,
  Value<String?> name,
  Value<int> sets,
  Value<bool> restBetweenIsDefault,
  Value<int?> restBetweenSeconds,
  Value<bool> hasRestAfter,
  Value<int?> restAfterSeconds,
  Value<bool> checkOffEachSet,
  Value<int> iconIndex,
  Value<int> rowid,
});

final class $$MultisetsTableReferences
    extends BaseReferences<_$GymDatabase, $MultisetsTable, Multiset> {
  $$MultisetsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MultisetExerciseConfigsTable,
      List<MultisetExerciseConfig>> _multisetExerciseConfigsRefsTable(
          _$GymDatabase db) =>
      MultiTypedResultKey.fromTable(db.multisetExerciseConfigs,
          aliasName: $_aliasNameGenerator(
              db.multisets.id, db.multisetExerciseConfigs.multisetId));

  $$MultisetExerciseConfigsTableProcessedTableManager
      get multisetExerciseConfigsRefs {
    final manager = $$MultisetExerciseConfigsTableTableManager(
            $_db, $_db.multisetExerciseConfigs)
        .filter((f) => f.multisetId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_multisetExerciseConfigsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$MultisetsTableFilterComposer
    extends Composer<_$GymDatabase, $MultisetsTable> {
  $$MultisetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get templateIndex => $composableBuilder(
      column: $table.templateIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sets => $composableBuilder(
      column: $table.sets, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get restBetweenIsDefault => $composableBuilder(
      column: $table.restBetweenIsDefault,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get restBetweenSeconds => $composableBuilder(
      column: $table.restBetweenSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get hasRestAfter => $composableBuilder(
      column: $table.hasRestAfter, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get restAfterSeconds => $composableBuilder(
      column: $table.restAfterSeconds,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get checkOffEachSet => $composableBuilder(
      column: $table.checkOffEachSet,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get iconIndex => $composableBuilder(
      column: $table.iconIndex, builder: (column) => ColumnFilters(column));

  Expression<bool> multisetExerciseConfigsRefs(
      Expression<bool> Function($$MultisetExerciseConfigsTableFilterComposer f)
          f) {
    final $$MultisetExerciseConfigsTableFilterComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.multisetExerciseConfigs,
            getReferencedColumn: (t) => t.multisetId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MultisetExerciseConfigsTableFilterComposer(
                  $db: $db,
                  $table: $db.multisetExerciseConfigs,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$MultisetsTableOrderingComposer
    extends Composer<_$GymDatabase, $MultisetsTable> {
  $$MultisetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get templateIndex => $composableBuilder(
      column: $table.templateIndex,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sets => $composableBuilder(
      column: $table.sets, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get restBetweenIsDefault => $composableBuilder(
      column: $table.restBetweenIsDefault,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get restBetweenSeconds => $composableBuilder(
      column: $table.restBetweenSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get hasRestAfter => $composableBuilder(
      column: $table.hasRestAfter,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get restAfterSeconds => $composableBuilder(
      column: $table.restAfterSeconds,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get checkOffEachSet => $composableBuilder(
      column: $table.checkOffEachSet,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get iconIndex => $composableBuilder(
      column: $table.iconIndex, builder: (column) => ColumnOrderings(column));
}

class $$MultisetsTableAnnotationComposer
    extends Composer<_$GymDatabase, $MultisetsTable> {
  $$MultisetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get templateIndex => $composableBuilder(
      column: $table.templateIndex, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get sets =>
      $composableBuilder(column: $table.sets, builder: (column) => column);

  GeneratedColumn<bool> get restBetweenIsDefault => $composableBuilder(
      column: $table.restBetweenIsDefault, builder: (column) => column);

  GeneratedColumn<int> get restBetweenSeconds => $composableBuilder(
      column: $table.restBetweenSeconds, builder: (column) => column);

  GeneratedColumn<bool> get hasRestAfter => $composableBuilder(
      column: $table.hasRestAfter, builder: (column) => column);

  GeneratedColumn<int> get restAfterSeconds => $composableBuilder(
      column: $table.restAfterSeconds, builder: (column) => column);

  GeneratedColumn<bool> get checkOffEachSet => $composableBuilder(
      column: $table.checkOffEachSet, builder: (column) => column);

  GeneratedColumn<int> get iconIndex =>
      $composableBuilder(column: $table.iconIndex, builder: (column) => column);

  Expression<T> multisetExerciseConfigsRefs<T extends Object>(
      Expression<T> Function($$MultisetExerciseConfigsTableAnnotationComposer a)
          f) {
    final $$MultisetExerciseConfigsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.multisetExerciseConfigs,
            getReferencedColumn: (t) => t.multisetId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$MultisetExerciseConfigsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.multisetExerciseConfigs,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$MultisetsTableTableManager extends RootTableManager<
    _$GymDatabase,
    $MultisetsTable,
    Multiset,
    $$MultisetsTableFilterComposer,
    $$MultisetsTableOrderingComposer,
    $$MultisetsTableAnnotationComposer,
    $$MultisetsTableCreateCompanionBuilder,
    $$MultisetsTableUpdateCompanionBuilder,
    (Multiset, $$MultisetsTableReferences),
    Multiset,
    PrefetchHooks Function({bool multisetExerciseConfigsRefs})> {
  $$MultisetsTableTableManager(_$GymDatabase db, $MultisetsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MultisetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MultisetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MultisetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<int> templateIndex = const Value.absent(),
            Value<String?> name = const Value.absent(),
            Value<int> sets = const Value.absent(),
            Value<bool> restBetweenIsDefault = const Value.absent(),
            Value<int?> restBetweenSeconds = const Value.absent(),
            Value<bool> hasRestAfter = const Value.absent(),
            Value<int?> restAfterSeconds = const Value.absent(),
            Value<bool> checkOffEachSet = const Value.absent(),
            Value<int> iconIndex = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MultisetsCompanion(
            id: id,
            templateIndex: templateIndex,
            name: name,
            sets: sets,
            restBetweenIsDefault: restBetweenIsDefault,
            restBetweenSeconds: restBetweenSeconds,
            hasRestAfter: hasRestAfter,
            restAfterSeconds: restAfterSeconds,
            checkOffEachSet: checkOffEachSet,
            iconIndex: iconIndex,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required int templateIndex,
            Value<String?> name = const Value.absent(),
            Value<int> sets = const Value.absent(),
            Value<bool> restBetweenIsDefault = const Value.absent(),
            Value<int?> restBetweenSeconds = const Value.absent(),
            Value<bool> hasRestAfter = const Value.absent(),
            Value<int?> restAfterSeconds = const Value.absent(),
            Value<bool> checkOffEachSet = const Value.absent(),
            required int iconIndex,
            Value<int> rowid = const Value.absent(),
          }) =>
              MultisetsCompanion.insert(
            id: id,
            templateIndex: templateIndex,
            name: name,
            sets: sets,
            restBetweenIsDefault: restBetweenIsDefault,
            restBetweenSeconds: restBetweenSeconds,
            hasRestAfter: hasRestAfter,
            restAfterSeconds: restAfterSeconds,
            checkOffEachSet: checkOffEachSet,
            iconIndex: iconIndex,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MultisetsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({multisetExerciseConfigsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (multisetExerciseConfigsRefs) db.multisetExerciseConfigs
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (multisetExerciseConfigsRefs)
                    await $_getPrefetchedData<Multiset, $MultisetsTable, MultisetExerciseConfig>(
                        currentTable: table,
                        referencedTable: $$MultisetsTableReferences
                            ._multisetExerciseConfigsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MultisetsTableReferences(db, table, p0)
                                .multisetExerciseConfigsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.multisetId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$MultisetsTableProcessedTableManager = ProcessedTableManager<
    _$GymDatabase,
    $MultisetsTable,
    Multiset,
    $$MultisetsTableFilterComposer,
    $$MultisetsTableOrderingComposer,
    $$MultisetsTableAnnotationComposer,
    $$MultisetsTableCreateCompanionBuilder,
    $$MultisetsTableUpdateCompanionBuilder,
    (Multiset, $$MultisetsTableReferences),
    Multiset,
    PrefetchHooks Function({bool multisetExerciseConfigsRefs})>;
typedef $$MultisetExerciseConfigsTableCreateCompanionBuilder
    = MultisetExerciseConfigsCompanion Function({
  Value<String> id,
  required String multisetId,
  required String exerciseId,
  required int orderIndex,
  Value<int> rowid,
});
typedef $$MultisetExerciseConfigsTableUpdateCompanionBuilder
    = MultisetExerciseConfigsCompanion Function({
  Value<String> id,
  Value<String> multisetId,
  Value<String> exerciseId,
  Value<int> orderIndex,
  Value<int> rowid,
});

final class $$MultisetExerciseConfigsTableReferences extends BaseReferences<
    _$GymDatabase, $MultisetExerciseConfigsTable, MultisetExerciseConfig> {
  $$MultisetExerciseConfigsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $MultisetsTable _multisetIdTable(_$GymDatabase db) =>
      db.multisets.createAlias($_aliasNameGenerator(
          db.multisetExerciseConfigs.multisetId, db.multisets.id));

  $$MultisetsTableProcessedTableManager get multisetId {
    final $_column = $_itemColumn<String>('multiset_id')!;

    final manager = $$MultisetsTableTableManager($_db, $_db.multisets)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_multisetIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $ExercisesTable _exerciseIdTable(_$GymDatabase db) =>
      db.exercises.createAlias($_aliasNameGenerator(
          db.multisetExerciseConfigs.exerciseId, db.exercises.id));

  $$ExercisesTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<String>('exercise_id')!;

    final manager = $$ExercisesTableTableManager($_db, $_db.exercises)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$MultisetExerciseConfigsTableFilterComposer
    extends Composer<_$GymDatabase, $MultisetExerciseConfigsTable> {
  $$MultisetExerciseConfigsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => ColumnFilters(column));

  $$MultisetsTableFilterComposer get multisetId {
    final $$MultisetsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.multisetId,
        referencedTable: $db.multisets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MultisetsTableFilterComposer(
              $db: $db,
              $table: $db.multisets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ExercisesTableFilterComposer get exerciseId {
    final $$ExercisesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.exerciseId,
        referencedTable: $db.exercises,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExercisesTableFilterComposer(
              $db: $db,
              $table: $db.exercises,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MultisetExerciseConfigsTableOrderingComposer
    extends Composer<_$GymDatabase, $MultisetExerciseConfigsTable> {
  $$MultisetExerciseConfigsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => ColumnOrderings(column));

  $$MultisetsTableOrderingComposer get multisetId {
    final $$MultisetsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.multisetId,
        referencedTable: $db.multisets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MultisetsTableOrderingComposer(
              $db: $db,
              $table: $db.multisets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ExercisesTableOrderingComposer get exerciseId {
    final $$ExercisesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.exerciseId,
        referencedTable: $db.exercises,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExercisesTableOrderingComposer(
              $db: $db,
              $table: $db.exercises,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MultisetExerciseConfigsTableAnnotationComposer
    extends Composer<_$GymDatabase, $MultisetExerciseConfigsTable> {
  $$MultisetExerciseConfigsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
      column: $table.orderIndex, builder: (column) => column);

  $$MultisetsTableAnnotationComposer get multisetId {
    final $$MultisetsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.multisetId,
        referencedTable: $db.multisets,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MultisetsTableAnnotationComposer(
              $db: $db,
              $table: $db.multisets,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$ExercisesTableAnnotationComposer get exerciseId {
    final $$ExercisesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.exerciseId,
        referencedTable: $db.exercises,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ExercisesTableAnnotationComposer(
              $db: $db,
              $table: $db.exercises,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$MultisetExerciseConfigsTableTableManager extends RootTableManager<
    _$GymDatabase,
    $MultisetExerciseConfigsTable,
    MultisetExerciseConfig,
    $$MultisetExerciseConfigsTableFilterComposer,
    $$MultisetExerciseConfigsTableOrderingComposer,
    $$MultisetExerciseConfigsTableAnnotationComposer,
    $$MultisetExerciseConfigsTableCreateCompanionBuilder,
    $$MultisetExerciseConfigsTableUpdateCompanionBuilder,
    (MultisetExerciseConfig, $$MultisetExerciseConfigsTableReferences),
    MultisetExerciseConfig,
    PrefetchHooks Function({bool multisetId, bool exerciseId})> {
  $$MultisetExerciseConfigsTableTableManager(
      _$GymDatabase db, $MultisetExerciseConfigsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MultisetExerciseConfigsTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$MultisetExerciseConfigsTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MultisetExerciseConfigsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> multisetId = const Value.absent(),
            Value<String> exerciseId = const Value.absent(),
            Value<int> orderIndex = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MultisetExerciseConfigsCompanion(
            id: id,
            multisetId: multisetId,
            exerciseId: exerciseId,
            orderIndex: orderIndex,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String multisetId,
            required String exerciseId,
            required int orderIndex,
            Value<int> rowid = const Value.absent(),
          }) =>
              MultisetExerciseConfigsCompanion.insert(
            id: id,
            multisetId: multisetId,
            exerciseId: exerciseId,
            orderIndex: orderIndex,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MultisetExerciseConfigsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({multisetId = false, exerciseId = false}) {
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
                if (multisetId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.multisetId,
                    referencedTable: $$MultisetExerciseConfigsTableReferences
                        ._multisetIdTable(db),
                    referencedColumn: $$MultisetExerciseConfigsTableReferences
                        ._multisetIdTable(db)
                        .id,
                  ) as T;
                }
                if (exerciseId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.exerciseId,
                    referencedTable: $$MultisetExerciseConfigsTableReferences
                        ._exerciseIdTable(db),
                    referencedColumn: $$MultisetExerciseConfigsTableReferences
                        ._exerciseIdTable(db)
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

typedef $$MultisetExerciseConfigsTableProcessedTableManager
    = ProcessedTableManager<
        _$GymDatabase,
        $MultisetExerciseConfigsTable,
        MultisetExerciseConfig,
        $$MultisetExerciseConfigsTableFilterComposer,
        $$MultisetExerciseConfigsTableOrderingComposer,
        $$MultisetExerciseConfigsTableAnnotationComposer,
        $$MultisetExerciseConfigsTableCreateCompanionBuilder,
        $$MultisetExerciseConfigsTableUpdateCompanionBuilder,
        (MultisetExerciseConfig, $$MultisetExerciseConfigsTableReferences),
        MultisetExerciseConfig,
        PrefetchHooks Function({bool multisetId, bool exerciseId})>;
typedef $$WorkoutGroupsTableCreateCompanionBuilder = WorkoutGroupsCompanion
    Function({
  Value<String> id,
  required String name,
  Value<String?> description,
  Value<int> colorIndex,
  Value<int> rowid,
});
typedef $$WorkoutGroupsTableUpdateCompanionBuilder = WorkoutGroupsCompanion
    Function({
  Value<String> id,
  Value<String> name,
  Value<String?> description,
  Value<int> colorIndex,
  Value<int> rowid,
});

class $$WorkoutGroupsTableFilterComposer
    extends Composer<_$GymDatabase, $WorkoutGroupsTable> {
  $$WorkoutGroupsTableFilterComposer({
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

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get colorIndex => $composableBuilder(
      column: $table.colorIndex, builder: (column) => ColumnFilters(column));
}

class $$WorkoutGroupsTableOrderingComposer
    extends Composer<_$GymDatabase, $WorkoutGroupsTable> {
  $$WorkoutGroupsTableOrderingComposer({
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

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get colorIndex => $composableBuilder(
      column: $table.colorIndex, builder: (column) => ColumnOrderings(column));
}

class $$WorkoutGroupsTableAnnotationComposer
    extends Composer<_$GymDatabase, $WorkoutGroupsTable> {
  $$WorkoutGroupsTableAnnotationComposer({
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

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<int> get colorIndex => $composableBuilder(
      column: $table.colorIndex, builder: (column) => column);
}

class $$WorkoutGroupsTableTableManager extends RootTableManager<
    _$GymDatabase,
    $WorkoutGroupsTable,
    WorkoutGroup,
    $$WorkoutGroupsTableFilterComposer,
    $$WorkoutGroupsTableOrderingComposer,
    $$WorkoutGroupsTableAnnotationComposer,
    $$WorkoutGroupsTableCreateCompanionBuilder,
    $$WorkoutGroupsTableUpdateCompanionBuilder,
    (
      WorkoutGroup,
      BaseReferences<_$GymDatabase, $WorkoutGroupsTable, WorkoutGroup>
    ),
    WorkoutGroup,
    PrefetchHooks Function()> {
  $$WorkoutGroupsTableTableManager(_$GymDatabase db, $WorkoutGroupsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutGroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutGroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutGroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<int> colorIndex = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkoutGroupsCompanion(
            id: id,
            name: name,
            description: description,
            colorIndex: colorIndex,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String name,
            Value<String?> description = const Value.absent(),
            Value<int> colorIndex = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkoutGroupsCompanion.insert(
            id: id,
            name: name,
            description: description,
            colorIndex: colorIndex,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$WorkoutGroupsTableProcessedTableManager = ProcessedTableManager<
    _$GymDatabase,
    $WorkoutGroupsTable,
    WorkoutGroup,
    $$WorkoutGroupsTableFilterComposer,
    $$WorkoutGroupsTableOrderingComposer,
    $$WorkoutGroupsTableAnnotationComposer,
    $$WorkoutGroupsTableCreateCompanionBuilder,
    $$WorkoutGroupsTableUpdateCompanionBuilder,
    (
      WorkoutGroup,
      BaseReferences<_$GymDatabase, $WorkoutGroupsTable, WorkoutGroup>
    ),
    WorkoutGroup,
    PrefetchHooks Function()>;
typedef $$WorkoutSessionsTableCreateCompanionBuilder = WorkoutSessionsCompanion
    Function({
  Value<String> id,
  Value<String?> workoutId,
  Value<DateTime> date,
  Value<int?> durationSeconds,
  Value<int> rowid,
});
typedef $$WorkoutSessionsTableUpdateCompanionBuilder = WorkoutSessionsCompanion
    Function({
  Value<String> id,
  Value<String?> workoutId,
  Value<DateTime> date,
  Value<int?> durationSeconds,
  Value<int> rowid,
});

final class $$WorkoutSessionsTableReferences extends BaseReferences<
    _$GymDatabase, $WorkoutSessionsTable, WorkoutSession> {
  $$WorkoutSessionsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $WorkoutsTable _workoutIdTable(_$GymDatabase db) =>
      db.workouts.createAlias(
          $_aliasNameGenerator(db.workoutSessions.workoutId, db.workouts.id));

  $$WorkoutsTableProcessedTableManager? get workoutId {
    final $_column = $_itemColumn<String>('workout_id');
    if ($_column == null) return null;
    final manager = $$WorkoutsTableTableManager($_db, $_db.workouts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workoutIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$WorkoutSessionsTableFilterComposer
    extends Composer<_$GymDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds,
      builder: (column) => ColumnFilters(column));

  $$WorkoutsTableFilterComposer get workoutId {
    final $$WorkoutsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.workoutId,
        referencedTable: $db.workouts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutsTableFilterComposer(
              $db: $db,
              $table: $db.workouts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WorkoutSessionsTableOrderingComposer
    extends Composer<_$GymDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds,
      builder: (column) => ColumnOrderings(column));

  $$WorkoutsTableOrderingComposer get workoutId {
    final $$WorkoutsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.workoutId,
        referencedTable: $db.workouts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutsTableOrderingComposer(
              $db: $db,
              $table: $db.workouts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WorkoutSessionsTableAnnotationComposer
    extends Composer<_$GymDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
      column: $table.durationSeconds, builder: (column) => column);

  $$WorkoutsTableAnnotationComposer get workoutId {
    final $$WorkoutsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.workoutId,
        referencedTable: $db.workouts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutsTableAnnotationComposer(
              $db: $db,
              $table: $db.workouts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$WorkoutSessionsTableTableManager extends RootTableManager<
    _$GymDatabase,
    $WorkoutSessionsTable,
    WorkoutSession,
    $$WorkoutSessionsTableFilterComposer,
    $$WorkoutSessionsTableOrderingComposer,
    $$WorkoutSessionsTableAnnotationComposer,
    $$WorkoutSessionsTableCreateCompanionBuilder,
    $$WorkoutSessionsTableUpdateCompanionBuilder,
    (WorkoutSession, $$WorkoutSessionsTableReferences),
    WorkoutSession,
    PrefetchHooks Function({bool workoutId})> {
  $$WorkoutSessionsTableTableManager(
      _$GymDatabase db, $WorkoutSessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> workoutId = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<int?> durationSeconds = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkoutSessionsCompanion(
            id: id,
            workoutId: workoutId,
            date: date,
            durationSeconds: durationSeconds,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> workoutId = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<int?> durationSeconds = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              WorkoutSessionsCompanion.insert(
            id: id,
            workoutId: workoutId,
            date: date,
            durationSeconds: durationSeconds,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$WorkoutSessionsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({workoutId = false}) {
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
                if (workoutId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.workoutId,
                    referencedTable:
                        $$WorkoutSessionsTableReferences._workoutIdTable(db),
                    referencedColumn:
                        $$WorkoutSessionsTableReferences._workoutIdTable(db).id,
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

typedef $$WorkoutSessionsTableProcessedTableManager = ProcessedTableManager<
    _$GymDatabase,
    $WorkoutSessionsTable,
    WorkoutSession,
    $$WorkoutSessionsTableFilterComposer,
    $$WorkoutSessionsTableOrderingComposer,
    $$WorkoutSessionsTableAnnotationComposer,
    $$WorkoutSessionsTableCreateCompanionBuilder,
    $$WorkoutSessionsTableUpdateCompanionBuilder,
    (WorkoutSession, $$WorkoutSessionsTableReferences),
    WorkoutSession,
    PrefetchHooks Function({bool workoutId})>;
typedef $$BodyWeightEntriesTableCreateCompanionBuilder
    = BodyWeightEntriesCompanion Function({
  Value<String> id,
  Value<DateTime> date,
  required double weightKg,
  Value<int> rowid,
});
typedef $$BodyWeightEntriesTableUpdateCompanionBuilder
    = BodyWeightEntriesCompanion Function({
  Value<String> id,
  Value<DateTime> date,
  Value<double> weightKg,
  Value<int> rowid,
});

class $$BodyWeightEntriesTableFilterComposer
    extends Composer<_$GymDatabase, $BodyWeightEntriesTable> {
  $$BodyWeightEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get weightKg => $composableBuilder(
      column: $table.weightKg, builder: (column) => ColumnFilters(column));
}

class $$BodyWeightEntriesTableOrderingComposer
    extends Composer<_$GymDatabase, $BodyWeightEntriesTable> {
  $$BodyWeightEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get date => $composableBuilder(
      column: $table.date, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get weightKg => $composableBuilder(
      column: $table.weightKg, builder: (column) => ColumnOrderings(column));
}

class $$BodyWeightEntriesTableAnnotationComposer
    extends Composer<_$GymDatabase, $BodyWeightEntriesTable> {
  $$BodyWeightEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);
}

class $$BodyWeightEntriesTableTableManager extends RootTableManager<
    _$GymDatabase,
    $BodyWeightEntriesTable,
    BodyWeightEntry,
    $$BodyWeightEntriesTableFilterComposer,
    $$BodyWeightEntriesTableOrderingComposer,
    $$BodyWeightEntriesTableAnnotationComposer,
    $$BodyWeightEntriesTableCreateCompanionBuilder,
    $$BodyWeightEntriesTableUpdateCompanionBuilder,
    (
      BodyWeightEntry,
      BaseReferences<_$GymDatabase, $BodyWeightEntriesTable, BodyWeightEntry>
    ),
    BodyWeightEntry,
    PrefetchHooks Function()> {
  $$BodyWeightEntriesTableTableManager(
      _$GymDatabase db, $BodyWeightEntriesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BodyWeightEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BodyWeightEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BodyWeightEntriesTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<double> weightKg = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              BodyWeightEntriesCompanion(
            id: id,
            date: date,
            weightKg: weightKg,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            required double weightKg,
            Value<int> rowid = const Value.absent(),
          }) =>
              BodyWeightEntriesCompanion.insert(
            id: id,
            date: date,
            weightKg: weightKg,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BodyWeightEntriesTableProcessedTableManager = ProcessedTableManager<
    _$GymDatabase,
    $BodyWeightEntriesTable,
    BodyWeightEntry,
    $$BodyWeightEntriesTableFilterComposer,
    $$BodyWeightEntriesTableOrderingComposer,
    $$BodyWeightEntriesTableAnnotationComposer,
    $$BodyWeightEntriesTableCreateCompanionBuilder,
    $$BodyWeightEntriesTableUpdateCompanionBuilder,
    (
      BodyWeightEntry,
      BaseReferences<_$GymDatabase, $BodyWeightEntriesTable, BodyWeightEntry>
    ),
    BodyWeightEntry,
    PrefetchHooks Function()>;
typedef $$ProgrammesTableCreateCompanionBuilder = ProgrammesCompanion Function({
  Value<String> id,
  required String name,
  Value<String?> description,
  Value<int> durationWeeks,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$ProgrammesTableUpdateCompanionBuilder = ProgrammesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> description,
  Value<int> durationWeeks,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

final class $$ProgrammesTableReferences
    extends BaseReferences<_$GymDatabase, $ProgrammesTable, Programme> {
  $$ProgrammesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProgrammeWorkoutsTable, List<ProgrammeWorkout>>
      _programmeWorkoutsRefsTable(_$GymDatabase db) =>
          MultiTypedResultKey.fromTable(db.programmeWorkouts,
              aliasName: $_aliasNameGenerator(
                  db.programmes.id, db.programmeWorkouts.programmeId));

  $$ProgrammeWorkoutsTableProcessedTableManager get programmeWorkoutsRefs {
    final manager = $$ProgrammeWorkoutsTableTableManager(
            $_db, $_db.programmeWorkouts)
        .filter((f) => f.programmeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_programmeWorkoutsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$ProgrammesTableFilterComposer
    extends Composer<_$GymDatabase, $ProgrammesTable> {
  $$ProgrammesTableFilterComposer({
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

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationWeeks => $composableBuilder(
      column: $table.durationWeeks, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  Expression<bool> programmeWorkoutsRefs(
      Expression<bool> Function($$ProgrammeWorkoutsTableFilterComposer f) f) {
    final $$ProgrammeWorkoutsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.programmeWorkouts,
        getReferencedColumn: (t) => t.programmeId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProgrammeWorkoutsTableFilterComposer(
              $db: $db,
              $table: $db.programmeWorkouts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$ProgrammesTableOrderingComposer
    extends Composer<_$GymDatabase, $ProgrammesTable> {
  $$ProgrammesTableOrderingComposer({
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

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationWeeks => $composableBuilder(
      column: $table.durationWeeks,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ProgrammesTableAnnotationComposer
    extends Composer<_$GymDatabase, $ProgrammesTable> {
  $$ProgrammesTableAnnotationComposer({
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

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<int> get durationWeeks => $composableBuilder(
      column: $table.durationWeeks, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> programmeWorkoutsRefs<T extends Object>(
      Expression<T> Function($$ProgrammeWorkoutsTableAnnotationComposer a) f) {
    final $$ProgrammeWorkoutsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.programmeWorkouts,
            getReferencedColumn: (t) => t.programmeId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$ProgrammeWorkoutsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.programmeWorkouts,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$ProgrammesTableTableManager extends RootTableManager<
    _$GymDatabase,
    $ProgrammesTable,
    Programme,
    $$ProgrammesTableFilterComposer,
    $$ProgrammesTableOrderingComposer,
    $$ProgrammesTableAnnotationComposer,
    $$ProgrammesTableCreateCompanionBuilder,
    $$ProgrammesTableUpdateCompanionBuilder,
    (Programme, $$ProgrammesTableReferences),
    Programme,
    PrefetchHooks Function({bool programmeWorkoutsRefs})> {
  $$ProgrammesTableTableManager(_$GymDatabase db, $ProgrammesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProgrammesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProgrammesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProgrammesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<int> durationWeeks = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProgrammesCompanion(
            id: id,
            name: name,
            description: description,
            durationWeeks: durationWeeks,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String name,
            Value<String?> description = const Value.absent(),
            Value<int> durationWeeks = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProgrammesCompanion.insert(
            id: id,
            name: name,
            description: description,
            durationWeeks: durationWeeks,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ProgrammesTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({programmeWorkoutsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (programmeWorkoutsRefs) db.programmeWorkouts
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (programmeWorkoutsRefs)
                    await $_getPrefetchedData<Programme, $ProgrammesTable,
                            ProgrammeWorkout>(
                        currentTable: table,
                        referencedTable: $$ProgrammesTableReferences
                            ._programmeWorkoutsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$ProgrammesTableReferences(db, table, p0)
                                .programmeWorkoutsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.programmeId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$ProgrammesTableProcessedTableManager = ProcessedTableManager<
    _$GymDatabase,
    $ProgrammesTable,
    Programme,
    $$ProgrammesTableFilterComposer,
    $$ProgrammesTableOrderingComposer,
    $$ProgrammesTableAnnotationComposer,
    $$ProgrammesTableCreateCompanionBuilder,
    $$ProgrammesTableUpdateCompanionBuilder,
    (Programme, $$ProgrammesTableReferences),
    Programme,
    PrefetchHooks Function({bool programmeWorkoutsRefs})>;
typedef $$ProgrammeWorkoutsTableCreateCompanionBuilder
    = ProgrammeWorkoutsCompanion Function({
  Value<String> id,
  required String programmeId,
  required String workoutId,
  required int weekNumber,
  required int dayOfWeek,
  Value<int> rowid,
});
typedef $$ProgrammeWorkoutsTableUpdateCompanionBuilder
    = ProgrammeWorkoutsCompanion Function({
  Value<String> id,
  Value<String> programmeId,
  Value<String> workoutId,
  Value<int> weekNumber,
  Value<int> dayOfWeek,
  Value<int> rowid,
});

final class $$ProgrammeWorkoutsTableReferences extends BaseReferences<
    _$GymDatabase, $ProgrammeWorkoutsTable, ProgrammeWorkout> {
  $$ProgrammeWorkoutsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $ProgrammesTable _programmeIdTable(_$GymDatabase db) =>
      db.programmes.createAlias($_aliasNameGenerator(
          db.programmeWorkouts.programmeId, db.programmes.id));

  $$ProgrammesTableProcessedTableManager get programmeId {
    final $_column = $_itemColumn<String>('programme_id')!;

    final manager = $$ProgrammesTableTableManager($_db, $_db.programmes)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_programmeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $WorkoutsTable _workoutIdTable(_$GymDatabase db) =>
      db.workouts.createAlias(
          $_aliasNameGenerator(db.programmeWorkouts.workoutId, db.workouts.id));

  $$WorkoutsTableProcessedTableManager get workoutId {
    final $_column = $_itemColumn<String>('workout_id')!;

    final manager = $$WorkoutsTableTableManager($_db, $_db.workouts)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workoutIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ProgrammeWorkoutsTableFilterComposer
    extends Composer<_$GymDatabase, $ProgrammeWorkoutsTable> {
  $$ProgrammeWorkoutsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get weekNumber => $composableBuilder(
      column: $table.weekNumber, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get dayOfWeek => $composableBuilder(
      column: $table.dayOfWeek, builder: (column) => ColumnFilters(column));

  $$ProgrammesTableFilterComposer get programmeId {
    final $$ProgrammesTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.programmeId,
        referencedTable: $db.programmes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProgrammesTableFilterComposer(
              $db: $db,
              $table: $db.programmes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$WorkoutsTableFilterComposer get workoutId {
    final $$WorkoutsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.workoutId,
        referencedTable: $db.workouts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutsTableFilterComposer(
              $db: $db,
              $table: $db.workouts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProgrammeWorkoutsTableOrderingComposer
    extends Composer<_$GymDatabase, $ProgrammeWorkoutsTable> {
  $$ProgrammeWorkoutsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get weekNumber => $composableBuilder(
      column: $table.weekNumber, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get dayOfWeek => $composableBuilder(
      column: $table.dayOfWeek, builder: (column) => ColumnOrderings(column));

  $$ProgrammesTableOrderingComposer get programmeId {
    final $$ProgrammesTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.programmeId,
        referencedTable: $db.programmes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProgrammesTableOrderingComposer(
              $db: $db,
              $table: $db.programmes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$WorkoutsTableOrderingComposer get workoutId {
    final $$WorkoutsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.workoutId,
        referencedTable: $db.workouts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutsTableOrderingComposer(
              $db: $db,
              $table: $db.workouts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProgrammeWorkoutsTableAnnotationComposer
    extends Composer<_$GymDatabase, $ProgrammeWorkoutsTable> {
  $$ProgrammeWorkoutsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get weekNumber => $composableBuilder(
      column: $table.weekNumber, builder: (column) => column);

  GeneratedColumn<int> get dayOfWeek =>
      $composableBuilder(column: $table.dayOfWeek, builder: (column) => column);

  $$ProgrammesTableAnnotationComposer get programmeId {
    final $$ProgrammesTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.programmeId,
        referencedTable: $db.programmes,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ProgrammesTableAnnotationComposer(
              $db: $db,
              $table: $db.programmes,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$WorkoutsTableAnnotationComposer get workoutId {
    final $$WorkoutsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.workoutId,
        referencedTable: $db.workouts,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$WorkoutsTableAnnotationComposer(
              $db: $db,
              $table: $db.workouts,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ProgrammeWorkoutsTableTableManager extends RootTableManager<
    _$GymDatabase,
    $ProgrammeWorkoutsTable,
    ProgrammeWorkout,
    $$ProgrammeWorkoutsTableFilterComposer,
    $$ProgrammeWorkoutsTableOrderingComposer,
    $$ProgrammeWorkoutsTableAnnotationComposer,
    $$ProgrammeWorkoutsTableCreateCompanionBuilder,
    $$ProgrammeWorkoutsTableUpdateCompanionBuilder,
    (ProgrammeWorkout, $$ProgrammeWorkoutsTableReferences),
    ProgrammeWorkout,
    PrefetchHooks Function({bool programmeId, bool workoutId})> {
  $$ProgrammeWorkoutsTableTableManager(
      _$GymDatabase db, $ProgrammeWorkoutsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProgrammeWorkoutsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProgrammeWorkoutsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProgrammeWorkoutsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> programmeId = const Value.absent(),
            Value<String> workoutId = const Value.absent(),
            Value<int> weekNumber = const Value.absent(),
            Value<int> dayOfWeek = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProgrammeWorkoutsCompanion(
            id: id,
            programmeId: programmeId,
            workoutId: workoutId,
            weekNumber: weekNumber,
            dayOfWeek: dayOfWeek,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String programmeId,
            required String workoutId,
            required int weekNumber,
            required int dayOfWeek,
            Value<int> rowid = const Value.absent(),
          }) =>
              ProgrammeWorkoutsCompanion.insert(
            id: id,
            programmeId: programmeId,
            workoutId: workoutId,
            weekNumber: weekNumber,
            dayOfWeek: dayOfWeek,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$ProgrammeWorkoutsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({programmeId = false, workoutId = false}) {
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
                if (programmeId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.programmeId,
                    referencedTable: $$ProgrammeWorkoutsTableReferences
                        ._programmeIdTable(db),
                    referencedColumn: $$ProgrammeWorkoutsTableReferences
                        ._programmeIdTable(db)
                        .id,
                  ) as T;
                }
                if (workoutId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.workoutId,
                    referencedTable:
                        $$ProgrammeWorkoutsTableReferences._workoutIdTable(db),
                    referencedColumn: $$ProgrammeWorkoutsTableReferences
                        ._workoutIdTable(db)
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

typedef $$ProgrammeWorkoutsTableProcessedTableManager = ProcessedTableManager<
    _$GymDatabase,
    $ProgrammeWorkoutsTable,
    ProgrammeWorkout,
    $$ProgrammeWorkoutsTableFilterComposer,
    $$ProgrammeWorkoutsTableOrderingComposer,
    $$ProgrammeWorkoutsTableAnnotationComposer,
    $$ProgrammeWorkoutsTableCreateCompanionBuilder,
    $$ProgrammeWorkoutsTableUpdateCompanionBuilder,
    (ProgrammeWorkout, $$ProgrammeWorkoutsTableReferences),
    ProgrammeWorkout,
    PrefetchHooks Function({bool programmeId, bool workoutId})>;
typedef $$GymSettingsTableTableCreateCompanionBuilder
    = GymSettingsTableCompanion Function({
  Value<String> id,
  Value<int> unitIndex,
  Value<int> fullRecoveryDays,
  Value<String> defaultPlateSet,
  Value<int> rowid,
});
typedef $$GymSettingsTableTableUpdateCompanionBuilder
    = GymSettingsTableCompanion Function({
  Value<String> id,
  Value<int> unitIndex,
  Value<int> fullRecoveryDays,
  Value<String> defaultPlateSet,
  Value<int> rowid,
});

class $$GymSettingsTableTableFilterComposer
    extends Composer<_$GymDatabase, $GymSettingsTableTable> {
  $$GymSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get unitIndex => $composableBuilder(
      column: $table.unitIndex, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fullRecoveryDays => $composableBuilder(
      column: $table.fullRecoveryDays,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get defaultPlateSet => $composableBuilder(
      column: $table.defaultPlateSet,
      builder: (column) => ColumnFilters(column));
}

class $$GymSettingsTableTableOrderingComposer
    extends Composer<_$GymDatabase, $GymSettingsTableTable> {
  $$GymSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get unitIndex => $composableBuilder(
      column: $table.unitIndex, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fullRecoveryDays => $composableBuilder(
      column: $table.fullRecoveryDays,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get defaultPlateSet => $composableBuilder(
      column: $table.defaultPlateSet,
      builder: (column) => ColumnOrderings(column));
}

class $$GymSettingsTableTableAnnotationComposer
    extends Composer<_$GymDatabase, $GymSettingsTableTable> {
  $$GymSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get unitIndex =>
      $composableBuilder(column: $table.unitIndex, builder: (column) => column);

  GeneratedColumn<int> get fullRecoveryDays => $composableBuilder(
      column: $table.fullRecoveryDays, builder: (column) => column);

  GeneratedColumn<String> get defaultPlateSet => $composableBuilder(
      column: $table.defaultPlateSet, builder: (column) => column);
}

class $$GymSettingsTableTableTableManager extends RootTableManager<
    _$GymDatabase,
    $GymSettingsTableTable,
    GymSetting,
    $$GymSettingsTableTableFilterComposer,
    $$GymSettingsTableTableOrderingComposer,
    $$GymSettingsTableTableAnnotationComposer,
    $$GymSettingsTableTableCreateCompanionBuilder,
    $$GymSettingsTableTableUpdateCompanionBuilder,
    (
      GymSetting,
      BaseReferences<_$GymDatabase, $GymSettingsTableTable, GymSetting>
    ),
    GymSetting,
    PrefetchHooks Function()> {
  $$GymSettingsTableTableTableManager(
      _$GymDatabase db, $GymSettingsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GymSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GymSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GymSettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<int> unitIndex = const Value.absent(),
            Value<int> fullRecoveryDays = const Value.absent(),
            Value<String> defaultPlateSet = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GymSettingsTableCompanion(
            id: id,
            unitIndex: unitIndex,
            fullRecoveryDays: fullRecoveryDays,
            defaultPlateSet: defaultPlateSet,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<int> unitIndex = const Value.absent(),
            Value<int> fullRecoveryDays = const Value.absent(),
            Value<String> defaultPlateSet = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GymSettingsTableCompanion.insert(
            id: id,
            unitIndex: unitIndex,
            fullRecoveryDays: fullRecoveryDays,
            defaultPlateSet: defaultPlateSet,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$GymSettingsTableTableProcessedTableManager = ProcessedTableManager<
    _$GymDatabase,
    $GymSettingsTableTable,
    GymSetting,
    $$GymSettingsTableTableFilterComposer,
    $$GymSettingsTableTableOrderingComposer,
    $$GymSettingsTableTableAnnotationComposer,
    $$GymSettingsTableTableCreateCompanionBuilder,
    $$GymSettingsTableTableUpdateCompanionBuilder,
    (
      GymSetting,
      BaseReferences<_$GymDatabase, $GymSettingsTableTable, GymSetting>
    ),
    GymSetting,
    PrefetchHooks Function()>;

class $GymDatabaseManager {
  final _$GymDatabase _db;
  $GymDatabaseManager(this._db);
  $$ExercisesTableTableManager get exercises =>
      $$ExercisesTableTableManager(_db, _db.exercises);
  $$SetEntriesTableTableManager get setEntries =>
      $$SetEntriesTableTableManager(_db, _db.setEntries);
  $$WorkoutsTableTableManager get workouts =>
      $$WorkoutsTableTableManager(_db, _db.workouts);
  $$WorkoutStepsTableTableManager get workoutSteps =>
      $$WorkoutStepsTableTableManager(_db, _db.workoutSteps);
  $$MultisetsTableTableManager get multisets =>
      $$MultisetsTableTableManager(_db, _db.multisets);
  $$MultisetExerciseConfigsTableTableManager get multisetExerciseConfigs =>
      $$MultisetExerciseConfigsTableTableManager(
          _db, _db.multisetExerciseConfigs);
  $$WorkoutGroupsTableTableManager get workoutGroups =>
      $$WorkoutGroupsTableTableManager(_db, _db.workoutGroups);
  $$WorkoutSessionsTableTableManager get workoutSessions =>
      $$WorkoutSessionsTableTableManager(_db, _db.workoutSessions);
  $$BodyWeightEntriesTableTableManager get bodyWeightEntries =>
      $$BodyWeightEntriesTableTableManager(_db, _db.bodyWeightEntries);
  $$ProgrammesTableTableManager get programmes =>
      $$ProgrammesTableTableManager(_db, _db.programmes);
  $$ProgrammeWorkoutsTableTableManager get programmeWorkouts =>
      $$ProgrammeWorkoutsTableTableManager(_db, _db.programmeWorkouts);
  $$GymSettingsTableTableTableManager get gymSettingsTable =>
      $$GymSettingsTableTableTableManager(_db, _db.gymSettingsTable);
}
