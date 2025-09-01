import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/yemek.dart';
import '../models/yemek_cevap.dart';

class YemeklerRepository {
  List<Yemek> parseYemek(String cevap) {
    return YemeklerCevap.fromJson(json.decode(cevap)).yemekler;
  }

  Future<List<Yemek>> yemekleriGetir() async {
    try {
      var url = "http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php";
      var cevap = await Dio().get(url);
      return parseYemek(cevap.data.toString());
    } catch (e) {
      print("Yemekler getirme hatası: $e");
      return [];
    }
  }
}

