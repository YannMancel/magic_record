import 'package:flutter/foundation.dart' show optionalTypeArgs;
import 'package:freezed_annotation/freezed_annotation.dart' show freezed;

part 'audio_recorder_state.freezed.dart';

@freezed
class AudioRecorderState with _$AudioRecorderState {
  const factory AudioRecorderState.on() = _On;
  const factory AudioRecorderState.off() = _Off;
}
