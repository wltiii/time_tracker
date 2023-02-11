import 'package:time_tracker/domain/time_entries/time_entry.dart';
import 'package:time_tracker/domain/time_entries/time_entry_model.dart';

//TODO(wltiii): WIP
class TimeEntryValidationService {
  TimeEntryValidationService();

  // TODO(wltiii): getTimeboxedEntries(for what exactly?). User, I would think.
  // TODO(wltiii): for the MVP, the invariant should be User,
  // TODO(wltiii): other usecases might consider overlapping entries,
  // TODO(wltiii): enforcing only those that cannot overlap, by the other
  // TODO(wltiii): things tracked (Project, Client, Task, other?)
  bool dateTimeRangeIsConsistent({
    required TimeEntryModel modelToValidate,
    required List<TimeEntry> existingEntries,
  }) {
    for (final timeEntry in existingEntries) {
      if (modelToValidate.overlapsWith(timeEntry.timeEntryRange)) {
        print('TimeEntryValidationService.dateTimeRangeIsConsistent -> false');
        return false;
      }
    }

    print('TimeEntryValidationService.dateTimeRangeIsConsistent -> true');
    return true;
  }
}
