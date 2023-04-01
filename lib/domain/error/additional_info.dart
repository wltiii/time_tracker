import 'package:unrepresentable_state/unrepresentable_state.dart';

//TODO(wltiii): possibly implement in package unrepresentable_state.dart
class AdditionalInfo extends NonEmptyString {
  AdditionalInfo(
    String value, {
    List<Function>? validators,
  }) : super(
          value,
          validators: validators ?? [],
        );
}
