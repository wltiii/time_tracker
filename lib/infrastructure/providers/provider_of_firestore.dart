import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final providerOfFirestore =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);
