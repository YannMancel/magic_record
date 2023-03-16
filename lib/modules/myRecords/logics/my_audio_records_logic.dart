import 'dart:async' show Completer, Future;
import 'dart:io' show File;

import 'package:flutter/foundation.dart' show ValueNotifier, visibleForTesting;
import 'package:magic_record/_features.dart';

typedef AudioRecordsNotifier = ValueNotifier<List<AudioRecord>>;

/// An abstract class which has the following methods:
/// - [MyAudioRecordsLogicInterface.stateNotifier]
/// - [MyAudioRecordsLogicInterface.add]
/// - [MyAudioRecordsLogicInterface.delete]
abstract class MyAudioRecordsLogicInterface {
  AudioRecordsNotifier get stateNotifier;
  Future<void> add(AudioRecord audioRecord);
  Future<void> delete(AudioRecord audioRecord, {bool needToRemoveFile = true});
}

class MyAudioRecordsLogic implements MyAudioRecordsLogicInterface {
  MyAudioRecordsLogic({required this.storageRepository}) {
    _setupAsync();
  }

  final StorageRepositoryInterface storageRepository;
  final Completer<void> _completer = Completer<void>();
  @visibleForTesting
  Completer<void> get completer => _completer;
  final _stateNotifier = AudioRecordsNotifier(List<AudioRecord>.empty());

  static const _kStorageKey = 'records';
  @visibleForTesting
  static const kFormattedDateKey = 'formatted_date';
  @visibleForTesting
  static const kAudioPathKey = 'audio_path';

  set _notify(List<AudioRecord> values) => _stateNotifier.value = values;

  @visibleForTesting
  static Map<String, String> toJson(AudioRecord value) {
    return <String, String>{
      kFormattedDateKey: value.formattedDate,
      kAudioPathKey: value.audioPath,
    };
  }

  @visibleForTesting
  static AudioRecord fromJson(dynamic value) {
    final json = (value as Map<dynamic, dynamic>).cast<String, String>();

    return AudioRecord(
      formattedDate: json[kFormattedDateKey] ?? '',
      audioPath: json[kAudioPathKey] ?? '',
    );
  }

  Future<void> _setupAsync() async {
    final values = await storageRepository.get(
      key: _kStorageKey,
      defaultValue: List<dynamic>.empty(),
    );
    _notify = values?.map(fromJson).toList() ?? List<AudioRecord>.empty();
    _completer.complete();
  }

  Future<void> _waitSetup() async {
    if (!_completer.isCompleted) await _completer.future;
  }

  @override
  AudioRecordsNotifier get stateNotifier => _stateNotifier;

  @override
  Future<void> add(AudioRecord audioRecord) async {
    await _waitSetup();
    final updatedAudioRecords = <AudioRecord>[
      ..._stateNotifier.value,
      audioRecord,
    ];
    await storageRepository.put(
      key: _kStorageKey,
      value: updatedAudioRecords.map(toJson).toList(),
    );
    _notify = updatedAudioRecords;
  }

  @override
  Future<void> delete(
    AudioRecord audioRecord, {
    bool needToRemoveFile = true,
  }) async {
    await _waitSetup();
    if (needToRemoveFile) {
      final file = File(audioRecord.audioPath);
      await file.delete();
    }
    final updatedAudioRecords =
        _stateNotifier.value.where((e) => e != audioRecord).toList();
    await storageRepository.put(
      key: _kStorageKey,
      value: updatedAudioRecords.map(toJson).toList(),
    );
    _notify = updatedAudioRecords;
  }
}
