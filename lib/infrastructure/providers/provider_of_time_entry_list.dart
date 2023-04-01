import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_tracker/domain/time_entries/time_entry.dart';
import 'package:time_tracker/infrastructure/providers/provider_of_firestore.dart';
import 'package:time_tracker/infrastructure/repositories/time_entry_repository_impl.dart';

final providerOfTimeEntryList = StreamProvider.autoDispose<List<TimeEntry>>(
  (ref) {
    final db = ref.read(providerOfFirestore);
    final repository = TimeEntryRepositoryImpl(db);

    late Stream<List<TimeEntry>> stream;
    StreamSubscription<List<TimeEntry>>? subscription;

    final result = repository.getList();

    if (result.isRight()) {
      result.fold((l) => null, (r) => stream = r);
      subscription = stream.listen((event) {});
    } else {
      return const Stream.empty();
    }
    ref.onDispose(() {
      subscription?.cancel();
    });
    return stream;
  },
);
