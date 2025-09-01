import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yemek_siparis/pages/bottom_nav_wrapper.dart';
import 'data/sepet_repository.dart';
import 'db/kullanici_db.dart';
import 'pages/giris_sayfa.dart';
import 'cubit/yemekler_cubit.dart';
import 'cubit/sepet_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final kullanici = await KullaniciDB.aktifKullaniciGetir();
  final kullaniciAdi = kullanici?['kullanici_adi'];
  final kullaniciId = kullanici?['id'];

  runApp(MyApp(kullaniciAdi: kullaniciAdi, kullaniciId: kullaniciId));
}

class MyApp extends StatelessWidget {
  final String? kullaniciAdi;
  final int? kullaniciId;
  const MyApp({Key? key, this.kullaniciAdi, this.kullaniciId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => YemeklerCubit()..yemekleriGetir()),
        BlocProvider(
          create: (context) => SepetCubit(SepetRepository()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Yemek Uygulaması',
        home: kullaniciAdi == null || kullaniciId == null
            ? LoginPage()
            : BottomNavWrapper(kullaniciAdi: kullaniciAdi!, kullaniciId: kullaniciId!),
      ),
    );
  }
}


