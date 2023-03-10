import 'package:flutter/foundation.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart'
    show FlutterSoundRecorder;
import 'package:magic_record/_features.dart';

/// The voice record logic is a [ValueNotifier] which notifies the recording
/// state.
///
/// In addition, it has the following methods:
/// - [VoiceRecordLogicBase.start]
/// - [VoiceRecordLogicBase.stop]
abstract class VoiceRecordLogicBase extends ValueNotifier<bool> {
  VoiceRecordLogicBase(super.value);

  Future<void> start({required String path});
  Future<void> stop();
}

class VoiceRecordLogic extends VoiceRecordLogicBase {
  VoiceRecordLogic({required this.permissionLogic}) : super(false);

  final PermissionLogicInterface permissionLogic;

  final _recorder = FlutterSoundRecorder();

  /// Starts the voice recording. [path] is a path to the file being recorded
  /// or the name of a temporary file (without slash '/').
  /// Throws an [Exception] when the record permission is not granted.
  @override
  Future<void> start({required String path}) async {
    if (!await permissionLogic.hasRecordPermission) {
      throw Exception('No permission');
    }

    await _recorder.openRecorder();
    //await _recorder.setSubscriptionDuration(
    //  const Duration(milliseconds: 500),
    //);
    await _recorder.startRecorder(toFile: path);

    // NotifyListeners
    value = _recorder.isRecording;
  }

  /// Stops the voice recording.
  @override
  Future<void> stop() async {
    final recordedSoundUrl = await _recorder.stopRecorder();
    await _recorder.closeRecorder();
    if (kDebugMode) print('URL: $recordedSoundUrl');

    // NotifyListeners
    value = _recorder.isRecording;
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }
}
