import 'package:audio_waveforms/audio_waveforms.dart'
    show AudioFileWaveforms, PlayerWaveStyle, WaveformType;
import 'package:flutter/material.dart';
import 'package:magic_record/_features.dart';
import 'package:provider/provider.dart'
    show ChangeNotifierProvider, Consumer, WatchContext;

/// To use this widget, we need to instance [AudioPlayerLogicInterface].
class AudioPlayerCard extends StatelessWidget {
  const AudioPlayerCard(this.audioRecord, {super.key});

  final AudioRecord audioRecord;

  @override
  Widget build(BuildContext context) {
    final activeColor = Theme.of(context).primaryColor;
    final audioPlayerLogic = context.watch<AudioPlayerLogicInterface>();

    return ChangeNotifierProvider<AudioPlayerNotifier>.value(
      value: audioPlayerLogic.stateNotifier,
      child: Consumer<AudioPlayerNotifier>(
        builder: (_, notifier, __) {
          final audioPlayerState = notifier.value;

          return Card(
            elevation: 4.0,
            margin: EdgeInsets.zero,
            child: InkWell(
              borderRadius: BorderRadius.circular(4.0),
              onTap: () async {
                await audioPlayerState.when<Future<void>>(
                  play: audioPlayerLogic.pause,
                  pause: audioPlayerLogic.play,
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          audioPlayerState.when<IconData>(
                            play: () => Icons.pause,
                            pause: () => Icons.play_arrow,
                          ),
                          color: activeColor,
                        ),
                        Expanded(
                          child: ColoredBox(
                            color: Colors.transparent,
                            child: AudioFileWaveforms(
                              playerController:
                                  audioPlayerLogic.playerController,
                              size: const Size.fromHeight(80.0),
                              margin: const EdgeInsets.only(right: 8.0),
                              animationDuration: kThemeAnimationDuration,
                              enableSeekGesture: false,
                              waveformType: WaveformType.fitWidth,
                              playerWaveStyle: PlayerWaveStyle(
                                fixedWaveColor: Colors.black12,
                                liveWaveColor: activeColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0, bottom: 4.0),
                      child: Text(
                        audioRecord.formattedDate,
                        style: const TextStyle(
                          fontSize: 8.0,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
