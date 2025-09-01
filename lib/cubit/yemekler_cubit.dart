import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/yemekler_repository.dart';
import '../models/yemek.dart';

class YemeklerCubit extends Cubit<List<Yemek>> {
  YemeklerCubit() : super([]);

  final YemeklerRepository yrepo = YemeklerRepository();

  List<Yemek> _tumYemekler = [];

  bool isLoading = false;

  Future<void> yemekleriGetir() async {
    try {
      isLoading = true;
      emit([]);
      _tumYemekler = await yrepo.yemekleriGetir();
      isLoading = false;
      emit(_tumYemekler);
    } catch (e) {
      print("Cubit yemek getirme hatası: $e");
      isLoading = false;
      emit([]);
    }
  }

  void yemekAra(String query) {
    if (_tumYemekler.isEmpty) return;

    if (query.isEmpty) {
      emit(_tumYemekler);
    } else {
      final filtreli = _tumYemekler
          .where((yemek) =>
          yemek.yemekAdi.toLowerCase().contains(query.toLowerCase()))
          .toList();
      emit(filtreli);
    }
  }
}
