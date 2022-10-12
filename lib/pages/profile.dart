import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pricelist/pages/set_address.dart';
import 'package:provider/provider.dart';
import 'package:pricelist/providers/user_provider.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          child: Stack(
            children: <Widget>[
              ClipPath(
                clipper: CustomShape(),
                child: Container(height: 150, color: const Color(0xff27ae60)),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      height: 130,
                      width: 140,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 207, 255, 195),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 8),
                        image: const DecorationImage(
                          //fit: BoxFit.fill,
                          scale: 10.9,
                          alignment: Alignment.bottomCenter,
                          image: NetworkImage(
                              'https://upload.wikimedia.org/wikipedia/commons/thumb/7/72/Avatar_icon_green.svg/1200px-Avatar_icon_green.svg.png'),
                        ),
                      ),
                    ),
                    Text(
                      context.watch<UserState>().getUserName,
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      context.watch<UserState>().getPhoneNumber,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    const ChangeAddress(),
                    const LogOut(),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class ChangeAddress extends StatelessWidget {
  const ChangeAddress({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SetAddress()),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          children: <Widget>[
            Container(
              width: 40.0,
              height: 40.0,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.pin_drop,
                color: Colors.lightGreen,
              ),
            ),
            const SizedBox(width: 20),
            Text(
              "Change Address",
              style: GoogleFonts.inter(fontSize: 16, color: Colors.black),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }
}

class LogOut extends StatelessWidget {
  const LogOut({
    Key? key,
  }) : super(key: key);

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _signOut();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          children: <Widget>[
            Container(
              width: 40.0,
              height: 40.0,
              // padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.logout,
                color: Colors.lightGreen,
                size: 20.0,
              ),
            ),
            const SizedBox(width: 20),
            Text(
              "Log out",
              style: GoogleFonts.inter(fontSize: 16, color: Colors.black),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }
}

class CustomShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double height = size.height;
    double width = size.width;
    path.lineTo(0, height - 130);
    path.quadraticBezierTo(width / 2, 130, width, height - 130);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
