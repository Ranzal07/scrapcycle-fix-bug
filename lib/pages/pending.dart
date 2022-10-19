import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/change_notifier.dart';
import '../providers/user_provider.dart';

class PendingPage extends StatefulWidget {
  const PendingPage({Key? key}) : super(key: key);

  @override
  State<PendingPage> createState() => _PendingPageState();
}

class _PendingPageState extends State<PendingPage> {
  @override
  Widget build(BuildContext context) {
    void showError(int errorType) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              errorType == 1 ? 'Check your internet connection' : 'Try again!'),
        ),
      );
    }

        final userID = context.read<UserState>().getUserID;
        final scheduleChoice = context.read<UserState>().getLastSchedule;
        final year = DateTime.now().year;

    Future dataSend() async {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {

        final schedule = FirebaseFirestore.instance.collection('schedule');
        final users = FirebaseFirestore.instance.collection('users');

        try {
            await users
                .doc(userID)
                .update({'completed?': true})
                .then((value) {
                    schedule.doc('$scheduleChoice, $year').collection('users').doc(userID).delete();
                    users.doc(userID).update({'lastSchedule': 'None', 'scheduleID': 'None'});
            });
            // Navigator.pop(context);
        } catch (e) {
            showError(2);
            return;
        }

      } else {
        showError(1);
        return;
      }

      
    }

    return Column(
      //mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Container(
                  height: 110,
                  width: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage("assets/images/pending-truck.png"),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Your collection schedule has been successfully placed!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                    color: const Color(0xff219653),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                alignment: Alignment.topCenter,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            "Our scrap collector will arrive soon to collect your recyclables on ",
                        style: GoogleFonts.inter(
                          fontSize: 18.0,
                          color: const Color(0xff1A535C),
                        ),
                      ),
                      
                      TextSpan(
                        text:
                            "${context.watch<UserState>().getLastSchedule}.\n",
                        style: GoogleFonts.inter(
                          fontSize: 18.0,
                          color: const Color(0xff219653),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text:
                            "Thank you for your environmental efforts, scrapper!",
                        style: GoogleFonts.inter(
                          fontSize: 18.0,
                          color: const Color(0xff1A535C),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Note: You can cancel your schedule anytime until the collection schedule comes.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff1A535C),
                    ),
                  ),
                ),
              ),
              context.watch<ChangePage>().buttonVis==false ? 
                Container(margin: const EdgeInsets.only(top: 50)) 
            : Container(
                  color: Colors.transparent,
                  child: Visibility(
                    visible: context.watch<ChangePage>().buttonVis,
                    child: ElevatedButton(
                      onPressed: () {
                        dataSend();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF27AE60),
                        disabledForegroundColor: Colors.black.withOpacity(0.38), disabledBackgroundColor: Colors.black.withOpacity(0.12),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                      ),
                      child: Text('Cancel Schedule',
                          style: GoogleFonts.inter(color: Colors.white)), 
                    ),
                  )),
            ],
          ),
        ),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/playground.png"),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
