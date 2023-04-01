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
import 'package:time_tracker/infrastructure/repositories/time_entry_repository_impl.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;
final repo = TimeEntryRepositoryImpl(db);
final logger = Logger(
  printer: PrettyPrinter(printTime: true),
);
// TODO(wltiii) should this be an extension to datetime?
final dateFormatter = DateFormat('MM/dd/yyyy HH:MM:ss');
final providerOfRunningTimerId = StateProvider<TimeEntryId?>((ref) => null);

class TimeTrackerApp extends ConsumerWidget {
  const TimeTrackerApp({super.key});

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    ref.watch(providerOfTimeEntryList);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Time Entries'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TimeEntryList(),
            const SizedBox(height: 20),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                StartStopButton(),
              ],
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

class TimeEntryList extends ConsumerWidget {
  const TimeEntryList({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(providerOfTimeEntryList).when(
          loading: () {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
          error: (error, stacktrace) => Text('Error: $error'),
          data: (timeEntries) {
            return Expanded(
              child: ListView.builder(
                itemCount: timeEntries.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: DateTimeRow(
                      startTimeController: TextEditingController(
                          text: dateFormatter
                              .format(timeEntries[index].start.dateTime)),
                      stopTimeController: timeEntries[index].end.isInfinite
                          ? TextEditingController(text: '')
                          : TextEditingController(
                              text: dateFormatter
                                  .format(timeEntries[index].end.dateTime)),
                      elapsedTimeController: timeEntries[index].end.isInfinite
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

class DateTimeRow extends StatelessWidget {
  const DateTimeRow({
    required this.startTimeController,
    required this.stopTimeController,
    required this.elapsedTimeController,
    super.key,
  });

  final TextEditingController startTimeController;
  final TextEditingController stopTimeController;
  final TextEditingController elapsedTimeController;

  @override
  Widget build(BuildContext context) {
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

  //TODO(wltiii): convert this a class
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
}

class StartStopButton extends ConsumerWidget {
  const StartStopButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final runningTimerId = ref.watch(providerOfRunningTimerId);

    return OutlinedButton.icon(
      icon: runningTimerId == null ? const StartIcon() : const StopIcon(),
      label: runningTimerId == null ? const Text('Start') : const Text('Stop'),
      onPressed: () async {
        //TODO(wltiii): use injection for repo...
        final startTimerAction = StartTimerAction(repo);
        if (runningTimerId == null) {
          //TODO(wltiii): inject or inline instantiation as doing with stop???
          final result = await startTimerAction();
          //TODO(wltiii): handle left condition
          result.fold((l) => l, (r) {
            ref.read(providerOfRunningTimerId.notifier).state = r.id;
          });
        } else {
          //TODO(wltiii): inject or separate instantiation as doing with start???
          final result = await StopTimerAction(repo)(runningTimerId);
          //TODO(wltiii): handle left condition
          result.fold((l) => l, (r) {
            ref.read(providerOfRunningTimerId.notifier).state = null;
          });
        }
      },
    );
  }
}

class StartIcon extends StatelessWidget {
  const StartIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.play_arrow,
      color: Colors.green,
    );
  }
}

class StopIcon extends StatelessWidget {
  const StopIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.stop_circle,
      color: Colors.red,
    );
  }
}
