import 'dart:async' show Completer, Future, StreamSubscription;

import 'package:audio_waveforms/audio_waveforms.dart'
    show FinishMode, PlayerController, PlayerState, PlayerStateExtension;
import 'package:flutter/foundation.dart' show ValueNotifier, visibleForTesting;
import 'package:magic_record/_features.dart';

typedef AudioPlayerNotifier = ValueNotifier<AudioPlayerState>;

/// An abstract class which has the following methods:
/// - [AudioPlayerLogicInterface.playerController]
/// - [AudioPlayerLogicInterface.stateNotifier]
/// - [AudioPlayerLogicInterface.play]
/// - [AudioPlayerLogicInterface.pause]
/// - [AudioPlayerLogicInterface.onDispose]
abstract class AudioPlayerLogicInterface {
  PlayerController get playerController;
  AudioPlayerNotifier get stateNotifier;
  Future<void> play();
  Future<void> pause();
  Future<void> onDispose();
}

class AudioPlayerLogic implements AudioPlayerLogicInterface {
  AudioPlayerLogic({
    required String audioPath,
    PlayerController? playerController,
  }) : _playerController = playerController ?? PlayerController() {
    _setupAsync(audioPath: audioPath);
  }

  final Completer<void> _completer = Completer<void>();
  @visibleForTesting
  Completer<void> get completer => _completer;
  final PlayerController _playerController;
  final _stateNotifier = AudioPlayerNotifier(const AudioPlayerState.pause());
  StreamSubscription<PlayerState>? _playerStateStream;

  Future<void> _setupAsync({required String audioPath}) async {
    _playerStateStream = _playerController.onPlayerStateChanged.listen((state) {
      _notify = _isPlayingState
          ? const AudioPlayerState.play()
          : const AudioPlayerState.pause();
    });
    await _playerController.preparePlayer(
      path: audioPath,
      shouldExtractWaveform: true,
      volume: 1.0,
    );
    _completer.complete();
  }

  Future<void> _waitSetup() async {
    if (!_completer.isCompleted) await _completer.future;
  }

  bool get _isPlayingState => _playerController.playerState.isPlaying;

  set _notify(AudioPlayerState state) => _stateNotifier.value = state;

  @override
  PlayerController get playerController => _playerController;

  @override
  AudioPlayerNotifier get stateNotifier => _stateNotifier;

  @override
  Future<void> play() async {
    await _waitSetup();
    await _playerController.startPlayer(finishMode: FinishMode.pause);
  }

  @override
  Future<void> pause() async {
    await _waitSetup();
    await _playerController.pausePlayer();
  }

  @override
  Future<void> onDispose() async {
    _playerStateStream?.cancel();
    _playerController.dispose();
  }
}
