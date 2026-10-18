class MeterModel {
  String id;
  String name;
  double kwh;
  bool isCritical;
  String icon; // string identifier buat FontAwesome

  MeterModel({
    required this.id,
    required this.name,
    required this.kwh,
    this.isCritical = false,
    this.icon = 'house',
  });
}
