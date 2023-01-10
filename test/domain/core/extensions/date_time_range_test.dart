import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker/domain/core/extensions/date_time_range.dart';

void main() {
  group('DateTimeRange extension tests', () {
    group('overlapsWith tests', () {
      test('this range before other returns false', () {
        final thisStart = DateTime.now();
        final thisEnd = thisStart.add(const Duration(days: 1));
        final otherStart = thisStart.add(const Duration(days: 2));
        final otherEnd = thisStart.add(const Duration(days: 3));

        final thisRange = DateTimeRange(start: thisStart, end: thisEnd);
        final otherRange = DateTimeRange(start: otherStart, end: otherEnd);

        expect(thisRange.overlapsWith(otherRange), isFalse);
      });

      test('this range after other returns false', () {
        final thisStart = DateTime.now();
        final thisEnd = thisStart.add(const Duration(days: 1));
        final otherStart = thisStart.subtract(const Duration(days: 2));
        final otherEnd = thisStart.subtract(const Duration(days: 1));

        final thisRange = DateTimeRange(start: thisStart, end: thisEnd);
        final otherRange = DateTimeRange(start: otherStart, end: otherEnd);

        expect(thisRange.overlapsWith(otherRange), isFalse);
      });

      test('ranges with same start/end returns true', () {
        final thisStart = DateTime.now();
        final thisEnd = thisStart.add(const Duration(days: 1));
        final otherStart = DateTime.fromMicrosecondsSinceEpoch(
            thisStart.microsecondsSinceEpoch);
        final otherEnd = thisStart.add(const Duration(days: 1));

        final thisRange = DateTimeRange(start: thisStart, end: thisEnd);
        final otherRange = DateTimeRange(start: otherStart, end: otherEnd);

        expect(thisRange.overlapsWith(otherRange), isTrue);
      });

      test('start overlaps other range returns true', () {
        final thisStart = DateTime.now();
        final thisEnd = thisStart.add(const Duration(days: 1));
        final otherStart = thisStart.subtract(const Duration(hours: 1));
        final otherEnd = thisEnd.subtract(const Duration(hours: 1));

        final thisRange = DateTimeRange(start: thisStart, end: thisEnd);
        final otherRange = DateTimeRange(start: otherStart, end: otherEnd);

        expect(thisRange.overlapsWith(otherRange), isTrue);
      });

      test('end overlaps other range returns true', () {
        final thisStart = DateTime.now();
        final thisEnd = thisStart.add(const Duration(days: 1));
        final otherStart = thisStart.add(const Duration(hours: 1));
        final otherEnd = thisEnd.add(const Duration(hours: 1));

        final thisRange = DateTimeRange(start: thisStart, end: thisEnd);
        final otherRange = DateTimeRange(start: otherStart, end: otherEnd);

        expect(thisRange.overlapsWith(otherRange), isTrue);
      });
    });
  });
}
