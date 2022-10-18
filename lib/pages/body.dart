// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pricelist/pages/set_address.dart';
import 'package:pricelist/providers/address_provider.dart';
import 'package:pricelist/providers/change_notifier.dart';
import 'package:pricelist/providers/home_provider.dart';
import 'package:pricelist/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class BodyPage extends StatefulWidget {
  const BodyPage({Key? key, required this.id}) : super(key: key);
  final String id;
  @override
  State<BodyPage> createState() => _BodyPageState();
}

class _BodyPageState extends State<BodyPage> {
  var scheduleChoice = "",
      scheduleDisplay = "",
      defaultSchedule = true,
      Identifier;
  late List<String> items;

  @override
  void initState() {
    super.initState();
  }

  DateTime date = DateTime.now();
  Stream<DocumentSnapshot> getSchedDate = FirebaseFirestore.instance
      .collection('collection-date')
      .doc('Admin')
      .snapshots(); // DocumentID: 'Admin'     Document Field: schedule-date: <timestamp> value

  String extractWeekday(int weekdayNum) {
    String weekday = '';

    switch (weekdayNum) {
      case 1:
        weekday = 'Mon';
        break;
      case 2:
        weekday = 'Tue';
        break;
      case 3:
        weekday = 'Wed';
        break;
      case 4:
        weekday = 'Thur';
        break;
      case 5:
        weekday = 'Fri';
        break;
      case 6:
        weekday = 'Sat';
        break;
      case 7:
        weekday = 'Sun';
        break;
      default:
    }

    return weekday;
  }

  // DateTime datetime
  int checkError = 0;

  DateTime scheduleDate1 = DateTime.now();
  DateTime scheduleDate2 = DateTime.now();
  int indexDate = 0;

  // void changeDate(DateTime choice) {
  //   setState(() {
  //     datetime = choice;
  //   });
  // }

  // List<String> items = [""];
  // String selectedDate = "";

  @override
  Widget build(BuildContext context) {
    // setState(() {

    // selectedDate = context.read<ScheduleState>().selectedDate;
    // });
    // scheduleDisplay = context.watch<ScheduleState>().scheduleDisplay;

    void showError(int errorType) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              errorType == 1 ? 'Check your internet connection' : 'Try again!'),
        ),
      );
    }

    Future dataSend() async {
      // print(datetime);
      context.read<HomeState>().changeCollectionDate(scheduleChoice);

      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.mobile ||
          connectivityResult == ConnectivityResult.wifi) {
      } else {
        showError(1);
        return;
      }

      var users = FirebaseFirestore.instance.collection('users');
      var schedule = FirebaseFirestore.instance.collection('schedule');
      // var address = FirebaseFirestore.instance.collection('address');
      String userID = context.read<UserState>().getUserID;

      // DocumentID: 'Admin'     Document Field: schedule-date: <timestamp> value
      DateTime datetime = DateTime.now();
      final indexOfChoice =
          items.lastIndexWhere((element) => element == scheduleChoice);

      switch (indexOfChoice) {
        case 0:
          datetime = scheduleDate1;
          break;
        case 1:
          datetime = scheduleDate2;
          break;
      }

      int day = datetime.day;
      int month = datetime.month;
      int year = datetime.year;
      DateTime dateOfSubscription = DateTime.now();

      String dateID = '$day-$month-$year';
      context.read<HomeState>().changeDateID(dateID);
      context.read<ChangePage>().schedID = '$scheduleChoice, $year';

      try {
        await schedule.doc('$scheduleChoice, $year').collection('users').doc(userID).set({
          'id': userID,
          'dateOfSubscription': dateOfSubscription,
        }).then((value) {
          users.doc(context.read<UserState>().getUserID).update({
            'completed?': false,
            'scheduleID': dateID,
            'lastSchedule': scheduleChoice
          });
        }).then((value) {
          context.read<UserState>().generateSchedule();
          context.read<UserState>().setLastSchedule = scheduleChoice;
        });
        // Navigator.pop(context);
      } catch (e) {
        showError(2);
        return;
      }
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Wrap(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 15, 0, 10),
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Next scrap collection date:',
                    style: GoogleFonts.inter(
                      fontSize: 17.0,
                    ),
                  ),
                ),
                StreamBuilder<DocumentSnapshot>(
                    stream: getSchedDate,
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasData) {
                        Map<String, dynamic> dateSnapshot =
                            snapshot.data!.data() as Map<String, dynamic>;

                        String scheduleDisplay = dateSnapshot['displayString'];
                        items = scheduleDisplay.split(" & ");

                        if (defaultSchedule) scheduleChoice = items[0];

                        scheduleDate1 =
                            dateSnapshot['schedule-date-1'].toDate();
                        scheduleDate2 =
                            dateSnapshot['schedule-date-2'].toDate();

                        return Column(
                          children: [
                            Container(
                              alignment: Alignment.topCenter,
                              child: Text(
                                scheduleDisplay,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: const Color(0xff219653),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 15.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color.fromARGB(255, 149, 168, 153)
                                            .withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    offset: const Offset(
                                        5, 0), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(bottom: 18),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Select collection date:  ',
                                          style: GoogleFonts.inter(
                                            fontSize: 15.0,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 5),
                                          decoration: const ShapeDecoration(
                                            shape: StadiumBorder(
                                              side: BorderSide(
                                                color: Color(0xff219653),
                                              ),
                                            ),
                                          ),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              isDense: true,
                                              value: scheduleChoice,
                                              icon: const Icon(
                                                  Icons.arrow_drop_down,
                                                  color: Color(0xff219653)),
                                              items: items
                                                  .map<
                                                      DropdownMenuItem<String>>(
                                                    (items) => DropdownMenuItem(
                                                      value: items,
                                                      child: Text(
                                                        items,
                                                        style:
                                                            GoogleFonts.inter(
                                                          color: const Color(
                                                              0xff219653),
                                                          fontSize: 15.0,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                              onChanged: (newValue) {
                                                // context
                                                //     .read<ScheduleState>()
                                                //     .setSelectedDate = newValue!;

                                                setState(() {
                                                  defaultSchedule = false;
                                                  scheduleChoice = newValue!;
                                                });

                                                // print(newValue);
                                                // setDate(newValue);
                                              },
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            if (context
                                                    .read<Address>()
                                                    .roomNumber !=
                                                '') {
                                              return AlertDialog(
                                                title: Center(
                                                  child: Text(
                                                    'Confirm your collection?',
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                content: SingleChildScrollView(
                                                  child: Text(
                                                    'By confirming this, you agree that ScrapCycle will collect your scraps on the day shown in the screen.',
                                                    textAlign: TextAlign.center,
                                                    style: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context, rootNavigator: true).pop();
                                                    },
                                                    child: Text('Back',
                                                        style:
                                                            GoogleFonts.inter(
                                                                color: Colors
                                                                    .red)),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context, rootNavigator: true).pop();
                                                      dataSend();
                                                    },
                                                    child: Text('Confirm',
                                                        style:
                                                            GoogleFonts.inter(
                                                                color: Colors
                                                                    .green)),
                                                  ),
                                                ],
                                                elevation: 25,
                                              );
                                            }

                                            return AlertDialog(
                                              title: Center(
                                                child: Text(
                                                  'Set your address to continue',
                                                  textAlign: TextAlign.center,
                                                  style: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('Back',
                                                      style: GoogleFonts.inter(
                                                          color: Colors.red)),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const SetAddress()),
                                                    );
                                                  },
                                                  child: Text('Ok',
                                                      style: GoogleFonts.inter(
                                                          color: Colors.green)),
                                                ),
                                              ],
                                              elevation: 25,
                                            );
                                          });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF27AE60),
                                      // disabledForegroundColor: Colors.black.withOpacity(0.38),
                                      // disabledBackgroundColor: Colors.black.withOpacity(0.12),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 15.0,
                                        horizontal: 50.0,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Collect My Scraps! ',
                                          style: GoogleFonts.inter(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Image.asset("assets/images/truck.png",
                                            scale: 0.8),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                      return Container();
                    }),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                "ScrapCycle buys your recyclables when you set a schedule by clicking the",
                            style: GoogleFonts.inter(
                              fontSize: 18.0,
                              color: Colors.black87,
                            ),
                          ),
                          TextSpan(
                            text: " 'Collect My Scraps' ",
                            style: GoogleFonts.inter(
                              fontSize: 18.0,
                              color: const Color(0xff219653),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          TextSpan(
                            text:
                                "button at the collection date shown.",
                            style: GoogleFonts.inter(
                              fontSize: 18.0,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
