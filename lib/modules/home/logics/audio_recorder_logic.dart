import 'package:flutter/foundation.dart' show ValueNotifier, kDebugMode;
import 'package:magic_record/_features.dart';
import 'package:record/record.dart' show Record;

/// The voice record logic is a [ValueNotifier] of [AudioRecorderState] which
/// notifies the recording state.
///
/// In addition, it has the following methods:
/// - [AudioRecorderLogicBase.audioPath]
/// - [AudioRecorderLogicBase.start]
/// - [AudioRecorderLogicBase.stop]
abstract class AudioRecorderLogicBase
    extends ValueNotifier<AudioRecorderState> {
  AudioRecorderLogicBase(super.value);

  String? get audioPath;
  Future<void> start({String? path});
  Future<void> stop();
}

class AudioRecorderLogic extends AudioRecorderLogicBase {
  AudioRecorderLogic({required this.permissionRepository})
      : super(const AudioRecorderState.off());

  final PermissionRepositoryInterface permissionRepository;

  final _recorder = Record();

  set _notify(AudioRecorderState state) => value = state;

  String? _audioPath;
  @override
  String? get audioPath => _audioPath;

  /// Starts the voice recording. [path] is a path to the file being recorded
  /// or the name of a temporary file (without slash '/').
  /// Throws an [Exception] when the record permission is not granted.
  @override
  Future<void> start({String? path}) async {
    if (!await permissionRepository.hasRecordPermission) {
      throw Exception('No permission to record audio.');
    }

    _audioPath = null;
    _recorder.start(path: path);
    _notify = const AudioRecorderState.on();
  }

  /// Stops the voice recording.
  @override
  Future<void> stop() async {
    _audioPath = await _recorder.stop();
    if (kDebugMode) print('Audio Path: $_audioPath');
    _notify = const AudioRecorderState.off();
  }

  @override
  void dispose() {
    _recorder.dispose();
    super.dispose();
  }
}
