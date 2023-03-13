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
              permissionRepository:
                  context.read<PermissionRepositoryInterface>(),
            ),
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
          children: <Widget>[
            const _AudioRecords(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  _AudioRecorderButton(),
                  _AudioPlayerButton(),
                ],
              ),
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

class _AudioRecorderButton extends StatelessWidget {
  const _AudioRecorderButton();

  Future<void> _start(BuildContext context) async {
    final audioRecordLogic = context.read<AudioRecorderLogicBase>();
    await audioRecordLogic.start();
  }

  Future<void> _stop(BuildContext context) async {
    final audioRecordLogic = context.read<AudioRecorderLogicBase>();
    final myAudioRecordsLogic = context.read<MyAudioRecordsLogicBase>();

    final audioPath = await audioRecordLogic.stop();
    if (audioPath != null) await myAudioRecordsLogic.add(audioPath);
  }

  @override
  Widget build(BuildContext context) {
    final audioRecorderState = context.watch<AudioRecorderLogicBase>().value;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(8.0),
        shape: const CircleBorder(),
      ),
      onPressed: () async {
        try {
          await audioRecorderState.when<Future<void>>(
            on: () => _stop(context),
            off: () => _start(context),
          );
        } catch (e) {
          final message = e.toString();
          context.notify = message;
        }
      },
      child: Icon(
        audioRecorderState.when<IconData>(
          on: () => Icons.stop,
          off: () => Icons.mic,
        ),
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
