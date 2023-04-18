import 'package:fpdart/fpdart.dart';
import 'package:time_tracker/domain/core/error/failures.dart';
import 'package:time_tracker/domain/usecases/use_case_command.dart';

//TODO(wltiii): so far I am not using commands and handlers - consider deleting
//TODO(wltiii): these are parts of the Command pattern. It seems overkill for this app.
//TODO(wltiii): see the following posts for more info:
//TODO(wltiii): 1.  https://medium.com/@mgonzalezbaile/implementing-a-use-case-i-intro-38c80b4fed0
//TODO(wltiii): 2.  https://medium.com/@mgonzalezbaile/implementing-a-use-case-ii-command-pattern-2d49d980e61c
abstract class UseCaseHandler<C extends UseCaseCommand<T>, T> {
  Future<Either<Failure, T>> handle(C command);
}
