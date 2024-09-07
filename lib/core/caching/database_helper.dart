import 'dart:convert';

import 'package:chat/core/utils/shared_methods.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/adapters.dart';

import 'database_keys.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  static void _printClassLog(Object? object) {
    printLog(object, runtimeType: _instance.runtimeType);
  }

  static late HiveAesCipher _key;

  static Future<void> init() async {
    late List<int> cipherKey;
    await Hive.initFlutter();
    String? storedKey = await secureStorage.read(key: 'encryptionKey');
    if (storedKey != null) {
      cipherKey = base64Decode(storedKey);
    } else {
      cipherKey = Hive.generateSecureKey();
      await secureStorage.write(
          key: 'encryptionKey', value: base64UrlEncode(cipherKey));
    }
    _key = HiveAesCipher(cipherKey);
    await openBox(DatabaseBox.appBox);
    _printClassLog("Hive Init Successfully");
  }

  static Future<void> openBox(String boxName) async {
    try {
      if (Hive.isBoxOpen(boxName)) return;
    } finally {}
    await Hive.openBox(boxName, encryptionCipher: _key);
    _printClassLog("$boxName Box Opened Successfully");
  }

  static Future<void> deleteBox({required String boxName}) async {
    await Hive.deleteBoxFromDisk(boxName);
    _printClassLog("Box Deleted Successfully");
  }

  static Future<void> clearBox({required String boxName}) async {
    await Hive.box(boxName).clear();
    _printClassLog("Box Cleared Successfully");
  }

  static Future<void> clearDatabase() async {
    await Hive.box(DatabaseBox.appBox).clear();
    _printClassLog("Database Cleared Successfully");
  }

  static Future<void> putItem(
      {required String boxName,
      required String key,
      required dynamic item}) async {
    await openBox(boxName);
    await Hive.box(boxName).put(key, item);
    _printClassLog("Item Added Successfully to($boxName [$key])");
  }

  /// convert List of object to String so it can be saved without requiring a hive adapter for the object
  static Future<void> putObjectAsString<T>(
      {required String boxName,
      required String key,
      required T object,
      required Object? Function(T) toJson}) async {
    late String convertedItem;
    try {
      convertedItem = jsonEncode(toJson(object));
    } catch (e) {
      convertedItem = object.toString();
    }
    _printClassLog('putting object: $key');
    await putItem(boxName: boxName, key: key, item: convertedItem);
  }

  static Future<void> deleteItem(
      {required String boxName, required int key}) async {
    await Hive.box(boxName).delete(key);
    _printClassLog("Item Deleted Successfully");
  }

  /// Retrieve a single item from the database by using its key
  ///
  /// ```boxName```: should be from [DatabaseBox] class.
  /// ```key```: should be from [DatabaseKey] class.
  static dynamic getItem({required String boxName, required String key}) {
    final item = Hive.box(boxName).get(key);
    _printClassLog("Item Returned Successfully: $item");
    return item;
  }

  /// Get string from database and convert it to object of given type.
  static T? getItemAsObject<T>(
      {required String boxName,
      required String key,
      required T Function(dynamic json) fromJson}) {
    final item = Hive.box(boxName).get(key);
    if (item is String) {
      dynamic decoded = jsonDecode(item);
      // printDebugInfo(decoded.runtimeType);
      T? convertedObject = fromJson(decoded);
      // _printClassLog("Item [${convertedObject.runtimeType}] Returned Successfully");
      return convertedObject;
    }
    return item;
  }
}
