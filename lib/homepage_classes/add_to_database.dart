import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddToDatabase {
  static void dataSend(BuildContext context, DateTime sched, String id) async {
    var users = FirebaseFirestore.instance.collection(
        'users'); // DocumentID: 'Admin'     Document Field: schedule-date: <timestamp> value

    users.doc(id).update({'completed?': false});

    Navigator.pop(context);
  }
}
