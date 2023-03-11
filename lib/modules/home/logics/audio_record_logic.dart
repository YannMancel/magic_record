import 'package:flutter/foundation.dart';
import 'package:magic_record/_features.dart';
import 'package:record/record.dart';

/// The voice record logic is a [ValueNotifier] which notifies the recording
/// state.
///
/// In addition, it has the following methods:
/// - [AudioRecordLogicBase.start]
/// - [AudioRecordLogicBase.stop]
abstract class AudioRecordLogicBase extends ValueNotifier<bool> {
  AudioRecordLogicBase(super.value);

  Future<void> start({String? path});
  Future<void> stop();
}

class AudioRecordLogic extends AudioRecordLogicBase {
  AudioRecordLogic({required this.permissionLogic}) : super(false);

  final PermissionLogicInterface permissionLogic;

  final _recorder = Record();

  /// Starts the voice recording. [path] is a path to the file being recorded
  /// or the name of a temporary file (without slash '/').
  /// Throws an [Exception] when the record permission is not granted.
  @override
  Future<void> start({String? path}) async {
    if (!await permissionLogic.hasRecordPermission) {
      throw Exception('No permission');
    }

    _recorder.start(path: path);

    // NotifyListeners
    value = await _recorder.isRecording();
  }

  /// Stops the voice recording.
  @override
  Future<void> stop() async {
    final recordedSoundUrl = await _recorder.stop();
    if (kDebugMode) print('URL: $recordedSoundUrl');

    // NotifyListeners
    value = await _recorder.isRecording();
  }

  @override
  void dispose() {
    _recorder.dispose();
    super.dispose();
  }
}
