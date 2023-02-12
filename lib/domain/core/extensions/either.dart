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

// TODO(wltiii): This might be nice, but I think the above is better
// extension EitherX<L, R> on Either<L, R> {
//   R asRight() => (this as Right).value;
//   L asLeft() => (this as Left).value;
// }
