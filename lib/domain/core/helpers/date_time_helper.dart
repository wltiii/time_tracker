class DateTimeHelper {
  /// Epoch is 1970-01-01 UTC.
  static DateTime epoch() => DateTime.fromMicrosecondsSinceEpoch(0).toUtc();

  /// DateTimes can represent time values that are at a distance of at most
  /// 100,000,000 days from epoch
  static DateTime startOfTime() => DateTime.utc(-271821, 04, 20);
  static DateTime endOfTime() => DateTime.utc(275760, 09, 13);
}
