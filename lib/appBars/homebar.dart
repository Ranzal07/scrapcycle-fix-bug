import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pricelist/pages/set_address.dart';
import 'package:pricelist/providers/address_provider.dart';
import 'package:provider/provider.dart';

class HomeBar extends StatelessWidget with PreferredSizeWidget {
  const HomeBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color myColor = const Color.fromARGB(255, 39, 174, 95);

    String address = (context.watch<Address>().roomNumber == '')
        ? 'Edit address to start '
        : '${context.watch<Address>().roomNumber} ${context.watch<Address>().street} ${context.watch<Address>().barangay} ${context.watch<Address>().city}';

    return AppBar(
      toolbarHeight: 120,
      backgroundColor: myColor,
      centerTitle: true,
      title: Text(
        'Collection Enlistment'.toUpperCase(),
        style: GoogleFonts.inter(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 15, 0),
          child: const Icon(Icons.recycling),
        ),
      ],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        // here the desired height
        child: Center(
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SetAddress()),
              );
            },
            child: FractionallySizedBox(
              widthFactor: 0.9,
              child: Container(
                padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                margin: const EdgeInsets.only(bottom: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  border: Border.all(
                    color: const Color.fromARGB(125, 33, 150, 84),
                    width: 2.5,
                  ),
                  color: Colors.white,
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          address,
                          style: const TextStyle(
                            fontSize: 15,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const Icon(Icons.my_location, size: 18),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(85);
}
