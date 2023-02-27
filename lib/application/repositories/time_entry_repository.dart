import 'package:fpdart/fpdart.dart';
import 'package:time_tracker/domain/error/failures.dart';
import 'package:time_tracker/domain/time_entries/time_entry.dart';
import 'package:time_tracker/domain/time_entries/time_entry_model.dart';
import 'package:time_tracker/domain/time_entries/value_objects/time_entry_id.dart';
import 'package:time_tracker/domain/time_entries/value_objects/time_entry_range.dart';

abstract class TimeEntryRepository {
  static String get collection => 'time_entries';

  Future<Either<Failure, TimeEntry>> add(TimeEntryModel model);

  Future<Either<Failure, TimeEntry>> get(TimeEntryId timeEntryId);

  Future<Either<Failure, bool>> overlapsWithEntries({
    required TimeEntryRange timeEntryRange,
  });

  // TODO(wltiii): Does the usecase require knowing it was deleted if not found?
  Future<Either<Failure, bool>> delete(TimeEntry entity);

  Future<Either<Failure, TimeEntry>> update(TimeEntry entity);
}
