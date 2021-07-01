import 'package:joujou_lounge/constant/db_params.dart';
import 'package:joujou_lounge/sqlite/db_provider.dart';

class MetaRepository {
  static const String table = DBTables.META_TABLE;

  static void updateMeta(String key, String value) async {
    final db = await DBProvider.database;
    var res = await db.query(table,
        where: "${MetaTableParams.key} = ?", whereArgs: [key]);
    if (res.isEmpty) {
      await db.rawInsert(
          "INSERT Into ${table} (${MetaTableParams.key}, ${MetaTableParams.value}) "
              "VALUES (?, ?)",
          [key, value]);
    } else {
      await db.update(table, {"${MetaTableParams.value}": value},
          where: "${MetaTableParams.id} = ?",
          whereArgs: [res.first[MetaTableParams.id]]);
    }
  }

  static Future<String> getMetaValue(String key) async {
    final db = await DBProvider.database;
    var res = await db.query(table,
        where: "${MetaTableParams.key} = ?", whereArgs: [key]);
    if (res.isEmpty) return res.first[MetaTableParams.value];
    return "";
  }

  static Future<List<String>> getBackground() async {
    String backType = await getMetaValue("background_type");
    String backUrl = await getMetaValue("background_url");
    List<String> result = [];
    result.add(backType);
    result.add(backUrl);
    return result;
  }

  static void clearMeta() async {
    final db = await DBProvider.database;
    await db.delete(table);
  }
}