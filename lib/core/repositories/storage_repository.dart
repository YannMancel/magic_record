import 'dart:async' show Completer, Future;

import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

abstract class StorageRepositoryInterface {
  Future<List<String>?> getStringList({required String key});
  Future<bool> setStringList({
    required String key,
    required List<String> values,
  });
  Future<bool> removeAllData({required String key});
}

class StorageRepository implements StorageRepositoryInterface {
  StorageRepository() {
    _setupAsync();
  }

  late SharedPreferences _sharedPreferences;
  final Completer<void> _completer = Completer<void>();

  Future<void> _setupAsync() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _completer.complete();
  }

  Future<void> _waitInitialisation() async {
    if (!_completer.isCompleted) await _completer.future;
  }

  @override
  Future<List<String>?> getStringList({required String key}) async {
    await _waitInitialisation();
    return _sharedPreferences.getStringList(key);
  }

  @override
  Future<bool> setStringList({
    required String key,
    required List<String> values,
  }) async {
    await _waitInitialisation();
    return _sharedPreferences.setStringList(key, values);
  }

  @override
  Future<bool> removeAllData({required String key}) async {
    await _waitInitialisation();
    return _sharedPreferences.remove(key);
  }
}
