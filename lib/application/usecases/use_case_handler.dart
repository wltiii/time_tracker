import 'package:fpdart/fpdart.dart';
import 'package:time_tracker/application/usecases/use_case_command.dart';
import 'package:time_tracker/domain/error/failures.dart';

abstract class UseCaseHandler<C extends UseCaseCommand<T>, T> {
  Future<Either<Failure, T>> handle(C command);
}
