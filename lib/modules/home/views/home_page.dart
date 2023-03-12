import 'package:flutter/material.dart';
import 'package:magic_record/_features.dart';
import 'package:provider/provider.dart'
    show
        ChangeNotifierProvider,
        MultiProvider,
        ReadContext,
        SelectContext,
        WatchContext;
import 'package:provider/single_child_widget.dart' show SingleChildWidget;

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
      body: MultiProvider(
        providers: <SingleChildWidget>[
          ChangeNotifierProvider<AudioRecorderLogicBase>(
            lazy: false,
            create: (context) => AudioRecorderLogic(
              permissionLogic: context.read<PermissionLogicInterface>(),
            ),
          ),
          ChangeNotifierProvider<AudioPlayerLogicBase>(
            lazy: true,
            create: (context) => AudioPlayerLogic(
              permissionLogic: context.read<PermissionLogicInterface>(),
            ),
          ),
        ],
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              _AudioRecorderButton(),
              _AudioPlayerButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _AudioRecorderButton extends StatelessWidget {
  const _AudioRecorderButton();

  @override
  Widget build(BuildContext context) {
    final isRecording = context.watch<AudioRecorderLogicBase>().value;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(8.0),
        shape: const CircleBorder(),
      ),
      onPressed: () async {
        try {
          final logic = context.read<AudioRecorderLogicBase>();
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

class _AudioPlayerButton extends StatelessWidget {
  const _AudioPlayerButton();

  @override
  Widget build(BuildContext context) {
    final audioPath = context.select<AudioRecorderLogicBase, String?>(
      (logic) => logic.audioPath,
    );

    if (audioPath == null) return const SizedBox.shrink();

    final isPlaying = context.watch<AudioPlayerLogicBase>().value;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(8.0),
        shape: const CircleBorder(),
      ),
      onPressed: () async {
        try {
          final logic = context.read<AudioPlayerLogicBase>();
          isPlaying ? await logic.pause() : await logic.play(path: audioPath);
        } catch (e) {
          final message = e.toString();
          context.notify = message;
        }
      },
      child: Icon(
        isPlaying ? Icons.pause : Icons.play_arrow,
        size: 60.0,
      ),
    );
  }
}
