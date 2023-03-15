import 'dart:async';

import 'package:audio_waveforms/audio_waveforms.dart'
    show
        AudioFileWaveforms,
        FinishMode,
        PlayerController,
        PlayerState,
        PlayerStateExtension,
        PlayerWaveStyle,
        WaveformType;
import 'package:flutter/material.dart';
import 'package:magic_record/_features.dart';

class MyAudioCard extends StatefulWidget {
  const MyAudioCard(this.audioRecord, {super.key});

  final AudioRecord audioRecord;

  @override
  State<MyAudioCard> createState() => _MyAudioCardState();
}

class _MyAudioCardState extends State<MyAudioCard> {
  late PlayerController _playerController;
  late StreamSubscription<PlayerState> _playerStateStream;

  bool get _isPlaying => _playerController.playerState.isPlaying;

  @override
  void initState() {
    super.initState();
    _playerController = PlayerController();

    _playerStateStream = _playerController.onPlayerStateChanged.listen((state) {
      if (state.isPaused && mounted) setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _playerController.preparePlayer(
        path: widget.audioRecord.audioPath,
        shouldExtractWaveform: true,
        volume: 1.0,
      );
    });
  }

  @override
  void dispose() {
    _playerStateStream.cancel().then((_) => _playerController.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = Theme.of(context).primaryColor;

    return Card(
      elevation: 4.0,
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(4.0),
        onTap: () async {
          _isPlaying
              ? await _playerController.pausePlayer()
              : await _playerController.startPlayer(
                  finishMode: FinishMode.pause);

          setState(() {});
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: activeColor,
                  ),
                  Expanded(
                    child: ColoredBox(
                      color: Colors.transparent,
                      child: AudioFileWaveforms(
                        playerController: _playerController,
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
                  widget.audioRecord.formattedDate,
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
  }
}
