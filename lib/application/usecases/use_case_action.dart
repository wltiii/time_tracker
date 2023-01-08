import 'package:fpdart/fpdart.dart';
import 'package:time_tracker/domain/error/failures.dart';

abstract class UseCaseAction<T> {
  Future<Either<Failure, T>> call(T);
}
