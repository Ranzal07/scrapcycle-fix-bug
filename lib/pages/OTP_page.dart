// ignore_for_file: file_names, use_key_in_widget_constructors, avoid_print, import_of_legacy_library_into_null_safe

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:pricelist/main.dart';
import 'package:pricelist/providers/user_provider.dart';
import 'package:provider/provider.dart';

class OtpControllerScreen extends StatefulWidget {
  final String phone;
  final String name;
  final int stateChange;

  const OtpControllerScreen(
      {required this.phone, required this.name, required this.stateChange});

  @override
  State<OtpControllerScreen> createState() => _OtpControllerScreenState();
}

class _OtpControllerScreenState extends State<OtpControllerScreen> {
  final GlobalKey<ScaffoldState> _scaffolkey = GlobalKey<ScaffoldState>();
  final TextEditingController _pinOTPCodeController = TextEditingController();
  final FocusNode _pinOTPCodeFocus = FocusNode();
  String? verificationCode;
  bool showLoader = false;

  final BoxDecoration pinOTPCodeDecoration = BoxDecoration(
    color: Colors.greenAccent,
    borderRadius: BorderRadius.circular(10.0),
  );

  @override
  //TODO AUTO SENT CODE WHEN VISITED THE PAGE
  void initState() {
    super.initState();
    verifyPhoneNumber();
  }

  //TODO FIREBASE FUNCTION FOR SMS
  verifyPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+63 ${widget.phone}",
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) {
          if (value.user != null) {
            if (widget.stateChange == 0) {
              context.read<UserState>().createUser(
                  value.user!.uid, widget.name, "+63${widget.phone}");
            }

            context.read<UserState>().getUserDetails(value.user!.uid);

            //TODO
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LandingPage()),
                (Route<dynamic> route) => false);
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message.toString()),
            duration: const Duration(seconds: 3),
          ),
        );
      },
      codeSent: (String vID, int? resentToken) {
        setState(() {
          verificationCode = vID;
        });
      },
      codeAutoRetrievalTimeout: (verificationID) async {
        setState(() {
          verificationCode = verificationID;
        });
      },
      timeout: const Duration(seconds: 60),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffolkey,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //TODO HIDDEN GESTURE AND DISPLAY PHONE NUMBER
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      verifyPhoneNumber();
                    },
                    child: Text(
                      "Enter the 6-digit code sent to +63${widget.phone}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
              ),

              //TODO PIN DESIGN AND MANUAL INPUT
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: PinPut(
                  fieldsCount: 6,
                  textStyle:
                      const TextStyle(fontSize: 25.0, color: Colors.white),
                  eachFieldWidth: 40.0,
                  eachFieldHeight: 55.0,
                  focusNode: _pinOTPCodeFocus,
                  controller: _pinOTPCodeController,
                  submittedFieldDecoration: pinOTPCodeDecoration,
                  selectedFieldDecoration: pinOTPCodeDecoration,
                  followingFieldDecoration: pinOTPCodeDecoration,

                  //pinAnimationType: PinAnimationType.rotation,
                  onSubmit: (pin) async {
                    setState(() {
                      showLoader = true;
                    });

                    try {
                      //TODO MANUAL INPUT SIGN UP OR LOGIN
                      await FirebaseAuth.instance
                          .signInWithCredential(PhoneAuthProvider.credential(
                              verificationId: verificationCode!, smsCode: pin))
                          .then((value) => {
                                if (value.user != null)
                                  {
                                    if (widget.stateChange == 0)
                                      {
                                        context.read<UserState>().createUser(
                                            value.user!.uid,
                                            widget.name,
                                            "+63${widget.phone}"),
                                      },

                                    // context
                                    //     .read<UserState>()
                                    //     .getUserDetails(value.user!.uid),

                                    // Navigator.of(context).push(
                                    //   MaterialPageRoute(
                                    //     builder: (c) => const LandingPage(),
                                    //   ),
                                    // ),

                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LandingPage()),
                                        (Route<dynamic> route) => false),
                                    //password and name needs to be passed on database
                                  },
                              });
                    }
                    //TODO MANUAL INPUT INVALID OTP
                    catch (e) {
                      setState(() {
                        showLoader = false;
                      });

                      FocusScope.of(context).unfocus();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Invalid OTP"),
                          duration: Duration(seconds: 10),
                        ),
                      );
                    }
                  },
                ),
              )
            ],
          ),
          if (showLoader == true)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: const Color.fromARGB(172, 33, 150, 84),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            )
        ],
      ),
    );
  }
}
