// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserState with ChangeNotifier {
  String _userID = ' ';
  String _userName = ' ';
  String _phoneNumber = ' ';
  String _lastSchedule = ' ';
  String _schedID = ' ';

  String get getUserID => _userID;
  String get getUserName => _userName;
  String get getPhoneNumber => _phoneNumber;
  String get getLastSchedule => _lastSchedule;
  String get getSchedID => _schedID;

  set setLastSchedule(String date) {
    _lastSchedule = date;
    notifyListeners();
  }

  // set setUserID(String id) {
  //   _userID = id;
  // }

  // set setUserName(String? name) {
  //   _userName = name;
  // }

  Future<String> createUser(String uid, String name, String phone) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'fullname': name,
        'phone': phone,
        'completed?': true,
      });
    } catch (e) {
      print(e);
    }
    return 'success';
  }

  Future getUserDetails(String uid) async {
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (snapshot.exists) {
      _phoneNumber = snapshot.data()!['phone'];
      _userName = snapshot.data()!['fullname'];
      _userID = uid;
    }
    notifyListeners();
  }

  Future generateSchedule() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(_userID).get();

    if (snapshot.exists) {
      _schedID = snapshot.data()!['scheduleID'];
    }
    notifyListeners();
  }
  Future checkSchedule() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(_userID).get();

    if (snapshot.exists) {
      _lastSchedule = snapshot.data()!['lastSchedule'];
    }
    notifyListeners();
  }
}
