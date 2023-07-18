import 'package:cloud_firestore/cloud_firestore.dart';

mixin FirebaseMixin {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
}
