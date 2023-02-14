import 'package:collection/collection.dart';
import 'package:fpdart/fpdart.dart';
import 'package:time_tracker/domain/core/extensions/date_time_range.dart';
import 'package:time_tracker/domain/core/extensions/either.dart';
import 'package:time_tracker/domain/error/additional_info.dart';
import 'package:time_tracker/domain/error/failures.dart';
import 'package:time_tracker/domain/repositories/time_entry_repository.dart';
import 'package:time_tracker/domain/time_entries/time_entry.dart';
import 'package:time_tracker/domain/time_entries/time_entry_model.dart';
import 'package:time_tracker/domain/time_entries/value_objects/time_boxed_entries.dart';
import 'package:time_tracker/domain/time_entries/value_objects/time_entry_id.dart';
import 'package:time_tracker/domain/time_entries/value_objects/time_entry_range.dart';

class TimeEntryRepositoryMock implements TimeEntryRepository {
  final _timeEntries = <String, TimeEntry>{};
  int _nextId = 1;
  String failMethod = '';
  Failure withFailure =
      ServerFailure(AdditionalInfo('intentional failure for testing.'));

  void showPersistedEntries() {
    print('Persisted Entries are:');
    _timeEntries.forEach((key, value) {
      print('key: $key value: $value');
    });
  }

  @override
  Future<Either<Failure, TimeEntry>> add(TimeEntryModel timeEntryModel) async {
    final timeEntry = TimeEntry(
      id: TimeEntryId((_nextId++).toString()),
      start: timeEntryModel.startTime.dateTime,
      end: timeEntryModel.endTime.dateTime,
    );

    _timeEntries[timeEntry.id.toString()] = timeEntry;
    showPersistedEntries();
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
    if (failMethod == 'get') return Either.left(withFailure);

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
  Future<Either<Failure, TimeBoxedEntries>> getTimeBoxedEntriesForTimeEntry({
    required TimeEntry timeEntry,
  }) async {
    if (failMethod == 'getTimeBoxedEntries') return Either.left(withFailure);

    final timeBoxedEntries = await _getTimeEntriesInRange(
      timeEntryRange: timeEntry.timeEntryRange,
    );

    if (timeBoxedEntries.isLeft()) {
      return Either.left(timeBoxedEntries.left()!);
    }

    List<TimeEntry> entries = timeBoxedEntries
        .right()!
        .map((entry) => entry)
        .where((id) => id != timeEntry.id)
        .toList();

    return Either.right(
      TimeBoxedEntries(
        start: timeEntry.timeEntryRange.startTime,
        end: timeEntry.timeEntryRange.endTime,
        timeEntryList: entries,
      ),
    );
  }

  Future<Either<Failure, TimeBoxedEntries>> getTimeBoxedEntriesForModel({
    required TimeEntryModel timeEntryModel,
  }) async {
    if (failMethod == 'getTimeBoxedEntriesForModel')
      return Either.left(withFailure);

    final timeBoxedEntries = await _getTimeEntriesInRange(
      timeEntryRange: timeEntryModel.timeEntryRange,
    );

    if (timeBoxedEntries.isLeft()) {
      return Either.left(timeBoxedEntries.left()!);
    }

    return Either.right(
      TimeBoxedEntries(
        start: timeEntryModel.timeEntryRange.startTime,
        end: timeEntryModel.timeEntryRange.endTime,
        timeEntryList: timeBoxedEntries.right()!,
      ),
    );
  }

  Future<Either<Failure, List<TimeEntry>>> _getTimeEntriesInRange({
    required TimeEntryRange timeEntryRange,
  }) async {
    if (failMethod == 'getTimeBoxedEntries') return Either.left(withFailure);

    final entriesInRange = <TimeEntry>[];

    //TODO(wltiii): This logic needs to be some sort of getter when implemented
    final entries = _timeEntries.values;

    for (final entry in entries) {
      //TODO(wltiii): should isOverlapping exist on the entity && model?
      //TODO(wltiii): that way id check can be implemented more logically
      if (timeEntryRange.isOverlapping(entry.timeEntryRange)) {
        entriesInRange.add(entry);
      }
    }

    return Either.right(entriesInRange);
  }

  void fail({required String method, Failure? withFailure}) {
    failMethod = method;
    if (withFailure != null) this.withFailure = withFailure;
  }
}
