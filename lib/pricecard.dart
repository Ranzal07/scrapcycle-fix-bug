import 'package:flutter/material.dart';

class PriceCard extends StatelessWidget {
  const PriceCard({
    Key? key,
    required this.examplesList,
    required this.item,
    required this.value,
  }) : super(key: key);

  final List<String> examplesList;
  final String item;
  final String value;

  String bulletedList(List<String> list) {
    return '• ${list.map((item) => item).join(' • ')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14.0),
      padding: const EdgeInsets.symmetric(vertical: 18.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 149, 168, 153).withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(5, 0), // changes position of shadow
          ),
        ],
      ),
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: TableBorder.symmetric(
          outside: BorderSide.none,
          inside: const BorderSide(
              width: 1, color: Colors.grey, style: BorderStyle.solid),
        ),
        columnWidths: const {
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(1),
        },
        children: [
          TableRow(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    item,
                    style: const TextStyle(
                      color: Color(0xff219653),
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    bulletedList(examplesList),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Center(
                child: Text(value),
              ),
            ],
          )
        ],
      ),
    );
  }
}
