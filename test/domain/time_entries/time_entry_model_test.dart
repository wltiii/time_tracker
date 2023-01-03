import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker/domain/time_entries/time_entry_model.dart';
import 'package:time_tracker/domain/time_entries/value_objects/start_time.dart';
import 'package:unrepresentable_state/unrepresentable_state.dart';

void main() {
  group('construction', () {
    test('from default', () {
      // final startTime = DateTime.now().subtract(const Duration(hours: 1));
      final startTime = StartTime(
        dateTime: DateTime.now().subtract(
          const Duration(
            hours: 1,
          ),
        ),
      );
      final endTime = DateTime.now();

      var result = TimeEntryModel(start: startTime, end: endTime);

      expect(result, isA<TimeEntryModel>());
    });

    test('does not construct when end is not greater than start', () {
      // var startTime = DateTime.now();
      final startTime = StartTime(dateTime: DateTime.now());
      var endTime = DateTime.now().subtract(const Duration(hours: 1));

      expect(
        () => TimeEntryModel(start: startTime, end: endTime),
        throwsA(
          predicate(
            (e) =>
                e is ValueException &&
                e.message == 'Invalid value. End time must be after start time.',
          ),
        ),
      );
    });
  });

  // Testing generated code seems rather silly. in the case of
  // the generated equals code, i am less comfortable skipping
  // testing it. if someone adds another property to the class but
  // fails to add it to props, you could end up with false equivalency.
  // a condition that may not manifest in other tests, and may be
  // hard to uncover in production.
  // TODO(wltiii): think about this. is there a better solution? is this going overboard?
  group('equality', () {
    test('same values are equal', () {
      // var startTime = DateTime.now().subtract(const Duration(hours: 1));
      final startTime = StartTime(
        dateTime: DateTime.now().subtract(
          const Duration(
            hours: 1,
          ),
        ),
      );
      final endTime = DateTime.now();

      final expected = TimeEntryModel(start: startTime, end: endTime);
      final result = TimeEntryModel(start: startTime, end: endTime);

      expect(result, equals(expected));
    });

    test('different values are not equal', () {
      // var startTime = DateTime.now().subtract(const Duration(hours: 1));
      final startTime = StartTime(
        dateTime: DateTime.now().subtract(
          const Duration(
            hours: 1,
          ),
        ),
      );
      final endTime = DateTime.now();
      // final anotherStartTime = DateTime.now().subtract(const Duration(hours: 1));
      final anotherStartTime = StartTime(
        dateTime: DateTime.now().subtract(
          const Duration(
            hours: 1,
          ),
        ),
      );
      final anotherEndTime = DateTime.now().add(const Duration(hours: 1));

      expect(
        TimeEntryModel(start: startTime, end: endTime),
        isNot(equals(TimeEntryModel(start: anotherStartTime, end: endTime))),
      );

      expect(
        TimeEntryModel(start: startTime, end: endTime),
        isNot(equals(TimeEntryModel(start: startTime, end: anotherEndTime))),
      );
    });
  });

  // testing generated code seems rather silly. in the case of
  // the from/to json, we are doing much more than verifying the
  // methods have been implemented.
  //
  // Since this should normally be an easy test to implement, and
  // one that would require little maintenance as the model evolves,
  // this should not be too controversial. That said, from/to json
  // methods would likely be inherently covered by other tests, so
  // perhaps this is frivolous.
  // TODO(wltiii): think about this. is there a better solution? is this going overboard?
  group('json', () {
    test('from/to', () {
      final startTime = StartTime(
        dateTime: DateTime.now().subtract(
          const Duration(
            hours: 1,
          ),
        ),
      );

      final endTime = DateTime.now();

      final givenTimeEntry = TimeEntryModel(
        start: startTime,
        end: endTime,
      );

      // final jsonModel = {
      //   'start': startTime.iso8601String,
      //   'end': '2022-12-25T08:37:14.040648',
      // };

      // {start: 2023-01-03T15:33:46.466240, end: 2023-01-03T16:33:46.467658}
      print('givenTimeEntry.toJson() = ${givenTimeEntry.toJson()}');

      expect(
        TimeEntryModel.fromJson(givenTimeEntry.toJson()),
        equals(givenTimeEntry),
      );
    });
  });
}
