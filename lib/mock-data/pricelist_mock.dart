class PriceListData {
  late String item;
  late String value;
  late List<String> examples;

  PriceListData(this.item, this.value, this.examples);

  PriceListData.fromJson(Map<String, dynamic> json) {
    item = json['item'];
    value = json['value'];
    examples = json['examples'];
  }
}
