import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:time_tracker/application/repositories/time_entry_repository.dart';
import 'package:time_tracker/domain/core/extensions/date_time_range.dart';
import 'package:time_tracker/domain/error/failures.dart';
import 'package:time_tracker/domain/time_entries/time_entry.dart';
import 'package:time_tracker/domain/time_entries/time_entry_model.dart';
import 'package:time_tracker/domain/time_entries/value_objects/end_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/start_time.dart';

class MockTimeEntryRepository implements TimeEntryRepository {
  final _timeEntries = <String, TimeEntry>{};
  int _nextId = 1;

  @override
  Future<Either<Failure, TimeEntry>> add(TimeEntryModel timeEntryModel) async {
    // final timeEntry = TimeEntry(
    //   id: _nextId++,
    //   model: timeEntryModel,
    // );
    final timeEntry = TimeEntry(
      id: _nextId++,
      start: timeEntryModel.start.dateTime,
      end: timeEntryModel.end.dateTime,
    );

    _timeEntries[timeEntry.id] = timeEntry;
    return Future.value(Right(timeEntry));
  }

  @override
  // Future<bool> delete(TimeEntry timeEntry) async {
  Future<Either<Failure, void>> delete(TimeEntry timeEntry) async {
    final entry = await get(timeEntry);

    if (entry.isRight()) _timeEntries.remove(timeEntry.id);

    return Future.value(const Right(null));
  }

  @override
  Future<Either<Failure, TimeEntry>> get(TimeEntry entity) async {
    final timeEntry = _timeEntries[entity.id];

    return timeEntry != null
        ? Future.value(Right(timeEntry))
        : Future.value(Left(NotFoundFailure()));
  }

  @override
  Future<Either<Failure, TimeEntry>> update(TimeEntry entity) async {
    final entry = await get(entity);
    if (entry.isLeft()) return entry;

    _timeEntries[entity.id] = entity;

    return Future.value(Right(entity));
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

    // TODO(wltiii): add range getter on TimeEntry (TimeEntryRange)
    for (final entry in entries) {
      if (range.isOverlapping(entry.timeEntryRange)) {
        timeboxedEntries.add(entry);
      }
    }
    return Right(timeboxedEntries);
  }
}
