import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/sepet_yemek.dart';
import '../models/sepet_yemek_cevap.dart';

class SepetRepository {
  List<SepetYemek> parseSepetYemek(String cevap) {
    return SepetCevap.fromJson(json.decode(cevap)).sepetYemekler;
  }

  Future<List<SepetYemek>> sepettekiYemekleriGetir(String kullaniciAdi) async {
    try {
      var url = "http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php";
      var veri = {"kullanici_adi": kullaniciAdi};
      var cevap = await Dio().post(url, data: FormData.fromMap(veri));
      return parseSepetYemek(cevap.data.toString());
    } catch (e) {
      print("Sepetteki yemekleri getirme hatası: $e");
      return [];
    }
  }

  Future<void> sepeteYemekEkle({
    required String yemekAdi,
    required String yemekResimAdi,
    required int yemekFiyat,
    required int yemekSiparisAdet,
    required String kullaniciAdi,
  }) async {
    try {
      var url = "http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php";
      var veri = {
        "yemek_adi": yemekAdi,
        "yemek_resim_adi": yemekResimAdi,
        "yemek_fiyat": yemekFiyat.toString(),
        "yemek_siparis_adet": yemekSiparisAdet.toString(),
        "kullanici_adi": kullaniciAdi
      };
      var cevap = await Dio().post(url, data: FormData.fromMap(veri));
      print("Sepete Ekle: ${cevap.data.toString()}");
    } catch (e) {
      print("Sepete ekleme hatası: $e");
    }
  }

  Future<void> sepettenYemekSil({
    required String sepetYemekId,
    required String kullaniciAdi,
  }) async {
    try {
      var url = "http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php";
      var veri = {
        "sepet_yemek_id": sepetYemekId,
        "kullanici_adi": kullaniciAdi
      };
      var cevap = await Dio().post(url, data: FormData.fromMap(veri));
      print("Sepetten Sil: ${cevap.data.toString()}");
    } catch (e) {
      print("Sepetten silme hatası: $e");
    }
  }
}

