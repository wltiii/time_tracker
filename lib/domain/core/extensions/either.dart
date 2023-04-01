import 'package:fpdart/fpdart.dart';

extension EitherExtension<L, R> on Either<L, R> {
  R? right() => fold<R?>(
        (_) => null,
        (r) => r,
      );
  L? left() => fold<L?>(
        (l) => l,
        (_) => null,
      );
}
