// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_bin_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWeeklyBinModelCollection on Isar {
  IsarCollection<WeeklyBinModel> get weeklyBinModels => this.collection();
}

const WeeklyBinModelSchema = CollectionSchema(
  name: r'WeeklyBinModel',
  id: 8844449620845063453,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'doneStickIds': PropertySchema(
      id: 1,
      name: r'doneStickIds',
      type: IsarType.stringList,
    ),
    r'poolId': PropertySchema(
      id: 2,
      name: r'poolId',
      type: IsarType.string,
    ),
    r'stickIds': PropertySchema(
      id: 3,
      name: r'stickIds',
      type: IsarType.stringList,
    ),
    r'updatedAt': PropertySchema(
      id: 4,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _weeklyBinModelEstimateSize,
  serialize: _weeklyBinModelSerialize,
  deserialize: _weeklyBinModelDeserialize,
  deserializeProp: _weeklyBinModelDeserializeProp,
  idName: r'id',
  indexes: {
    r'poolId': IndexSchema(
      id: 3683634265834513514,
      name: r'poolId',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'poolId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _weeklyBinModelGetId,
  getLinks: _weeklyBinModelGetLinks,
  attach: _weeklyBinModelAttach,
  version: '3.1.0+1',
);

int _weeklyBinModelEstimateSize(
  WeeklyBinModel object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.doneStickIds.length * 3;
  {
    for (var i = 0; i < object.doneStickIds.length; i++) {
      final value = object.doneStickIds[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.poolId.length * 3;
  bytesCount += 3 + object.stickIds.length * 3;
  {
    for (var i = 0; i < object.stickIds.length; i++) {
      final value = object.stickIds[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _weeklyBinModelSerialize(
  WeeklyBinModel object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeStringList(offsets[1], object.doneStickIds);
  writer.writeString(offsets[2], object.poolId);
  writer.writeStringList(offsets[3], object.stickIds);
  writer.writeDateTime(offsets[4], object.updatedAt);
}

WeeklyBinModel _weeklyBinModelDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WeeklyBinModel();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.doneStickIds = reader.readStringList(offsets[1]) ?? [];
  object.id = id;
  object.poolId = reader.readString(offsets[2]);
  object.stickIds = reader.readStringList(offsets[3]) ?? [];
  object.updatedAt = reader.readDateTime(offsets[4]);
  return object;
}

P _weeklyBinModelDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readStringList(offset) ?? []) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readStringList(offset) ?? []) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _weeklyBinModelGetId(WeeklyBinModel object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _weeklyBinModelGetLinks(WeeklyBinModel object) {
  return [];
}

void _weeklyBinModelAttach(
    IsarCollection<dynamic> col, Id id, WeeklyBinModel object) {
  object.id = id;
}

extension WeeklyBinModelByIndex on IsarCollection<WeeklyBinModel> {
  Future<WeeklyBinModel?> getByPoolId(String poolId) {
    return getByIndex(r'poolId', [poolId]);
  }

  WeeklyBinModel? getByPoolIdSync(String poolId) {
    return getByIndexSync(r'poolId', [poolId]);
  }

  Future<bool> deleteByPoolId(String poolId) {
    return deleteByIndex(r'poolId', [poolId]);
  }

  bool deleteByPoolIdSync(String poolId) {
    return deleteByIndexSync(r'poolId', [poolId]);
  }

  Future<List<WeeklyBinModel?>> getAllByPoolId(List<String> poolIdValues) {
    final values = poolIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'poolId', values);
  }

  List<WeeklyBinModel?> getAllByPoolIdSync(List<String> poolIdValues) {
    final values = poolIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'poolId', values);
  }

  Future<int> deleteAllByPoolId(List<String> poolIdValues) {
    final values = poolIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'poolId', values);
  }

  int deleteAllByPoolIdSync(List<String> poolIdValues) {
    final values = poolIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'poolId', values);
  }

  Future<Id> putByPoolId(WeeklyBinModel object) {
    return putByIndex(r'poolId', object);
  }

  Id putByPoolIdSync(WeeklyBinModel object, {bool saveLinks = true}) {
    return putByIndexSync(r'poolId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByPoolId(List<WeeklyBinModel> objects) {
    return putAllByIndex(r'poolId', objects);
  }

  List<Id> putAllByPoolIdSync(List<WeeklyBinModel> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'poolId', objects, saveLinks: saveLinks);
  }
}

extension WeeklyBinModelQueryWhereSort
    on QueryBuilder<WeeklyBinModel, WeeklyBinModel, QWhere> {
  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension WeeklyBinModelQueryWhere
    on QueryBuilder<WeeklyBinModel, WeeklyBinModel, QWhereClause> {
  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterWhereClause> poolIdEqualTo(
      String poolId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'poolId',
        value: [poolId],
      ));
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterWhereClause>
      poolIdNotEqualTo(String poolId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'poolId',
              lower: [],
              upper: [poolId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'poolId',
              lower: [poolId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'poolId',
              lower: [poolId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'poolId',
              lower: [],
              upper: [poolId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension WeeklyBinModelQueryFilter
    on QueryBuilder<WeeklyBinModel, WeeklyBinModel, QFilterCondition> {
  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      doneStickIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'doneStickIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      doneStickIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'doneStickIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      doneStickIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'doneStickIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      doneStickIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'doneStickIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      doneStickIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'doneStickIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      doneStickIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'doneStickIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      doneStickIdsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'doneStickIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      doneStickIdsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'doneStickIds',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      doneStickIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'doneStickIds',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      doneStickIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'doneStickIds',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      doneStickIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'doneStickIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      doneStickIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'doneStickIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      doneStickIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'doneStickIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      doneStickIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'doneStickIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      doneStickIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'doneStickIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      doneStickIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'doneStickIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      poolIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'poolId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      poolIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'poolId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      poolIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'poolId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      poolIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'poolId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      poolIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'poolId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      poolIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'poolId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      poolIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'poolId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      poolIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'poolId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      poolIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'poolId',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      poolIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'poolId',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      stickIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stickIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      stickIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stickIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      stickIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stickIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      stickIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stickIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      stickIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'stickIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      stickIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'stickIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      stickIdsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'stickIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      stickIdsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'stickIds',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      stickIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stickIds',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      stickIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'stickIds',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      stickIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'stickIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      stickIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'stickIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      stickIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'stickIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      stickIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'stickIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      stickIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'stickIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      stickIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'stickIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension WeeklyBinModelQueryObject
    on QueryBuilder<WeeklyBinModel, WeeklyBinModel, QFilterCondition> {}

extension WeeklyBinModelQueryLinks
    on QueryBuilder<WeeklyBinModel, WeeklyBinModel, QFilterCondition> {}

extension WeeklyBinModelQuerySortBy
    on QueryBuilder<WeeklyBinModel, WeeklyBinModel, QSortBy> {
  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterSortBy> sortByPoolId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poolId', Sort.asc);
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterSortBy>
      sortByPoolIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poolId', Sort.desc);
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension WeeklyBinModelQuerySortThenBy
    on QueryBuilder<WeeklyBinModel, WeeklyBinModel, QSortThenBy> {
  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterSortBy> thenByPoolId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poolId', Sort.asc);
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterSortBy>
      thenByPoolIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'poolId', Sort.desc);
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension WeeklyBinModelQueryWhereDistinct
    on QueryBuilder<WeeklyBinModel, WeeklyBinModel, QDistinct> {
  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QDistinct>
      distinctByDoneStickIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'doneStickIds');
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QDistinct> distinctByPoolId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'poolId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QDistinct> distinctByStickIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stickIds');
    });
  }

  QueryBuilder<WeeklyBinModel, WeeklyBinModel, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension WeeklyBinModelQueryProperty
    on QueryBuilder<WeeklyBinModel, WeeklyBinModel, QQueryProperty> {
  QueryBuilder<WeeklyBinModel, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WeeklyBinModel, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<WeeklyBinModel, List<String>, QQueryOperations>
      doneStickIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'doneStickIds');
    });
  }

  QueryBuilder<WeeklyBinModel, String, QQueryOperations> poolIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'poolId');
    });
  }

  QueryBuilder<WeeklyBinModel, List<String>, QQueryOperations>
      stickIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stickIds');
    });
  }

  QueryBuilder<WeeklyBinModel, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
