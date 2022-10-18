import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChangePage with ChangeNotifier {
  bool isCompleted = true; // Assuming the transaction is complete;
  bool buttonVis = true ;
  String schedID = ' ';


  void checkComplete(String id) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(id).get();
    //  change the DocumentID [doc('')] according to the username
    isCompleted = documentSnapshot['completed?'] ?? true;
    notifyListeners();
  }

  void finished(String id) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(id).get();
    final users = FirebaseFirestore.instance.collection('users');
    final schedule = FirebaseFirestore.instance.collection('schedule');
    isCompleted = documentSnapshot['completed?'];
    if(isCompleted==true){
        users.doc(id).update({'lastSchedule': 'None', 'scheduleID': 'None'}); 
        schedule.doc(schedID).collection('users').doc(id).delete();
    }
    notifyListeners();
  }

  void pendingButtonVisibilty1() async{
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection('collection-date').doc('Admin').get();
        buttonVis = documentSnapshot['allow-cancel-1'];
        notifyListeners();
  }
}
