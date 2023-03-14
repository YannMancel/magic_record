import 'package:flutter/foundation.dart' show ValueNotifier, kDebugMode;
import 'package:magic_record/_features.dart';
import 'package:record/record.dart' show Record;

typedef AudioRecorderStateNotifier = ValueNotifier<AudioRecorderState>;

/// An abstract class which has the following methods:
/// - [AudioRecorderLogicInterface.stateNotifier]
/// - [AudioRecorderLogicInterface.start]
/// - [AudioRecorderLogicInterface.stop]
/// - [AudioRecorderLogicInterface.onDispose]
abstract class AudioRecorderLogicInterface {
  AudioRecorderStateNotifier get stateNotifier;
  Future<void> start({String? path});
  Future<String?> stop();
  Future<void> onDispose();
}

class AudioRecorderLogic implements AudioRecorderLogicInterface {
  AudioRecorderLogic({required this.permissionRepository});

  final PermissionRepositoryInterface permissionRepository;
  final _recorder = Record();
  final _stateNotifier =
      AudioRecorderStateNotifier(const AudioRecorderState.idle());

  set _notify(AudioRecorderState state) => _stateNotifier.value = state;

  @override
  AudioRecorderStateNotifier get stateNotifier => _stateNotifier;

  /// Starts the voice recording. [path] is a path to the file being recorded
  /// or the name of a temporary file (without slash '/').
  /// Throws an [Exception] when the record permission is not granted.
  @override
  Future<void> start({String? path}) async {
    if (!await permissionRepository.hasRecordPermission) {
      throw Exception('No permission to record audio.');
    }

    _recorder.start(path: path);
    _notify = const AudioRecorderState.start();
  }

  /// Stops the voice recording and returns the audio path.
  @override
  Future<String?> stop() async {
    final audioPath = await _recorder.stop();
    if (kDebugMode) print('Audio Path: $audioPath');
    _notify = AudioRecorderState.stop(audioPath: audioPath);
    return audioPath;
  }

  @override
  Future<void> onDispose() => _recorder.dispose();
}
