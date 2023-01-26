import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker/domain/error/additional_info.dart';
import 'package:time_tracker/domain/error/failures.dart';
import 'package:unrepresentable_state/unrepresentable_state.dart';

class FailureTester extends Failure {
  FailureTester([AdditionalInfo? additionalInfo])
      : super(
          ExceptionMessage('This is a test. Only a test.'),
          additionalInfo,
        );
}

class AuthenticationFailureTester extends AuthenticationFailure {
  AuthenticationFailureTester([AdditionalInfo? additionalInfo])
      : super(
          ExceptionMessage('This is an authentication failure test.'),
          additionalInfo,
        );
}

void main() {
  group('constructs a failure', () {
    test('default', () {
      final failure = FailureTester();

      expect(failure, isA<Failure>());
      expect(failure.message, equals('This is a test. Only a test.'));
      expect(failure.toString(), equals('This is a test. Only a test.'));
    });

    test('with additional info', () {
      const givenAdditionalInfo = 'additional info';

      final additionalInfo = AdditionalInfo(givenAdditionalInfo);

      final failure = FailureTester(additionalInfo);

      expect(failure, isA<Failure>());
      expect(
        failure.message,
        equals('This is a test. Only a test. additional info'),
      );
      expect(
        failure.toString(),
        equals('This is a test. Only a test. additional info'),
      );
    });

    test('AuthenticationFailure', () {
      const givenAdditionalInfo = 'additional info';

      final additionalInfo = AdditionalInfo(givenAdditionalInfo);

      final failure = AuthenticationFailureTester(additionalInfo);

      expect(failure, isA<Failure>());
      expect(failure, isA<AuthenticationFailure>());
      expect(
        failure.message,
        equals(
            'Authentication failed. This is an authentication failure test. additional info'),
      );
      expect(
        failure.toString(),
        equals(
            'Authentication failed. This is an authentication failure test. additional info'),
      );
    });

    test('AuthenticationEmailInvalidFailure', () {
      const givenAdditionalInfo = 'additional info';

      final additionalInfo = AdditionalInfo(givenAdditionalInfo);

      final failure = AuthenticationEmailInvalidFailure(additionalInfo);

      expect(failure, isA<Failure>());
      expect(failure, isA<AuthenticationFailure>());
      expect(
        failure.message,
        equals(
            'Authentication failed. Email address is invalid. additional info'),
      );
      expect(
        failure.toString(),
        equals(
            'Authentication failed. Email address is invalid. additional info'),
      );
    });

    test('AuthenticationWeakPasswordFailure', () {
      const givenAdditionalInfo = 'additional info';

      final additionalInfo = AdditionalInfo(givenAdditionalInfo);

      final failure = AuthenticationWeakPasswordFailure(additionalInfo);

      expect(failure, isA<Failure>());
      expect(failure, isA<AuthenticationFailure>());
      expect(
        failure.message,
        equals(
            'Authentication failed. The password provided is too weak. additional info'),
      );
      expect(
        failure.toString(),
        equals(
            'Authentication failed. The password provided is too weak. additional info'),
      );
    });

    test('CacheFailure', () {
      const givenAdditionalInfo = 'additional info';

      final additionalInfo = AdditionalInfo(givenAdditionalInfo);

      final failure = CacheFailure(additionalInfo);

      expect(failure, isA<Failure>());
      expect(
        failure.message,
        equals('Cache failure. additional info'),
      );
      expect(
        failure.toString(),
        equals('Cache failure. additional info'),
      );
    });

    test('InvalidStateFailure', () {
      const givenAdditionalInfo = 'additional info';

      final additionalInfo = AdditionalInfo(givenAdditionalInfo);

      final failure = InvalidStateFailure(additionalInfo);

      expect(failure, isA<Failure>());
      expect(
        failure.message,
        equals('Invalid state. additional info'),
      );
      expect(
        failure.toString(),
        equals('Invalid state. additional info'),
      );
    });

    test('NotFoundFailure', () {
      const givenAdditionalInfo = 'additional info';

      final additionalInfo = AdditionalInfo(givenAdditionalInfo);

      final failure = NotFoundFailure(additionalInfo);

      expect(failure, isA<Failure>());
      expect(
        failure.message,
        equals('Not found. additional info'),
      );
      expect(
        failure.toString(),
        equals('Not found. additional info'),
      );
    });

    test('ServerFailure', () {
      const givenAdditionalInfo = 'additional info';

      final additionalInfo = AdditionalInfo(givenAdditionalInfo);

      final failure = ServerFailure(additionalInfo);

      expect(failure, isA<Failure>());
      expect(
        failure.message,
        equals('Failure. additional info'),
      );
      expect(
        failure.toString(),
        equals('Failure. additional info'),
      );
    });
  });
}
