import 'sepet_yemek.dart';

class SepetCevap {
  final List<SepetYemek> sepetYemekler;

  SepetCevap({required this.sepetYemekler});

  factory SepetCevap.fromJson(Map<String, dynamic> json) {
    var list = json['sepet_yemekler'] as List? ?? [];
    return SepetCevap(
      sepetYemekler: list.map((e) => SepetYemek.fromJson(e)).toList(),
    );
  }
}
