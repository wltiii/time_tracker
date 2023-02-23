void main() {
  //TODO(wltiii): the commented code below could possibly be useful for tests on time_entry_repository
  //TODO(wltiii): remove commented code
  // group('dateTimeRangeIsConsistent validation', () {
  //   test('returns true when there are no other entries', () async {
  //     final givenModel = TimeEntryModel.validatedRunningEntry(
  //       timeBoxedEntries: TimeBoxedEntries(
  //         start: StartTime(),
  //         end: EndTime.endOfTime(),
  //         timeEntryList: [],
  //       ),
  //     );
  //
  //     final service = TimeEntryValidationService();
  //
  //     final result = service.dateTimeRangeIsConsistent(
  //       modelToValidate: givenModel,
  //       existingEntries: [],
  //     );
  //
  //     expect(result, isTrue);
  //   });
  //
  //   test('returns true when there is no overlap', () async {
  //     final givenExistingTimeEntries = [
  //       TimeEntry(
  //         id: TimeEntryId('existing_1'),
  //         start: DateTime.now().subtract(const Duration(days: 7)),
  //         end: DateTime.now().subtract(const Duration(days: 1)),
  //       )
  //     ];
  //     final givenNonOverlappingModel = TimeEntryModel.validatedRunningEntry(
  //       timeBoxedEntries: TimeBoxedEntries(
  //         start: StartTime(),
  //         end: EndTime.endOfTime(),
  //         timeEntryList: [],
  //       ),
  //     );
  //
  //     final service = TimeEntryValidationService();
  //
  //     final result = service.dateTimeRangeIsConsistent(
  //       modelToValidate: givenNonOverlappingModel,
  //       existingEntries: givenExistingTimeEntries,
  //     );
  //
  //     expect(result, isTrue);
  //   });
  //
  //   test('returns false when there is an overlap', () async {
  //     final givenExistingTimeEntries = [
  //       TimeEntry(
  //         id: TimeEntryId('existing_1'),
  //         start: DateTime.now().subtract(const Duration(days: 7)),
  //         end: DateTime.now().subtract(const Duration(days: 1)),
  //       )
  //     ];
  //     final givenOverlappingModel = TimeEntryModel(
  //       startTime: StartTime(
  //           dateTime: DateTime.now().subtract(const Duration(days: 5))),
  //       endTime: EndTime(dateTime: DateTime.now()),
  //     );
  //
  //     final result = TimeEntryValidationService().dateTimeRangeIsConsistent(
  //       modelToValidate: givenOverlappingModel,
  //       existingEntries: givenExistingTimeEntries,
  //     );
  //
  //     expect(result, isFalse);
  //   });
  // });
}
