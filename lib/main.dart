import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pricelist/appBars/appbar.dart';
import 'package:pricelist/appBars/homebar.dart';
import 'package:pricelist/appBars/profilebar.dart';
import 'package:pricelist/pages/body.dart';
import 'package:pricelist/pages/pending.dart';
import 'package:pricelist/pages/pricelist.dart';
import 'package:pricelist/pages/profile.dart';
import 'package:pricelist/providers/change_notifier.dart';
import 'package:pricelist/providers/change_provider.dart';
import 'package:pricelist/providers/home_provider.dart';
import 'package:pricelist/pages/sign_in_page.dart';
import 'package:pricelist/providers/schedule_provider.dart';
import 'package:pricelist/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:pricelist/providers/category_provider.dart';
import 'package:pricelist/providers/address_provider.dart';

late bool testProceed;

class StartupLogic {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //  final snapshot = FirebaseFirestore.instance.collection('users').doc(uid).get();
  final Stream<DocumentSnapshot> _admin = FirebaseFirestore.instance
      .collection('collection-date')
      .doc('Admin')
      .snapshots();

  // Future getTestProceed() async {

  //   return admin.data()!['testProceed'];
  // }

  Widget getLandingPage(BuildContext context) {
    return StreamBuilder<User?>(
        stream: _auth.authStateChanges(),
        builder: (BuildContext context, snapshot1) {
          return StreamBuilder<DocumentSnapshot>(
            stream: _admin,
            builder: (context, snapshot2) {
              if (snapshot1.hasData) {
                context.read<UserState>().getUserDetails(snapshot1.data!.uid);
                context.read<Address>().readAddress(snapshot1.data!.uid);

                if (snapshot2.hasData) {
                  Map<String, dynamic> adminData =
                      snapshot2.data!.data() as Map<String, dynamic>;

                  if (adminData['testProceed'] == true) {
                    return Home(userID: snapshot1.data!.uid);
                  } else {
                    return const Construction();
                  }
                }
                return const Construction();
              }
              return SignInPage();
            },
          );
        });
  }
}

class Construction extends StatelessWidget {
  const Construction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarScrapCycle(titleStr: 'scrapcycle'),
      body: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 50.0),
            child: Column(
              children: [
                const Image(
                  image: AssetImage('assets/images/construction.png'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 6.0),
                  child: Text(
                    'ScrapCycle is under construction',
                    style: GoogleFonts.inter(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xff219653),
                    ),
                  ),
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text:
                            "Thank you for downloading ScrapCycle! We will be back in a few weeks. For update, check out our Facebook page at ",
                        style: GoogleFonts.inter(
                          fontSize: 18.0,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: "ScrapCycle.ph",
                        style: GoogleFonts.inter(
                          fontSize: 18.0,
                          color: const Color(0xff219653),
                          fontWeight: FontWeight.w800,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Container(
            height: 150.0,
            width: double.infinity,
            margin: const EdgeInsets.only(top: 10),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/playground.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Change()),
        ChangeNotifierProvider(create: (_) => UserState()),
        ChangeNotifierProvider(create: (_) => CategoryState()),
        ChangeNotifierProvider(create: (_) => Address()),
        ChangeNotifierProvider(create: (_) => HomeState()),
        ChangeNotifierProvider(create: (_) => ChangePage()),
        ChangeNotifierProvider(create: (_) => ScheduleState()),
      ],
      child: MaterialApp(
        title: 'ScrapCycle',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: const LandingPage(),
      ),
    ),
  );
}

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StartupLogic().getLandingPage(context);
  }
}

class Home extends StatefulWidget {
  const Home({Key? key, required this.userID}) : super(key: key);
  final String userID;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // TODO: test this for the login and sign up

    context.read<UserState>().checkSchedule();
    context.read<UserState>().generateSchedule();
    context.read<ChangePage>().checkComplete(widget.userID);
    context.read<ChangePage>().pendingButtonVisibilty1();

    final List<Widget> bodyOptions = [
      context.watch<ChangePage>().isCompleted == true
          ? BodyPage(id: widget.userID)
          : const PendingPage(),
      PriceList(
        ID: widget.userID,
      ),
      const Profile(),
    ];

    final List<PreferredSizeWidget?> navBarOptions = [
      const HomeBar(),
      const AppBarScrapCycle(titleStr: 'Price list'),
      const ProfileBar(),
    ];

    int pageIndex = context.watch<HomeState>().selectedIndex;

    void onItemTapped(int index) {
      context.read<HomeState>().changeIndex(index);
    }

    return Scaffold(
      appBar: navBarOptions.elementAt(pageIndex),
      body: Center(
        child: bodyOptions.elementAt(pageIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xff27AE60),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sell),
            label: 'Price List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: pageIndex,
        selectedItemColor: Colors.white,
        onTap: (int index) => onItemTapped(index),
        selectedLabelStyle: GoogleFonts.inter(),
        unselectedLabelStyle: GoogleFonts.inter(),
      ),
    );
  }
}
