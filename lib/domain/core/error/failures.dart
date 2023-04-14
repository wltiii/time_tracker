import 'package:time_tracker/domain/core/error/additional_info.dart';
import 'package:unrepresentable_state/unrepresentable_state.dart';

/// [Failure] is the abstract class upon which all other
/// exceptions are derived. Failures are considered
/// foreseeable, even expedted, in contrast to AppException.
/// For example, a [NotFoundFailure] can be returned when
/// a record retrieval failed to find a record.
///
/// Generally speaking the message associated with the Failure
/// can be used to provide feedback to the end user.
///
/// Each  [Failure] has a default [ExceptionMessage] and an optional
/// [AdditionalInfo] should the developer feels it necessary
/// to provide further information.
///
/// The [ExceptionMessage] and [AdditionalInfo] are concatenated to for
/// a [String] message that is exposed through a getter as
/// wells as toString method.
//TODO(wltiii): possibly implement in package unrepresentable_state.dart
abstract class Failure {
  Failure(ExceptionMessage defaultMessage, AdditionalInfo? additionalInfo) {
    _message = additionalInfo == null
        ? defaultMessage.value
        : '${defaultMessage.value} ${additionalInfo.value}';
  }

  late String _message;

  String get message => _message;

  @override
  String toString() => message;
}

// Define specific exceptions below. Keep the classes sorted by name.

/// [AuthenticationFailure] extends [Failure] and forms the basis
/// for all authentication errors. Like [Failure], it is constructed
/// from a [ExceptionMessage] and [AdditionalInfo] objects. The
/// [ExceptionMessage] object used to initialize is prepended so as to identify
/// the failure as a problem with Authentication. The [ExceptionMessage] object
/// used to initialize [AuthenticationFailure] being more specific
/// as to the cause of the failure.
///
/// Like [Failure], an optional [AdditionalInfo] should the
/// developer feels it necessary to provide further information.
abstract class AuthenticationFailure extends Failure {
  AuthenticationFailure(
    ExceptionMessage defaultMessage,
    AdditionalInfo? additionalInfo,
  ) : super(
          ExceptionMessage('Authentication failed. ${defaultMessage.value}'),
          additionalInfo,
        );
}

class AuthenticationEmailInvalidFailure extends AuthenticationFailure {
  AuthenticationEmailInvalidFailure([AdditionalInfo? additionalInfo])
      : super(
          ExceptionMessage('Email address is invalid.'),
          additionalInfo,
        );
}

class AuthenticationWeakPasswordFailure extends AuthenticationFailure {
  AuthenticationWeakPasswordFailure([AdditionalInfo? additionalInfo])
      : super(
          ExceptionMessage('The password provided is too weak.'),
          additionalInfo,
        );
}

class CacheFailure extends Failure {
  CacheFailure([AdditionalInfo? additionalInfo])
      : super(ExceptionMessage('Cache failure.'), additionalInfo);
}

class InvalidStateFailure extends Failure {
  InvalidStateFailure([AdditionalInfo? additionalInfo])
      : super(ExceptionMessage('Invalid state.'), additionalInfo);
}

class NotFoundFailure extends Failure {
  NotFoundFailure([AdditionalInfo? additionalInfo])
      : super(ExceptionMessage('Not found.'), additionalInfo);
}

class ServerFailure extends Failure {
  ServerFailure([AdditionalInfo? additionalInfo])
      : super(ExceptionMessage('Failure.'), additionalInfo);
}
