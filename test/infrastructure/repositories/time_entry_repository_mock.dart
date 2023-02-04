import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:time_tracker/domain/core/extensions/date_time_range.dart';
import 'package:time_tracker/domain/error/failures.dart';
import 'package:time_tracker/domain/time_entries/time_entry.dart';
import 'package:time_tracker/domain/time_entries/time_entry_model.dart';
import 'package:time_tracker/domain/time_entries/value_objects/end_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/start_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/time_entry_id.dart';
import 'package:time_tracker/infrastructure/repositories/time_entry_repository.dart';

class TimeEntryRepositoryMock implements TimeEntryRepository {
  final _timeEntries = <String, TimeEntry>{};
  int _nextId = 1;

  @override
  Future<Either<Failure, TimeEntry>> add(TimeEntryModel timeEntryModel) async {
    final timeEntry = TimeEntry(
      id: TimeEntryId((_nextId++).toString()),
      start: timeEntryModel.start.dateTime,
      end: timeEntryModel.end.dateTime,
    );

    _timeEntries[timeEntry.id.toString()] = timeEntry;
    return Future.value(Right(timeEntry));
  }

  @override
  Future<Either<Failure, bool>> delete(TimeEntry timeEntry) async {
    final result = await get(timeEntry.id);

    return result.fold(
      (l) {
        return Either.left(l);
      },
      (r) {
        _timeEntries.remove(timeEntry.id);
        return Either.right(true);
      },
    );
  }

  @override
  Future<Either<Failure, TimeEntry>> get(TimeEntryId timeEntryId) async {
    if (_timeEntries.isEmpty) {
      return Either.left(NotFoundFailure());
    }
    final entry = _timeEntries.entries.firstWhereOrNull(
      (entry) => entry.key == timeEntryId.id,
    );

    if (entry == null) {
      return Either.left(NotFoundFailure());
    }

    return Either.right(entry.value);
  }

  @override
  Future<Either<Failure, TimeEntry>> update(TimeEntry entity) async {
    final entry = await get(entity.id);
    if (entry.isLeft()) return entry;

    _timeEntries[entity.id.value] = entity;

    return Either.right(entity);
  }

  @override
  Future<Either<Failure, List<TimeEntry>>> getTimeboxedEntries({
    // TODO take a TimeEntryRange
    required StartTime start,
    required EndTime end,
  }) async {
    // TODO use TimeEntryRange
    final range = DateTimeRange(
      start: start.dateTime,
      end: end.dateTime,
    );
    final timeboxedEntries = <TimeEntry>[];
    final entries = _timeEntries.values;

    for (final entry in entries) {
      if (range.isOverlapping(entry.timeEntryRange)) {
        timeboxedEntries.add(entry);
      }
    }

    return Either.right(timeboxedEntries);
  }
}