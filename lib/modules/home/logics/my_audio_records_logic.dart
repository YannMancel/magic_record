import 'dart:async' show Completer, Future;

import 'package:flutter/foundation.dart' show ValueNotifier;
import 'package:magic_record/_features.dart';

/// The logic is a [ValueNotifier] of [List] of [String] which notifies the
/// audio list.
///
/// In addition, it has the following method:
/// - [MyAudioRecordsLogicBase.add]
abstract class MyAudioRecordsLogicBase extends ValueNotifier<List<String>> {
  MyAudioRecordsLogicBase(super.value);

  Future<void> add(String audioPath);
}

class MyAudioRecordsLogic extends MyAudioRecordsLogicBase {
  MyAudioRecordsLogic({required this.storageRepository})
      : super(List<String>.empty()) {
    _setup();
  }

  final StorageRepositoryInterface storageRepository;
  final Completer<void> _completer = Completer<void>();

  static const _kStorageKey = 'records';
  static const _kAudioPathKey = 'audio_path';

  set _notify(List<String> values) => value = values;

  Map<String, String> _toJson(String value) {
    return <String, String>{
      _kAudioPathKey: value,
    };
  }

  String _fromJson(dynamic value) {
    final json = (value as Map<dynamic, dynamic>).cast<String, String>();
    return json[_kAudioPathKey] ?? '';
  }

  Future<void> _setup() async {
    final values = await storageRepository.get(
      key: _kStorageKey,
      defaultValue: List<dynamic>.empty(),
    );
    _notify = values?.map(_fromJson).toList() ?? List<String>.empty();
    _completer.complete();
  }

  Future<void> _waitSetup() async {
    if (!_completer.isCompleted) await _completer.future;
  }

  @override
  Future<void> add(String audioPath) async {
    await _waitSetup();
    final updatedAudioRecords = <String>[audioPath, ...value];
    await storageRepository.put(
      key: _kStorageKey,
      value: updatedAudioRecords.map(_toJson).toList(),
    );
    _notify = updatedAudioRecords;
  }
}
