import 'package:flutter/material.dart';

class HomeState with ChangeNotifier {
  int _selectedIndex = 0;
  int _errorCheck = 0;
  String _collectionDate = "";
  String _dateID = "";


  int get selectedIndex => _selectedIndex;
  int get errorCheck => _errorCheck;
  String get collectionDate => _collectionDate;
  String get dateID => _dateID;

  void changeDateID(String newDateID) {
    _dateID = newDateID;
    notifyListeners();
  }

  void changeIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void changeError(int errorCode) {
    _errorCheck = errorCode;
    notifyListeners();
  }

  void changeCollectionDate(String date) {
    _collectionDate = date;
    notifyListeners();
  }
}
