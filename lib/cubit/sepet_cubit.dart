import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/sepet_repository.dart';
import '../models/sepet_yemek.dart';

class SepetCubit extends Cubit<List<SepetYemek>> {
  final SepetRepository sepetRepo;

  SepetCubit(this.sepetRepo) : super([]);

  Future<void> sepettekiYemekleriGetir(String kullaniciAdi) async {
    try {
      var sepetListesi = await sepetRepo.sepettekiYemekleriGetir(kullaniciAdi);
      emit(sepetListesi);
    } catch (e) {
      print("Sepet Yüklenemedi: $e");
    }
  }

  double toplamTutar() {
    double toplam = 0;
    for (var yemek in state) {
      toplam += yemek.toplamTutar;
    }
    return toplam;
  }

  Future<void> sepettenYemekSil({
    required int sepetYemekId,
    required String kullaniciAdi,
  }) async {
    try {
      await sepetRepo.sepettenYemekSil(
          sepetYemekId: sepetYemekId.toString(), kullaniciAdi: kullaniciAdi);
      await sepettekiYemekleriGetir(kullaniciAdi);
    } catch (e) {
      print("Yemek silinirken hata oluştu: $e");
    }
  }

  Future<void> sepetiTemizle({required String kullaniciAdi}) async {
    try {
      List<Future> futures = [];
      for (var yemek in state) {
        futures.add(sepetRepo.sepettenYemekSil(
            sepetYemekId: yemek.sepetYemekId.toString(), kullaniciAdi: kullaniciAdi));
      }
      await Future.wait(futures);
      emit([]);
    } catch (e) {
      print("Sepet temizleme hatası: $e");
    }
  }
  Future<void> adetGuncelle({
    required SepetYemek yemek,
    required int yeniAdet,
    required String kullaniciAdi,
  }) async {
    try {
      await SepetRepository().sepettenYemekSil(
        sepetYemekId: yemek.sepetYemekId,
        kullaniciAdi: kullaniciAdi,
      );

      await SepetRepository().sepeteYemekEkle(
        yemekAdi: yemek.yemekAdi,
        yemekResimAdi: yemek.yemekResimAdi,
        yemekFiyat: int.parse(yemek.yemekFiyat),
        yemekSiparisAdet: yeniAdet,
        kullaniciAdi: kullaniciAdi,
      );

      sepettekiYemekleriGetir(kullaniciAdi);
    } catch (e) {
      print("Adet güncelleme hatası: $e");
    }
  }
}
