import 'package:flutter/material.dart';
import 'package:magic_record/_features.dart';
import 'package:provider/provider.dart'
    show ChangeNotifierProvider, Consumer, Provider, ReadContext, WatchContext;

/// To use this widget, we need to instance [MyAudioRecordsLogicInterface].
class MyAudioRecordsWidget extends StatelessWidget {
  const MyAudioRecordsWidget({
    super.key,
    this.padding,
  });

  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final notifier =
        context.watch<MyAudioRecordsLogicInterface>().stateNotifier;

    return ChangeNotifierProvider<AudioRecordsNotifier>.value(
      value: notifier,
      child: Consumer<AudioRecordsNotifier>(
        builder: (_, notifier, __) {
          final myAudioRecords = notifier.value;

          if (myAudioRecords.isEmpty) {
            return const Center(
              child: Text('No record'),
            );
          }

          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: padding,
            itemCount: myAudioRecords.length,
            itemBuilder: (context, index) {
              final audioRecord = myAudioRecords[index];
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Dismissible(
                  key: Key(audioRecord.toString()),
                  background: const _DismissibleBackground(),
                  onDismissed: (_) {
                    context
                        .read<MyAudioRecordsLogicInterface>()
                        .delete(audioRecord);
                    context.notify = 'Audio record dismissed';
                  },
                  child: Provider<AudioPlayerLogicInterface>(
                    create: (_) => AudioPlayerLogic(
                      audioPath: audioRecord.audioPath,
                    ),
                    dispose: (_, logic) => logic.onDispose(),
                    child: AudioPlayerCard(
                      audioRecord,
                      key: Key(audioRecord.audioPath),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _DismissibleBackground extends StatelessWidget {
  const _DismissibleBackground();

  @override
  Widget build(BuildContext context) {
    const kDeleteIcon = Icon(Icons.delete, color: Colors.white);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        color: Colors.red,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const <Widget>[
            kDeleteIcon,
            kDeleteIcon,
          ],
        ),
      ),
    );
  }
}
