import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:logger/logger.dart';
import 'package:time_tracker/application/repositories/time_entry_repository.dart';
import 'package:time_tracker/domain/core/extensions/either.dart';
import 'package:time_tracker/domain/error/failures.dart';
import 'package:time_tracker/domain/time_entries/time_entry.dart';
import 'package:time_tracker/domain/time_entries/time_entry_model.dart';
import 'package:time_tracker/domain/time_entries/value_objects/time_entry_id.dart';
import 'package:time_tracker/domain/time_entries/value_objects/time_entry_range.dart';
import 'package:unrepresentable_state/unrepresentable_state.dart';

class TimeEntryRepositoryImpl implements TimeEntryRepository {
  TimeEntryRepositoryImpl(this.firestore);
  final FirebaseFirestore firestore;
  final logger = Logger(
    printer: PrettyPrinter(printTime: true),
  );

  @override
  Future<Either<Failure, TimeEntry>> add(TimeEntryModel timeEntryModel) async {
    try {
      final doc = await firestore
          .collection(TimeEntryRepository.collection)
          .add(timeEntryModel.toJson())
          .catchError((Object e, StackTrace stackTrace) =>
              throw ServerException(ExceptionMessage(e.toString())));

      final timeEntry =
          TimeEntry.fromModel(id: TimeEntryId(doc.id), model: timeEntryModel);

      return Future.value(Right(timeEntry));
    } on ServerException catch (e) {
      logger.e('ServerException -> ${e.message}');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> delete(TimeEntry timeEntry) async {
    try {
      await firestore
          .collection(TimeEntryRepository.collection)
          .doc(timeEntry.id.id)
          .delete()
          .catchError((Object e, StackTrace stackTrace) =>
              throw ServerException(ExceptionMessage(e.toString())));

      return Either.right(true);
    } on ServerException catch (e) {
      logger.e('ServerException -> ${e.message}');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, TimeEntry>> get(TimeEntryId timeEntryId) async {
    try {
      final doc = await firestore
          .collection(TimeEntryRepository.collection)
          .doc(timeEntryId.id)
          .get()
          .catchError((Object e, StackTrace stackTrace) =>
              throw ServerException(ExceptionMessage(e.toString())));

      if (doc.exists) {
        return Right(TimeEntry.fromJson(doc.data()!..addAll({'id': doc.id})));
      } else {
        return Left(NotFoundFailure());
      }
    } on ServerException catch (e) {
      logger.e('ServerException -> ${e.message}');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, TimeEntry>> update(TimeEntry entity) async {
    try {
      await firestore
          .collection(TimeEntryRepository.collection)
          .doc(entity.id.id)
          .set(entity.toJson())
          .catchError((Object e, StackTrace stackTrace) =>
              throw ServerException(ExceptionMessage(e.toString())));

      //NOTE: I am not timestamping my entities on add/update
      return Future.value(Right(entity));
    } on ServerException catch (e) {
      logger.e('ServerException -> ${e.message}');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> overlapsWithEntries({
    required TimeEntryRange timeEntryRange,
  }) async {
    final startIsOverlapping = await _overlapsWithEntries(
      field: 'start',
      timeEntryRange: timeEntryRange,
    );

    if (startIsOverlapping.isLeft()) {
      return Left(startIsOverlapping.left()!);
    }

    if (startIsOverlapping.right()!) {
      return const Right(true);
    }

    final endIsOverlapping = await _overlapsWithEntries(
      field: 'end',
      timeEntryRange: timeEntryRange,
    );

    if (endIsOverlapping.isLeft()) {
      return Left(endIsOverlapping.left()!);
    }

    return Right(endIsOverlapping.right()!);
  }

  Future<Either<Failure, bool>> _overlapsWithEntries({
    required String field,
    required TimeEntryRange timeEntryRange,
  }) async {
    var hasTimeEntriesInRange = false;

    try {
      await firestore
          .collection(TimeEntryRepository.collection)
          .where(field,
              isGreaterThanOrEqualTo: timeEntryRange.startTime.iso8601String)
          .where(field,
              isLessThanOrEqualTo: timeEntryRange.endTime.iso8601String)
          .limit(1)
          .get()
          .then((snapshot) {
        logger.d(
            'No of records received from ${TimeEntryRepository.collection} datasource is ${snapshot.docs.length}');
        hasTimeEntriesInRange = snapshot.docs.isNotEmpty;
      }).catchError((Object e, StackTrace stackTrace) {
        logger.e(
            'Error retrieving TimeEntry for range $timeEntryRange. Error -> "$e"');
        throw ServerException(ExceptionMessage(e.toString()));
      });
    } on ServerException catch (e) {
      logger.e('ServerException -> ${e.message}');
      return Left(ServerFailure());
    }

    return Right(hasTimeEntriesInRange);
  }
}
