import 'package:unrepresentable_state/unrepresentable_state.dart';

/// Freezed is a great package. However, you cannot
/// do constructor validation in order to assure
/// invalid states are unrepresentable.
/// SEE: Discussion with Remi: https://github.com/rrousselGit/freezed/issues/830
class StartTime {
  StartTime({
    required this.start,
  }) {
    if (!DateTime.now().isAfter(start)) {
      throw ValueException(ExceptionMessage('Start time must be after the current time.'));
    }
  }

  final DateTime start;
}
