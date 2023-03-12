import 'dart:async' show Future, unawaited;

import 'package:flutter/foundation.dart' show ValueNotifier;
import 'package:just_audio/just_audio.dart' show AudioPlayer;
import 'package:magic_record/_features.dart';

/// The audio player logic is a [ValueNotifier] which notifies the audio state.
///
/// In addition, it has the following methods:
/// - [AudioPlayerLogicBase.play]
/// - [AudioPlayerLogicBase.pause]
abstract class AudioPlayerLogicBase extends ValueNotifier<bool> {
  AudioPlayerLogicBase(super.value);

  Future<void> play({required String path});
  Future<void> pause();
}

class AudioPlayerLogic extends AudioPlayerLogicBase {
  AudioPlayerLogic({required this.permissionLogic}) : super(false);

  final PermissionLogicInterface permissionLogic;

  final _player = AudioPlayer();

  set _notify(bool state) => value = state;

  /// Starts the audio. [path] is a path to the audio file.
  /// Throws an [Exception] when the storage permission is not granted.
  @override
  Future<void> play({required String path}) async {
    // TODO: ask permission to access storage
    //if (!await permissionLogic.hasRecordPermission) {
    //  throw Exception('No permission to access storage.');
    //}
    await _player.setUrl(path);
    unawaited(_player.play().then((_) => _notify = false));
    _notify = true;
  }

  /// Make pause the audio.
  @override
  Future<void> pause() async {
    await _player.pause();
    _notify = false;
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
