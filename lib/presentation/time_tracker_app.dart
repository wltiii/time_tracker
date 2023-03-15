import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
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

    final startTimeController = TextEditingController();
    final stopTimeController = TextEditingController();
    final elapsedTimeController = TextEditingController();
    final ValueNotifier<Option<StartTime>> startTime =
        ValueNotifier(const Option.none());
    final ValueNotifier<Option<EndTime>> stopTime =
        ValueNotifier(const Option.none());
    TimeEntryId? runningTimerId;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Difference between DateTime'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ref.watch(providerOfTimeEntryList).when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  error: (error, stacktrace) => Text('Error: $error'),
                  data: (timeEntries) {
                    return Text('Length of time entries ${timeEntries.length}');
                  },
                ),
            const SizedBox(height: 20),
            timeResultsRow(
              startTimeController,
              stopTimeController,
              elapsedTimeController,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(
                    Icons.play_arrow,
                    color: Colors.green,
                  ),
                  label: const Text('Start timer'),
                  onPressed: () async {
                    final result = await _startTimerAction();
                    result.fold(
                      //TODO(wltiii): handle failure
                      (failure) => {
                        logger.e(failure.message),
                      },
                      (startedTimer) {
                        startTime.value = Option.of(startedTimer.start);
                        //TODO(wltiii): stop an existing running timer, if any. or, better yet, only allow stopping if running.
                        runningTimerId = startedTimer.id;
                        startTimeController.text =
                            startedTimer.start.toString();
                      },
                    );
                  },
                ),
                const SizedBox(width: 20),
                OutlinedButton.icon(
                  // ElevatedButton.icon(
                  icon: const Icon(
                    Icons.stop_circle,
                    color: Colors.red,
                  ),
                  label: const Text('Stop timer'),
                  onPressed: () async {
                    // TODO(wltiii): There should be one button and it switches state as appropriate obviating the need for this check
                    if (runningTimerId != null) {
                      final result = await _stopTimerAction(runningTimerId!);
                      result.fold(
                        //TODO(wltiii): handle failure
                        (failure) => {},
                        (stoppedTimer) {
                          runningTimerId = null;
                          stopTime.value = Option.of(stoppedTimer.end);
                          stopTimeController.text = stoppedTimer.end.toString();
                          stopTimeController.text = stoppedTimer.end.toString();
                          elapsedTimeController.text = _getTimeDifference(
                            stoppedTimer.start,
                            stoppedTimer.end,
                          );
                        },
                      );
                    }
                  },
                ),
                const SizedBox(width: 20),
                resetButton(
                  startTime,
                  stopTime,
                  startTimeController,
                  stopTimeController,
                  elapsedTimeController,
                ),
              ],
            ),
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
        _showTimeResult(elapsedTimeController, 'Elapsed Time'),
        const SizedBox(width: 20),
      ],
    );
  }

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

  Widget resetButton(
      ValueNotifier<Option<StartTime>> startTime,
      ValueNotifier<Option<EndTime>> stopTime,
      TextEditingController startTimeController,
      TextEditingController stopTimeController,
      TextEditingController elapsedTimeController) {
    return OutlinedButton.icon(
      icon: const Icon(
        Icons.restart_alt,
        color: Colors.blue,
      ),
      label: const Text('Reset'),
      //TODO(wltiii): figure out what to do with a running timer. Or once stopped, move to this to list and clearing running timer entry.
      onPressed: () {
        startTime.value = const Option.none();
        stopTime.value = const Option.none();
        startTimeController.clear();
        stopTimeController.clear();
        elapsedTimeController.clear();
      },
    );
  }

  String _getTimeDifference(StartTime startDateTime, EndTime? endDateTime) {
    if (endDateTime != null) {
      Duration difference = endDateTime.difference(startDateTime);
      return '${(difference.inHours).floor().toString().padLeft(2, '0')}:'
          '${(difference.inMinutes % 60).floor().toString().padLeft(2, '0')}:'
          '${(difference.inSeconds % 60).floor().toString().padLeft(2, '0')}';
    } else {
      return '';
    }
  }
}
