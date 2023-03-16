import 'package:audio_waveforms/audio_waveforms.dart' show PlayerController;
import 'package:flutter_test/flutter_test.dart'
    show expect, setUp, tearDown, test;
import 'package:magic_record/_features.dart';
import 'package:mockito/annotations.dart' show GenerateNiceMocks, MockSpec;
import 'package:mockito/mockito.dart' show anyNamed, reset, verifyInOrder;

import 'audio_player_logic_test.mocks.dart' show MockPlayerController;

@GenerateNiceMocks(
  <MockSpec<dynamic>>[
    MockSpec<PlayerController>(),
  ],
)
void main() {
  late MockPlayerController mockPlayerController;
  late AudioPlayerLogicInterface logic;

  setUp(() {
    mockPlayerController = MockPlayerController();
    logic = AudioPlayerLogic(
      audioPath: 'FakePath',
      playerController: mockPlayerController,
    );
  });

  tearDown(() async {
    await logic.onDispose();
    reset(mockPlayerController);
  });

  test('Setup async with AudioPlayerState.pause', () async {
    await (logic as AudioPlayerLogic).completer.future;
    expect(logic.stateNotifier.value, const AudioPlayerState.pause());
    verifyInOrder([
      mockPlayerController.onPlayerStateChanged,
      mockPlayerController.preparePlayer(
        path: anyNamed('path'),
        shouldExtractWaveform: anyNamed('shouldExtractWaveform'),
        volume: anyNamed('volume'),
      ),
    ]);
  });

  test('play call must be a success', () async {
    //final streamController = StreamController<PlayerState>()
    //  ..add(PlayerState.initialized);

    //when(mockPlayerController.onPlayerStateChanged)
    //    .thenAnswer((_) => streamController.stream);

    //when(mockPlayerController.startPlayer(finishMode: anyNamed('finishMode')))
    //    .thenAnswer((_) async => streamController.add(PlayerState.playing));

    await logic.play();
    //expect(logic.stateNotifier.value, const AudioPlayerState.play());
    verifyInOrder([
      mockPlayerController.onPlayerStateChanged,
      mockPlayerController.preparePlayer(
        path: anyNamed('path'),
        shouldExtractWaveform: anyNamed('shouldExtractWaveform'),
        volume: anyNamed('volume'),
      ),
      mockPlayerController.startPlayer(finishMode: anyNamed('finishMode')),
    ]);
  });

  test('pause call must be a success', () async {
    await logic.pause();
    //expect(logic.stateNotifier.value, const AudioPlayerState.pause());
    verifyInOrder([
      mockPlayerController.onPlayerStateChanged,
      mockPlayerController.preparePlayer(
        path: anyNamed('path'),
        shouldExtractWaveform: anyNamed('shouldExtractWaveform'),
        volume: anyNamed('volume'),
      ),
      mockPlayerController.pausePlayer(),
    ]);
  });
}
