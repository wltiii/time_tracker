import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:time_tracker/application/usecases/start_timer/start_timer_action.dart';
import 'package:time_tracker/application/usecases/stop_timer/stop_timer_action.dart';
import 'package:time_tracker/domain/time_entries/value_objects/end_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/start_time.dart';
import 'package:time_tracker/domain/time_entries/value_objects/time_entry_id.dart';
import 'package:time_tracker/infrastructure/providers/provider_of_time_entry_list.dart';

import '../infrastructure/repositories/time_entry_repository_impl.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;
final repo = TimeEntryRepositoryImpl(db);
final logger = Logger(
  printer: PrettyPrinter(printTime: true),
);
// TODO(wltiii) should this be an extension to datetime?
final dateFormatter = DateFormat('MM/dd/yyyy HH:MM:ss');

class TimeTrackerApp extends ConsumerWidget {
  final _startTimerAction = StartTimerAction(repo);
  final _stopTimerAction = StopTimerAction(repo);

  TimeTrackerApp({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    ref.watch(providerOfTimeEntryList);

    TimeEntryId? runningTimerId;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Time Entries'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ref.watch(providerOfTimeEntryList).when(
                  loading: () {
                    runningTimerId = null;
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  error: (error, stacktrace) => Text('Error: $error'),
                  data: (timeEntries) {
                    debugPrint(
                      '=== when.data: runningTimerId=$runningTimerId',
                    );
                    return Expanded(
                      child: ListView.builder(
                        itemCount: timeEntries.length,
                        itemBuilder: (context, index) {
                          // //TODO(wltiii): we only need this value when a timer is running. We could swap the button from start to stop based upon whether or not this value is null.
                          runningTimerId =
                              (index == 0 && timeEntries[0].end.isInfinite)
                                  ? timeEntries[0].id
                                  : runningTimerId;

                          return Padding(
                            padding: const EdgeInsets.all(20),
                            child: timeResultsRow(
                              TextEditingController(
                                  text: dateFormatter.format(
                                      timeEntries[index].start.dateTime)),
                              timeEntries[index].end.isInfinite
                                  ? TextEditingController(text: '')
                                  : TextEditingController(
                                      text: dateFormatter.format(
                                          timeEntries[index].end.dateTime)),
                              timeEntries[index].end.isInfinite
                                  ? TextEditingController(text: '')
                                  : TextEditingController(
                                      text: _getTimeDifference(
                                        timeEntries[index].start,
                                        timeEntries[index].end,
                                      ),
                                    ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
            const SizedBox(height: 20),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(
                    Icons.play_arrow,
                    color: Colors.green,
                  ),
                  label: const Text('Start'),
                  onPressed: () async {
                    debugPrint(
                        '=== Start button pressed. runningTimerId=$runningTimerId');
                    await _startTimerAction();
                  },
                ),
                const SizedBox(width: 20),
                OutlinedButton.icon(
                  icon: const Icon(
                    Icons.stop_circle,
                    color: Colors.red,
                  ),
                  label: const Text('Stop'),
                  onPressed: () async {
                    // TODO(wltiii): There should be one button and it switches state as appropriate obviating the need for this check
                    debugPrint(
                        '=== Stop button pressed. runningTimerId=$runningTimerId');
                    if (runningTimerId != null) {
                      // TODO(wltiii): verify the logic above will set this to null. I want to swap buttons based on this value.
                      // runningTimerId = null;
                      await _stopTimerAction(runningTimerId!);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget timeResultsRow(
      TextEditingController startTimeController,
      TextEditingController stopTimeController,
      TextEditingController elapsedTimeController) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 20),
        _showTimeResult(startTimeController, 'Start Time'),
        const SizedBox(width: 20),
        _showTimeResult(stopTimeController, 'Stop Time'),
        const SizedBox(width: 20),
        _showTimeResult(elapsedTimeController, 'Elapsed'),
        const SizedBox(width: 20),
      ],
    );
  }

  //TODO(wltiii): do we really need hint text with the current changes? Row headers seem better.
  Widget _showTimeResult(TextEditingController? controller, String hintText) {
    return Expanded(
      child: TextFormField(
        controller: controller,
        textAlign: TextAlign.center,
        readOnly: true,
        decoration: InputDecoration(
          hintText: hintText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  //TODO(wltiii): it would be nice to have a running timer (streaming the diff), not adding it to the streamed list until stopped
  String _getTimeDifference(StartTime startDateTime, EndTime endDateTime) {
    Duration difference = endDateTime.difference(startDateTime);
    return '${(difference.inHours).floor().toString().padLeft(2, '0')}:'
        '${(difference.inMinutes % 60).floor().toString().padLeft(2, '0')}:'
        '${(difference.inSeconds % 60).floor().toString().padLeft(2, '0')}';
  }
}
