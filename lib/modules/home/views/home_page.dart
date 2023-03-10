import 'package:flutter/material.dart';
import 'package:magic_record/_features.dart';
import 'package:provider/provider.dart'
    show ChangeNotifierProvider, ReadContext, WatchContext;

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ChangeNotifierProvider<VoiceRecordLogicBase>(
        lazy: false,
        create: (context) => VoiceRecordLogic(
          permissionLogic: context.read<PermissionLogicInterface>(),
        ),
        child: const Center(
          child: _MicButton(),
        ),
      ),
    );
  }
}

class _MicButton extends StatelessWidget {
  const _MicButton();

  @override
  Widget build(BuildContext context) {
    final isRecording = context.watch<VoiceRecordLogicBase>().value;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(8.0),
        shape: const CircleBorder(),
      ),
      onPressed: () async {
        try {
          final logic = context.read<VoiceRecordLogicBase>();
          isRecording
              ? await logic.stop()
              : await logic.start(path: 'test_magic_record');
        } catch (e) {
          final message = e.toString();
          context.notify = message;
        }
      },
      child: Icon(
        isRecording ? Icons.stop : Icons.mic,
        size: 60.0,
      ),
    );
  }
}
