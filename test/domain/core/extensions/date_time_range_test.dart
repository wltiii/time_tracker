import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker/domain/core/extensions/date_time_range.dart';

void main() {
  group('DateTimeRange extension tests', () {
    final now = DateTime.now();
    final nowPlusOneHour = now.add(const Duration(hours: 1));
    final nowPlusTwoHours = now.add(const Duration(hours: 2));
    final nowPlusThreeHours = now.add(const Duration(hours: 3));

    group('overlapsWith tests', () {
      test('this range before other returns false', () {
        final thisRange = DateTimeRange(start: now, end: nowPlusOneHour);
        final otherRange =
            DateTimeRange(start: nowPlusTwoHours, end: nowPlusThreeHours);

        expect(thisRange.isOverlapping(otherRange), isFalse);
      });

      test('this range after other returns false', () {
        final thisRange =
            DateTimeRange(start: nowPlusTwoHours, end: nowPlusThreeHours);
        final otherRange = DateTimeRange(start: now, end: nowPlusOneHour);

        expect(thisRange.isOverlapping(otherRange), isFalse);
      });

      test('ranges with same start/end returns true', () {
        final thisRange = DateTimeRange(start: now, end: nowPlusOneHour);
        final otherRange = DateTimeRange(start: now, end: nowPlusOneHour);

        expect(thisRange.isOverlapping(otherRange), isTrue);
      });

      test('this range contains other range returns true', () {
        final thisRange = DateTimeRange(start: now, end: nowPlusThreeHours);
        final otherRange =
            DateTimeRange(start: nowPlusOneHour, end: nowPlusTwoHours);

        expect(thisRange.isOverlapping(otherRange), isTrue);
      });

      test('range contained within other range returns true', () {
        final thisRange =
            DateTimeRange(start: nowPlusOneHour, end: nowPlusTwoHours);
        final otherRange = DateTimeRange(start: now, end: nowPlusThreeHours);

        expect(thisRange.isOverlapping(otherRange), isTrue);
      });

      test('start within other range returns true', () {
        final thisRange =
            DateTimeRange(start: nowPlusOneHour, end: nowPlusThreeHours);
        final otherRange = DateTimeRange(start: now, end: nowPlusTwoHours);

        expect(thisRange.isOverlapping(otherRange), isTrue);
      });

      test('end within other range returns true', () {
        final thisRange = DateTimeRange(start: now, end: nowPlusTwoHours);
        final otherRange =
            DateTimeRange(start: nowPlusOneHour, end: nowPlusThreeHours);

        expect(thisRange.isOverlapping(otherRange), isTrue);
      });
    });
  });
}
