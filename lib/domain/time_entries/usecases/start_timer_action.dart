import 'package:fpdart/fpdart.dart';
import 'package:time_tracker/domain/error/failures.dart';
import 'package:time_tracker/domain/usecases/use_case_action.dart';

abstract class StartTimerUseCaseAction<TimeEntry> extends UseCaseAction {
  Future<Either<Failure, TimeEntry>> call();
}
