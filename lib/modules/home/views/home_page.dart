import 'package:flutter/material.dart';
import 'package:magic_record/_features.dart';
import 'package:provider/provider.dart'
    show MultiProvider, Provider, ReadContext;
import 'package:provider/single_child_widget.dart' show SingleChildWidget;

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildWidget>[
        Provider<AudioRecorderLogicInterface>(
          lazy: false,
          create: (context) => AudioRecorderLogic(
            permissionRepository: context.read<PermissionRepositoryInterface>(),
          ),
          dispose: (_, logic) => logic.onDispose(),
        ),
        //ChangeNotifierProvider<AudioPlayerLogicBase>(
        //  lazy: true,
        //  create: (_) => AudioPlayerLogic(),
        //),
        Provider<MyAudioRecordsLogicInterface>(
          lazy: false,
          create: (context) => MyAudioRecordsLogic(
            storageRepository: context.read<StorageRepositoryInterface>(),
          ),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: const SafeArea(
          child: MyAudioRecordsWidget(
            padding: EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              bottom: 108.0,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: const AudioRecorderButton(),
      ),
    );
  }
}

/*
class _AudioPlayerButton extends StatelessWidget {
  const _AudioPlayerButton();

  @override
  Widget build(BuildContext context) {
    final audioRecorderState =
        context.watch<AudioRecorderStateNotifier>().value;

    final audioPath = audioRecorderState.whenOrNull<String>(
      stop: (audioPath) => audioPath,
    );

    if (audioPath == null) return const SizedBox.shrink();

    final audioPlayerState = context.watch<AudioPlayerLogicBase>().value;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(8.0),
        shape: const CircleBorder(),
      ),
      onPressed: () async {
        try {
          final logic = context.read<AudioPlayerLogicBase>();
          await audioPlayerState.when<Future<void>>(
            play: logic.pause,
            pause: () => logic.play(path: audioPath),
          );
        } catch (e) {
          final message = e.toString();
          context.notify = message;
        }
      },
      child: Icon(
        audioPlayerState.when<IconData>(
          play: () => Icons.pause,
          pause: () => Icons.play_arrow,
        ),
        size: 60.0,
      ),
    );
  }
}
*/
