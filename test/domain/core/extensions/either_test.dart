import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:time_tracker/domain/core/extensions/either.dart';

void main() {
  test('right() returns right', () {
    const right = 1;

    Either<String, int> e = const Right(right);

    expect(e.right(), equals(right));
    expect(e.left(), isNull);
  });

  test('left() returns left', () {
    const left = 'left';

    Either<String, int> e = const Left(left);

    expect(e.right(), isNull);
    expect(e.left(), equals(left));
  });
}
