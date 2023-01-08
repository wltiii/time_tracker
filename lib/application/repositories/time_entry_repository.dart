import 'package:fpdart/fpdart.dart';
import 'package:time_tracker/domain/error/failures.dart';
import 'package:time_tracker/domain/time_entries/time_entry.dart';
import 'package:time_tracker/domain/time_entries/time_entry_model.dart';

abstract class TimeEntryRepository {
  Future<Either<Failure, TimeEntry>> add(TimeEntryModel model);

  Future<Either<Failure, TimeEntry>> get(TimeEntry entity);

  // TODO(wltiii): shouldn't this return Future<Either<Failure, TimeEntry>?
  // TODO(wltiii): or Future<Either<Failure, bool>? Does the usecase require knowing it was deleted if not found?
  // Future<void> delete(TimeEntry entity);
  // Future<Either<Failure, bool>> delete(TimeEntry entity);
  Future<Either<Failure, void>> delete(TimeEntry entity);

  // TODO(wltiii): shouldn't this return Future<Either<Failure, TimeEntry>?
  // Future<void> update(TimeEntry entity);
  Future<Either<Failure, void>> update(TimeEntry entity);
}
