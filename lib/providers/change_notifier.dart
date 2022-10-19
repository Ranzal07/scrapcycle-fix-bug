import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChangePage with ChangeNotifier {
  bool isCompleted = true; // Assuming the transaction is complete;
  bool buttonVis = true ;


  void checkComplete(String id) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(id).get();
    final users = FirebaseFirestore.instance.collection('users').doc(id);
    //  change the DocumentID [doc('')] according to the username
    isCompleted = documentSnapshot['completed?'] ?? true;
    if(isCompleted==true){
        users.update({'lastSchedule': 'None', 'scheduleID': 'None'});
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
