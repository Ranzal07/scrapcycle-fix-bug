import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pricelist/category_bar.dart';
import 'package:pricelist/firebase_crud.dart';
import 'package:pricelist/item.dart';
import 'package:provider/provider.dart';
import 'package:pricelist/providers/category_provider.dart';

class PriceList extends StatefulWidget {
  // ignore: non_constant_identifier_names
  const PriceList({Key? key, required this.ID}) : super(key: key);
  // ignore: non_constant_identifier_names
  final String ID;

  @override
  State<PriceList> createState() => _PriceListState();
}

class _PriceListState extends State<PriceList> {
  final Stream<QuerySnapshot> collectionReference =
      FirebaseCrud.readPricelist();
  final Stream<QuerySnapshot> _categoryStream =
      FirebaseFirestore.instance.collection('pricelist').snapshots();

  Color myColor = const Color.fromARGB(255, 39, 174, 95);
  Color darkGrey = const Color(0xff828282);

  @override
  Widget build(BuildContext context) {
    int currentType = context.watch<CategoryState>().currentType;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      color: const Color(0xffFAFCFB),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.payments,
                size: 28,
                color: Color(0xff828282),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, top: 24.0, bottom: 24.0),
                child: Text(
                  'See how much you’ll earn for your scraps',
                  style: GoogleFonts.inter(
                    fontSize: MediaQuery.of(context).size.height * 0.01 * 2,
                    color: const Color(0xff828282),
                  ),
                ),
              ),
            ],
          ),
          const CategoryBar(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: SizedBox(
              height: 10.0,
              child: Center(
                child: Container(
                  margin:
                      const EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
                  height: 1.0,
                  color: const Color(0xffE0E0E0),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 18.0),
            child: Table(
                    columnWidths: const {
                      0: FlexColumnWidth(1.1),
                      1: FlexColumnWidth(1.2),
                      2: FlexColumnWidth(1),
                      3: FlexColumnWidth(0.9),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(
                        children: [
                          Text(
                            'Items',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Text(
                              'Examples',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Text(
                              'Cleaned',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                          Text(
                              'Uncleaned',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                        ],
                      )
                    ],
                  ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: _categoryStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Container();
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xff219653),
                      ),
                    ),
                  );
                }

                Map<String, dynamic> prices = snapshot.data!.docs[currentType]
                    .data()! as Map<String, dynamic>;

                int priceLen = prices['examples'].length;

                return Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: priceLen,
                    itemBuilder: ((context, index) {
                      return Item(
                        examples: prices['examples'][index],
                        itemName: prices['items'][index],
                        value: prices['value'][index],
                        newvalue: prices['new value'][index],
                      );
                    }),
                  ),
                );
              })
        ],
      ),
    );
  }
}
