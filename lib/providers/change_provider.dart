import 'package:flutter/material.dart';

class Change with ChangeNotifier{
  List<String> strArr = ['Sign Up','Sign In'];
  List<String> strArr1 = ['Register','Login',];
  List<String> strArr2 = ['Already Have an Account? ','Don\'t have an account? ',];
  List<String> strArr3 = ['Login','Register',];
  int _count = 0;
  bool _visible = false;

  String get string1 => strArr[_count];
  String get string2 => strArr1[_count];
  String get string3 => strArr2[_count];
  String get string4 => strArr3[_count];
  int get count => _count;
  bool get visible => _visible;

  void cchange(){
    if(_count == 0){
      _count = 1;
    }
    else{
      _count = 0;
    }
    notifyListeners();
  }
  
  void iconVisibility(){
    if(_visible == false){
      _visible = true;
    }
    else{
      _visible = false;
    }
    notifyListeners();
  }

}