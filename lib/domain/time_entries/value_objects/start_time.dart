import 'package:equatable/equatable.dart';
import 'package:unrepresentable_state/unrepresentable_state.dart';

/// Throws: ValueException when the result would mean StartTime would be in an
/// invalid state.
class StartTime extends Equatable {
  StartTime({
    DateTime? dateTime,
  }) {
    final upperBound = DateTime.now();
    final lowerBound = upperBound.subtract(const Duration(days: 7));
    final startTime = dateTime ?? upperBound;

    if (startTime.isAfter(upperBound)) {
      throw ValueException(ExceptionMessage('Start time cannot be after the current time.'));
    }
    if (startTime.isBefore(lowerBound)) {
      throw ValueException(ExceptionMessage('Start time cannot be more than 7 days ago.'));
    }

    _start = startTime;
  }

  /// Creates an instance from an Iso8601 string.
  ///
  /// Throws: FormatException if string is invalid.
  StartTime.fromIso8601String(String iso8601String) : this(dateTime: DateTime.parse(iso8601String));

  // factory StartTime.fromJson() {}
  //
  // factory StartTime.fromJson(Json json) {
  //   return User.fromJson(json) as Dependent;
  // }

  // Json toJson() {
  //   return {'runtimeType': this.runtimeType.toString(), 'id': id, 'userName': name};
  // }

  late final DateTime _start;

  DateTime get dateTime => _start;
  String get iso8601String => _start.toIso8601String();

  @override
  String toString() => _start.toString();

  //TODO(wltiii): it was necessary to extend Equatable when implementing TimeEntry serialization by hand. Will likely be needed when serialization is done by serializable. Validate.
  @override
  List<Object> get props => [_start];
}

/*
  group('json', () {
    var jsonModel = {
      'start': '2022-12-25T07:37:14.040636',
      'end': '2022-12-25T08:37:14.040648',
    };

    test('from json', () {});

    test('to json', () {
      var startTime = DateTime.now().subtract(
        const Duration(hours: 1),
      );
      var endTime = DateTime.now();
      var givenTimeEntry = TimeEntryModel(
        start: startTime,
        end: endTime,
      );

      var expectedResult = {
        'start': '${startTime.toIso8601String()}',
        'end': '$endTime',
      };

      var result = givenTimeEntry.toJson();
      expect(result, equals(expectedResult));
    });
  });

 */
// @JsonSerializable()
// class NumberOfCompartments extends NaturalNumber {
//   NumberOfCompartments(int value) : super(value);
//
//   factory NumberOfCompartments.fromJson(Json json) => _$NumberOfCompartmentsFromJson(json);
// }
