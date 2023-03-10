import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:magic_record/_features.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late FlutterSoundRecorder _recorder;
  late bool _hasRecordPermission;

  Future<void> _checkPermissions() async {
    final permissionLogic = context.read<PermissionLogicInterface>();
    if (await permissionLogic.hasRecordPermission) {
      setState(() => _hasRecordPermission = true);
      await _recorder.openRecorder();
      await _recorder.setSubscriptionDuration(
        const Duration(milliseconds: 500),
      );
    }
  }

  Future<void> _startRecording() async {
    return _recorder.startRecorder(toFile: 'test_magic_record');
  }

  Future<void> _stopRecording() async {
    final recordedSoundUrl = await _recorder.stopRecorder();
    if (kDebugMode) print('URL: $recordedSoundUrl');
  }

  @override
  void initState() {
    super.initState();
    _hasRecordPermission = false;
    _recorder = FlutterSoundRecorder();
    _checkPermissions();
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(8.0),
            shape: const CircleBorder(),
          ),
          onPressed: _hasRecordPermission
              ? () async {
                  _recorder.isRecording
                      ? await _stopRecording()
                      : await _startRecording();

                  setState(() {});
                }
              : null,
          child: Icon(
            _recorder.isRecording ? Icons.stop : Icons.mic,
            size: 60.0,
          ),
        ),
      ),
    );
  }
}
