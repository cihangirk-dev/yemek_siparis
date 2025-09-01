import 'package:sqflite/sqflite.dart';
import 'db_provider.dart';

class KullaniciDB {
  static Future<int> girisYap(String kullaniciAdi) async {
    final db = await DBProvider.getDatabase();

    final existing = await db.query(
      'kullanici',
      where: 'kullanici_adi = ?',
      whereArgs: [kullaniciAdi],
      limit: 1,
    );
    int id;
    if (existing.isNotEmpty) {
      id = existing.first['id'] is int
          ? existing.first['id'] as int
          : int.tryParse(existing.first['id'].toString()) ?? 0;

      if (id == 0) {
        id = await db.insert(
          'kullanici',
          {'kullanici_adi': kullaniciAdi, 'aktif': 0},
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    } else {
      id = await db.insert(
        'kullanici',
        {'kullanici_adi': kullaniciAdi, 'aktif': 0},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await db.update('kullanici', {'aktif': 0});

    await db.update(
      'kullanici',
      {'aktif': 1},
      where: 'id = ?',
      whereArgs: [id],
    );

    return id;
  }

  static Future<Map<String, dynamic>?> aktifKullaniciGetir() async {
    final db = await DBProvider.getDatabase();
    final result = await db.query(
      'kullanici',
      where: 'aktif = ?',
      whereArgs: [1],
      limit: 1,
    );
    if (result.isNotEmpty) return result.first;
    return null;
  }

  static Future<void> cikisYap() async {
    final db = await DBProvider.getDatabase();
    await db.update('kullanici', {'aktif': 0});
  }
}

