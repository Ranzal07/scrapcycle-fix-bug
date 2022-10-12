import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarScrapCycle extends StatelessWidget with PreferredSizeWidget {
  const AppBarScrapCycle({Key? key, required this.titleStr}) : super(key: key);

  final String titleStr;
  // AppBarScrapCycle(this.titleStr);

  @override
  Widget build(BuildContext context) {
    Color myColor = const Color.fromARGB(255, 39, 174, 95);

    return SizedBox(
      height: 120.0,
      child: AppBar(
        backgroundColor: myColor,
        centerTitle: true,
        flexibleSpace: const Image(
          image: AssetImage('assets/images/pricelist-header.png'),
          fit: BoxFit.cover,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20.0),
          ),
        ),
        title: Text(
          titleStr.toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
