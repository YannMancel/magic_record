import 'package:flutter/material.dart';
import 'package:magic_record/_features.dart';
import 'package:provider/provider.dart'
    show ChangeNotifierProvider, Consumer, WatchContext;

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
            itemBuilder: (_, index) {
              final audioRecord = myAudioRecords[index];
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: _AudioCard(audioRecord),
              );
            },
          );
        },
      ),
    );
  }
}

class _AudioCard extends StatelessWidget {
  const _AudioCard(this.audioRecord);

  final AudioRecord audioRecord;

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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(audioRecord.audioPath),
              Text(audioRecord.formattedDate),
            ],
          ),
        ),
      ),
    );
  }
}
