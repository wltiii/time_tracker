// import 'dart:async';
import 'package:fpdart/fpdart.dart';
import 'package:time_tracker/application/repositories/time_entry_repository.dart';
import 'package:time_tracker/domain/error/failures.dart';
import 'package:time_tracker/domain/time_entries/time_entry.dart';
import 'package:time_tracker/domain/time_entries/time_entry_model.dart';

class MockTimeEntryRepository implements TimeEntryRepository {
  final _timeEntries = <int, TimeEntry>{};
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
  // Future<void> update(TimeEntry entity) async {
  Future<Either<Failure, void>> update(TimeEntry entity) async {
    final entry = await get(entity);
    if (entry.isLeft()) return entry;

    _timeEntries[entity.id] = entity;

    return Future.value(const Right(null));
  }
}
