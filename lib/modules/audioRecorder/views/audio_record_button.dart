import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:magic_record/_features.dart';
import 'package:provider/provider.dart'
    show ChangeNotifierProvider, Consumer, ReadContext, WatchContext;

/// To use this widget, we need to instance [AudioRecorderLogicInterface] and
/// [MyAudioRecordsLogicInterface].
class AudioRecorderButton extends StatelessWidget {
  const AudioRecorderButton({super.key});

  Future<void> _start(BuildContext context) async {
    final audioRecordLogic = context.read<AudioRecorderLogicInterface>();
    await audioRecordLogic.start();
  }

  Future<void> _stop(BuildContext context) async {
    final audioRecordLogic = context.read<AudioRecorderLogicInterface>();
    final myAudioRecordsLogic = context.read<MyAudioRecordsLogicInterface>();

    final audioPath = await audioRecordLogic.stop();
    if (audioPath != null) {
      final now = DateTime.now();
      final audioRecord = AudioRecord(
        formattedDate: DateFormat('yyyy-MM-dd – kk:mm:ss').format(now),
        audioPath: audioPath,
      );
      await myAudioRecordsLogic.add(audioRecord);
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<AudioRecorderLogicInterface>().stateNotifier;

    return ChangeNotifierProvider<AudioRecorderStateNotifier>.value(
      value: notifier,
      child: Consumer<AudioRecorderStateNotifier>(
        builder: (context, notifier, _) {
          final audioRecorderState = notifier.value;

          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(8.0),
              shape: const CircleBorder(),
            ),
            onPressed: () async {
              try {
                await audioRecorderState.maybeWhen<Future<void>>(
                  start: () => _stop(context),
                  orElse: () => _start(context),
                );
              } catch (e) {
                final message = e.toString();
                context.notify = message;
              }
            },
            child: Icon(
              audioRecorderState.maybeWhen<IconData>(
                start: () => Icons.stop,
                orElse: () => Icons.mic,
              ),
              size: 60.0,
            ),
          );
        },
      ),
    );
  }
}
