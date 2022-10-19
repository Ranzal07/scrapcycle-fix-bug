import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ScheduleState with ChangeNotifier {
  String _scheduleDisplay = "";
  String _selectedDate = "";
  List<String> _items = [""];

  String get scheduleDisplay => _scheduleDisplay;
  String get selectedDate => _selectedDate;
  List<String> get items => _items;

  // String get selectes
  set setSelectedDate(String date) {
    _selectedDate = date;
  }

  void initializeValues({String? value}) async {
    DocumentSnapshot dateSnapshot = await FirebaseFirestore.instance
        .collection('collection-date')
        .doc('Admin')
        .get();
    //  change the DocumentID [doc('')] according to the username
    _scheduleDisplay = dateSnapshot['displayString'];

    // create array of choices
    _items = _scheduleDisplay.split(" & ");
    _selectedDate = value ?? _items[0];

    notifyListeners();
  }
}
