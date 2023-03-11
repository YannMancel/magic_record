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
      body: ChangeNotifierProvider<AudioRecordLogicBase>(
        lazy: false,
        create: (context) => AudioRecordLogic(
          permissionLogic: context.read<PermissionLogicInterface>(),
        ),
        child: const Center(
          child: _RecordButton(),
        ),
      ),
    );
  }
}

class _RecordButton extends StatelessWidget {
  const _RecordButton();

  @override
  Widget build(BuildContext context) {
    final isRecording = context.watch<AudioRecordLogicBase>().value;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(8.0),
        shape: const CircleBorder(),
      ),
      onPressed: () async {
        try {
          final logic = context.read<AudioRecordLogicBase>();
          isRecording ? await logic.stop() : await logic.start();
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
