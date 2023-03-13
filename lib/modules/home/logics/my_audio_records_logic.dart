import 'dart:async' show Completer, Future;

import 'package:flutter/foundation.dart' show ValueNotifier;
import 'package:magic_record/_features.dart';

/// The logic is a [ValueNotifier] of [List] of [String] which notifies the
/// audio list.
///
/// In addition, it has the following method:
/// - [AudioPlayerLogicBase.add]
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

  static const _kStorageKey = 'audio';

  set _notify(List<String> values) => value = values;

  Future<void> _setup() async {
    final values = await storageRepository.getStringList(key: _kStorageKey);
    _notify = values ?? List<String>.empty();
    _completer.complete();
  }

  Future<void> _waitSetup() async {
    if (!_completer.isCompleted) await _completer.future;
  }

  @override
  Future<void> add(String audioPath) async {
    await _waitSetup();
    final updatedAudioRecords = <String>[audioPath, ...value];
    final hasSaved = await storageRepository.setStringList(
      key: _kStorageKey,
      values: updatedAudioRecords,
    );
    if (hasSaved) _notify = updatedAudioRecords;
  }
}
