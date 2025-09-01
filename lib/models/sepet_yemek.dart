class SepetYemek {
  final String sepetYemekId;
  final String yemekAdi;
  final String yemekResimAdi;
  final String yemekFiyat;
  final String yemekSiparisAdet;
  final String kullaniciAdi;

  SepetYemek({
    required this.sepetYemekId,
    required this.yemekAdi,
    required this.yemekResimAdi,
    required this.yemekFiyat,
    required this.yemekSiparisAdet,
    required this.kullaniciAdi,
  });

  factory SepetYemek.fromJson(Map<String, dynamic> json) {
    return SepetYemek(
      sepetYemekId: json['sepet_yemek_id'],
      yemekAdi: json['yemek_adi'],
      yemekResimAdi: json['yemek_resim_adi'],
      yemekFiyat: json['yemek_fiyat'],
      yemekSiparisAdet: json['yemek_siparis_adet'],
      kullaniciAdi: json['kullanici_adi'],
    );
  }

  int get fiyatAsInt => int.tryParse(yemekFiyat) ?? 0;
  int get adetAsInt => int.tryParse(yemekSiparisAdet) ?? 0;

  int get toplamTutar => fiyatAsInt * adetAsInt;
}
