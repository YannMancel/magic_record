import 'package:freezed_annotation/freezed_annotation.dart'
    show JsonKey, freezed, useResult;

part 'audio_record.freezed.dart';

@freezed
class AudioRecord with _$AudioRecord {
  const factory AudioRecord({
    required String formattedDate,
    required String audioPath,
  }) = _AudioRecord;
}
