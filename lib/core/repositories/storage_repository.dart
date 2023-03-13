import 'dart:async' show Completer, Future;

import 'package:hive_flutter/hive_flutter.dart' show Box, Hive, HiveX;

abstract class StorageRepositoryInterface {
  Future<List<dynamic>?> get({
    required String key,
    List<dynamic>? defaultValue,
  });
  Future<void> put({
    required String key,
    required List<dynamic> value,
  });
  Future<void> delete({required String key});
  Future<void> onDispose();
}

class StorageRepository implements StorageRepositoryInterface {
  StorageRepository() {
    _setupAsync();
  }

  late Box<List<dynamic>> _box;
  final Completer<void> _completer = Completer<void>();

  Future<void> _setupAsync() async {
    await Hive.initFlutter();
    _box = await Hive.openBox<List<dynamic>>('my_audio_records');
    _completer.complete();
  }

  Future<void> _waitSetup() async {
    if (!_completer.isCompleted) await _completer.future;
  }

  @override
  Future<List<dynamic>?> get({
    required String key,
    List<dynamic>? defaultValue,
  }) async {
    await _waitSetup();
    return _box.get(key, defaultValue: defaultValue);
  }

  @override
  Future<void> put({
    required String key,
    required List<dynamic> value,
  }) async {
    await _waitSetup();
    await _box.put(key, value);
  }

  @override
  Future<void> delete({required String key}) async {
    await _waitSetup();
    await _box.delete(key);
  }

  @override
  Future<void> onDispose() async {
    await _box.close();
    await Hive.close();
  }
}
