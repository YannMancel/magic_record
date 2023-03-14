import 'dart:async' show Completer, Future;

import 'package:flutter/foundation.dart' show ValueNotifier;
import 'package:magic_record/_features.dart';

typedef AudioRecordsNotifier = ValueNotifier<List<AudioRecord>>;

/// An abstract class which has the following methods:
/// - [MyAudioRecordsLogicInterface.stateNotifier]
/// - [MyAudioRecordsLogicInterface.add]
abstract class MyAudioRecordsLogicInterface {
  AudioRecordsNotifier get stateNotifier;
  Future<void> add(AudioRecord audioRecord);
}

class MyAudioRecordsLogic implements MyAudioRecordsLogicInterface {
  MyAudioRecordsLogic({required this.storageRepository}) {
    _setupAsync();
  }

  final StorageRepositoryInterface storageRepository;
  final Completer<void> _completer = Completer<void>();
  final _stateNotifier = AudioRecordsNotifier(List<AudioRecord>.empty());

  static const _kStorageKey = 'records';
  static const _kFormattedDateKey = 'formatted_date';
  static const _kAudioPathKey = 'audio_path';

  set _notify(List<AudioRecord> values) => _stateNotifier.value = values;

  Map<String, String> _toJson(AudioRecord value) {
    return <String, String>{
      _kFormattedDateKey: value.formattedDate,
      _kAudioPathKey: value.audioPath,
    };
  }

  AudioRecord _fromJson(dynamic value) {
    final json = (value as Map<dynamic, dynamic>).cast<String, String>();

    return AudioRecord(
      formattedDate: json[_kFormattedDateKey] ?? '',
      audioPath: json[_kAudioPathKey] ?? '',
    );
  }

  Future<void> _setupAsync() async {
    final values = await storageRepository.get(
      key: _kStorageKey,
      defaultValue: List<dynamic>.empty(),
    );
    _notify = values?.map(_fromJson).toList() ?? List<AudioRecord>.empty();
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
      value: updatedAudioRecords.map(_toJson).toList(),
    );
    _notify = updatedAudioRecords;
  }
}
