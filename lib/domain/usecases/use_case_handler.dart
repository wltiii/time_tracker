import 'package:fpdart/fpdart.dart';
import 'package:time_tracker/domain/error/failures.dart';
import 'package:time_tracker/domain/usecases/use_case_command.dart';

//TODO(wltiii): does this provide any value?
//TODO(wltiii): so far I am not using commands and handlers - consider deleting
abstract class UseCaseHandler<C extends UseCaseCommand<T>, T> {
  Future<Either<Failure, T>> handle(C command);
}
