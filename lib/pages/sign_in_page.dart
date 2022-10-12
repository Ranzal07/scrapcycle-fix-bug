// ignore_for_file: use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors, camel_case_types, library_private_types_in_public_api, import_of_legacy_library_into_null_safe, prefer_final_fields

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

//import 'log_in/whole_login.dart';

//import '../../OTP/showOTPdialog.dart';
import '../../../providers/change_provider.dart';
import 'OTP_page.dart';

int x = 0;

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

//TODO CHECKING IF A USER EXIST
  Future userExist(String number) async {
    FirebaseFirestore.instance
        .collection("users")
        .where('phone', isEqualTo: number)
        .get()
        .then((result) {
      if (result.docs.isNotEmpty) {
        if (x == 1) {
          return gotoOPT();
        }

        return errorMessage();
      } else {
        if (x == 1) {
          return errorMessage();
        }
        return gotoOPT();
      }
      //return 'success';
    });
  }

//TODO ERROR MESSAGE IF A USER EXIST OR NOT
  void errorMessage() {
    context.read<Change>().iconVisibility();
    if (x == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("This account doesn't exist, please register"),
          duration: const Duration(seconds: 7),
        ),
      );
    } else if (x == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("This account already exist, please login"),
          duration: const Duration(seconds: 7),
        ),
      );
    }
  }

//TODO GO TO OTP DECIDER
  void gotoOPT() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (c) => OtpControllerScreen(
              phone: _phoneController.text,
              name: _nameController.text,
              stateChange: x,
            )));
  }

  @override
  Widget build(BuildContext context) {
    //TODO CHANGING VALUES
    Color c = const Color(0xFF616161);
    bool state = (context.watch<Change>().count == 0) ? true : false;
    if (state == true) {
      x = 0;
    } else {
      x = 1;
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              //TODO SCRAPCYCYLE IMAGE
              SizedBox(
                width: MediaQuery.of(context).size.width * 1,
                child: Container(
                  color: Color(0xFFe9fff2),
                  child: Image.asset(
                    'assets/images/1_sign_in.png',

                    fit: BoxFit.fitWidth,
                    //alignment: Alignment.topCenter,
                  ),
                ),
              ),

              //TODO WHOLE CONTAINER OF SIGN UP OR LOGIN FORM
              Container(
                //height: MediaQuery.of(context).size.height * 0.70,
                width: MediaQuery.of(context).size.width * 1,
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 1),
                //color: Colors.yellow,
                child: Column(
                  children: <Widget>[
                    //TODO SIGNUP OR LOGIN TEXT
                    Container(
                      padding: const EdgeInsets.only(top: 10),
                      height: 50,
                      width: MediaQuery.of(context).size.width * 1,
                      //color: Colors.brown,
                      child: Text(context.watch<Change>().string1,
                          style: const TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Inter',
                          )),
                    ),

                    //TODO SIGN OR LOGIN FORM
                    SizedBox(
                      //height: 160,
                      width: MediaQuery.of(context).size.width * 1,
                      //color: Colors.red,

                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp("^9[0-9]*")),
                              ],
                              maxLength: 10,
                              onTap: () {
                                c = Colors.green;
                              },
                              controller: _phoneController,
                              decoration: InputDecoration(
                                counterText: '',
                                prefixIcon: Text(
                                  '+63 ',
                                  style: TextStyle(
                                    color: c,
                                    fontSize: 15,
                                  ),
                                ),
                                prefixIconConstraints: BoxConstraints(),
                                suffixIcon: Visibility(
                                  visible: context.watch<Change>().visible,
                                  child: Icon(
                                    Icons.error,
                                    color: Colors.red,
                                  ),
                                ),
                                suffixIconConstraints: BoxConstraints(),
                                hintText: 'Phone Number',
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Phone Number can not be empty';
                                } else if (value.length < 10) {
                                  return 'Invalid Phone Number';
                                } else {
                                  return null;
                                }
                              },
                            ),
                            Visibility(
                              visible: state,
                              child: TextFormField(
                                controller: _nameController,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp("[a-zA-Z .]")),
                                ],
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.edit),
                                  prefixIconConstraints: BoxConstraints(),
                                  hintText: 'Fullname',
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Give us your Full Name';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    //TODO LOGIN OR SIGN UP BUTTON
                    Container(
                      //height: 75,
                      width: MediaQuery.of(context).size.width * 1,
                      padding: const EdgeInsets.only(top: 28),
                      //color: Colors.pink,
                      child: ElevatedButton(
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          } else {
                            userExist("+63${_phoneController.text}");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: const Color(0xFF27AE60),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          context.watch<Change>().string2,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),

                    //TODO GESTURE FOR PROVIDER
                    Container(
                      padding: const EdgeInsets.only(
                        top: 15,
                        bottom: 30,
                      ),
                      //height: ,
                      //color: Colors.orange,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            context.watch<Change>().string3,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.read<Change>().cchange(),
                            child: Text(
                              context.watch<Change>().string4,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0B6732),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
