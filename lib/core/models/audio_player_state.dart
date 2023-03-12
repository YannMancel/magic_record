import 'package:freezed_annotation/freezed_annotation.dart'
    show freezed, optionalTypeArgs;

part 'audio_player_state.freezed.dart';

@freezed
class AudioPlayerState with _$AudioPlayerState {
  const factory AudioPlayerState.play() = _Play;
  const factory AudioPlayerState.pause() = _Pause;
}
