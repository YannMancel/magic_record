import 'dart:async' show Completer, Future;

import 'package:flutter/foundation.dart' show ValueNotifier;
import 'package:magic_record/_features.dart';

/// The logic is a [ValueNotifier] of [AudioRecord]s.
///
/// In addition, it has the following method:
/// - [MyAudioRecordsLogicBase.add]
abstract class MyAudioRecordsLogicBase
    extends ValueNotifier<List<AudioRecord>> {
  MyAudioRecordsLogicBase(super.value);

  Future<void> add(AudioRecord audioRecord);
}

class MyAudioRecordsLogic extends MyAudioRecordsLogicBase {
  MyAudioRecordsLogic({required this.storageRepository})
      : super(List<AudioRecord>.empty()) {
    _setup();
  }

  final StorageRepositoryInterface storageRepository;
  final Completer<void> _completer = Completer<void>();

  static const _kStorageKey = 'records';
  static const _kFormattedDateKey = 'formatted_date';
  static const _kAudioPathKey = 'audio_path';

  set _notify(List<AudioRecord> values) => value = values;

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

  Future<void> _setup() async {
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
  Future<void> add(AudioRecord audioRecord) async {
    await _waitSetup();
    final updatedAudioRecords = <AudioRecord>[...value, audioRecord];
    await storageRepository.put(
      key: _kStorageKey,
      value: updatedAudioRecords.map(_toJson).toList(),
    );
    _notify = updatedAudioRecords;
  }
}
