import 'package:flutter/material.dart';
import 'package:magic_record/_features.dart';
import 'package:provider/provider.dart'
    show
        ChangeNotifierProvider,
        MultiProvider,
        Provider,
        ReadContext,
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
          Provider<AudioRecorderLogicInterface>(
            lazy: false,
            create: (context) => AudioRecorderLogic(
              permissionRepository:
                  context.read<PermissionRepositoryInterface>(),
            ),
            dispose: (_, logic) => logic.onDispose(),
          ),
          ChangeNotifierProvider<AudioPlayerLogicBase>(
            lazy: true,
            create: (_) => AudioPlayerLogic(),
          ),
          ChangeNotifierProvider<MyAudioRecordsLogicBase>(
            lazy: false,
            create: (context) => MyAudioRecordsLogic(
              storageRepository: context.read<StorageRepositoryInterface>(),
            ),
          ),
        ],
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: const <Widget>[
            _AudioRecords(),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: AudioRecorderButton(),
            ),
          ],
        ),
      ),
    );
  }
}

class _AudioRecords extends StatelessWidget {
  const _AudioRecords();

  @override
  Widget build(BuildContext context) {
    final myAudioRecords = context.watch<MyAudioRecordsLogicBase>().value;

    if (myAudioRecords.isEmpty) {
      return const Center(
        child: Text('No record'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 30.0),
      itemCount: myAudioRecords.length,
      itemBuilder: (_, index) {
        final audioRecord = myAudioRecords[index];
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: _AudioCard(audioRecord),
        );
      },
    );
  }
}

class _AudioCard extends StatelessWidget {
  const _AudioCard(this.audioPath);

  final String audioPath;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(4.0),
        onTap: () {
          //TODO: add event
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(audioPath),
          ),
        ),
      ),
    );
  }
}

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
