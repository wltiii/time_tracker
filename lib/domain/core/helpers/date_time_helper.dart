class DateTimeHelper {
  /// Epoch is 1970-01-01 UTC.
  static DateTime epoch() => DateTime.fromMicrosecondsSinceEpoch(0).toUtc();

  /// DateTimes can represent time values that are at a distance of at most
  /// 100,000,000 days from epoch
  static DateTime startOfTime() => DateTime.utc(-271821, 04, 20);
  static DateTime endOfTime() => DateTime.utc(275760, 09, 13);

  /// The min/max Firestore Timestamp values as
  /// DateTime objects. The range is from
  /// 0001-01-01T00:00:00Z to 9999-12-31T23:59:59.999999999Z
  static DateTime firestoreMinDate() => DateTime.parse('0001-01-01T00:00:00Z');
  static DateTime firestoreMaxDate() => DateTime.parse('9999-12-31T23:59:59Z');
}
