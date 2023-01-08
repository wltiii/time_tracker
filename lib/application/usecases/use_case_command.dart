//TODO(wltiii): i've seen samples using an abstract command class,
// some with call, others without. i think that depends upon whether
// or not a separate handler class is being used. I am using handlers
// (at present), so the call here is unnecessary as command is little
// more than a data object (at present)
abstract class UseCaseCommand<T> {
  // Future<Either<Failure, T>> call();
}
