import 'package:flutter/foundation.dart' show optionalTypeArgs;
import 'package:freezed_annotation/freezed_annotation.dart'
    show JsonKey, freezed, useResult;

part 'audio_recorder_state.freezed.dart';

@freezed
class AudioRecorderState with _$AudioRecorderState {
  const factory AudioRecorderState.idle() = _Idle;
  const factory AudioRecorderState.start() = _Start;
  const factory AudioRecorderState.stop({String? audioPath}) = _Stop;
}
