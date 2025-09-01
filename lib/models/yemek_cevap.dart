import 'yemek.dart';

class YemeklerCevap {
  List<Yemek> yemekler;

  YemeklerCevap({required this.yemekler});

  factory YemeklerCevap.fromJson(Map<String, dynamic> json) {
    var list = json['yemekler'] as List? ?? [];
    return YemeklerCevap(
      yemekler: list.map((e) => Yemek.fromJson(e)).toList(),
    );
  }
}
