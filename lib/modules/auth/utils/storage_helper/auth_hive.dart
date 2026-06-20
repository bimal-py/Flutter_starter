import 'package:flutter_starter/modules/auth/utils/storage_helper/auth_storage_keys.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Dedicated auth box so logout can wipe just auth state. Tokens live in secure storage, not here.
extension HiveAuthBoxExtension on HiveInterface {
  Future<Box<dynamic>> openAuthBox() =>
      Hive.openBox<dynamic>(AuthStorageKeys.boxName);

  Box<dynamic> get authBox => Hive.box<dynamic>(AuthStorageKeys.boxName);

  Future<int> clearAuthBox() => authBox.clear();
}
