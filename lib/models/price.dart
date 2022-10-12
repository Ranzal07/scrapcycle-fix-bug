class Price {
  String? id;
  String? itemName;
  List<String>? examples;
  String? value;
  int? type;

  Price(
      {required this.id,
      required this.examples,
      required this.itemName,
      required this.type,
      required this.value});
}
