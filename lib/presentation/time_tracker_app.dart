import 'package:flutter/material.dart';
import 'package:time_tracker/application/usecases/start_timer/start_timer_action.dart';
import 'package:time_tracker/application/usecases/stop_timer/stop_timer_action.dart';
import 'package:time_tracker/domain/time_entries/value_objects/time_entry_id.dart';
import 'package:time_tracker/infrastructure/repositories/time_entry_repository_mock.dart';

final repo = TimeEntryRepositoryMock();

class TimeTrackerApp extends StatelessWidget {
  final _startTimerAction = StartTimerAction(repo);
  final _stopTimerAction = StopTimerAction(repo);

  TimeTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final startTimeController = TextEditingController();
    final stopTimeController = TextEditingController();
    final elapsedTimeController = TextEditingController();
    // TODO(wltiii): Does this have to be nullable? Possibly the Either?
    final ValueNotifier<DateTime?> startTime = ValueNotifier(null);
    final ValueNotifier<DateTime?> stopTime = ValueNotifier(null);
    TimeEntryId? timeEntryId;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Difference between DateTime'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                ElevatedButton(
                  child: const Text('Start'),
                  onPressed: () async {
                    final result = await _startTimerAction();
                    result.fold(
                      //TODO(wltiii): handle failure
                      (failure) => {},
                      (startedTimer) {
                        //TODO(wltiii): use StartTime rather than dateTime???
                        startTime.value = startedTimer.start.dateTime;
                        timeEntryId = startedTimer.id;
                        startTimeController.text =
                            _formatDateTime(startedTimer.start.dateTime);
                      },
                    );
                  },
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  child: const Text('Stop'),
                  onPressed: () async {
                    // TODO(wltiii): There should be one button and it switches state as appropriate obviating the need for this check
                    if (timeEntryId != null) {
                      final result = await _stopTimerAction(timeEntryId!);
                      result.fold(
                        //TODO(wltiii): handle failure
                        (failure) => {},
                        (stoppedTimer) {
                          timeEntryId = null;
                          //TODO(wltiii): use EndTime rather than dateTime???
                          stopTime.value = stoppedTimer.end.dateTime;
                          stopTimeController.text =
                              _formatDateTime(stoppedTimer.end.dateTime);
                          elapsedTimeController.text = _getTimeDifference(
                            stoppedTimer.start.dateTime,
                            stoppedTimer.end.dateTime,
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
                // const SizedBox(width: 20),
                // // TODO(wltiii): use ElevatedButton.icon() and have this be the only button
                // ElevatedButton(
                //   child: const Text('Start It'),
                //   onPressed: () {},
                // ),
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
      // mainAxisAlignment: MainAxisAlignment.center,
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
      ValueNotifier<DateTime?> startTime,
      ValueNotifier<DateTime?> stopTime,
      TextEditingController startTimeController,
      TextEditingController stopTimeController,
      TextEditingController elapsedTimeController) {
    return ElevatedButton(
      child: const Text('Reset'),
      onPressed: () {
        startTime.value = null;
        stopTime.value = null;
        startTimeController.clear();
        stopTimeController.clear();
        elapsedTimeController.clear();
      },
    );
  }

  String _getTimeDifference(DateTime startDateTime, DateTime? endDateTime) {
    if (endDateTime != null) {
      Duration difference = endDateTime.difference(startDateTime);
      return '${(difference.inHours).floor().toString().padLeft(2, '0')}:'
          '${(difference.inMinutes % 60).floor().toString().padLeft(2, '0')}:'
          '${(difference.inSeconds % 60).floor().toString().padLeft(2, '0')}';
    } else {
      return '';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return dateTime.toString() ?? '';
  }
}
