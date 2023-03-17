import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart'
    show
        expect,
        find,
        findsNothing,
        findsOneWidget,
        setUp,
        tearDown,
        testWidgets;
import 'package:magic_record/_features.dart';
import 'package:mockito/mockito.dart' show reset;
import 'package:provider/provider.dart' show Provider;

import '../helper.dart' show Helper;
import '../logics/audio_player_logic_test.mocks.dart' show MockPlayerController;

void main() {
  late MockPlayerController mockPlayerController;
  late AudioPlayerLogicInterface logic;

  setUp(() {
    mockPlayerController = MockPlayerController();
  });

  tearDown(() async {
    await logic.onDispose();
    reset(mockPlayerController);
  });

  testWidgets('Show play icon must be a success', (tester) async {
    logic = AudioPlayerLogic(
      audioPath: 'https://s3.amazonaws.com/scifri-episodes/'
          'scifri20181123-episode.mp3',
      playerController: mockPlayerController,
    );
    final widget = Provider<AudioPlayerLogicInterface>.value(
      value: logic,
      child: const MaterialApp(
        home: AudioPlayerCard(Helper.kAudioRecord),
      ),
    );
    await tester.pumpWidget(widget);
    expect(find.byIcon(Icons.pause), findsNothing);
    expect(find.byIcon(Icons.play_arrow), findsOneWidget);
  });

  testWidgets('Show pause icon must be a success', (tester) async {
    logic = AudioPlayerLogic(
      audioPath: 'https://s3.amazonaws.com/scifri-episodes/'
          'scifri20181123-episode.mp3',
      playerController: mockPlayerController,
    );
    final widget = Provider<AudioPlayerLogicInterface>.value(
      value: logic,
      child: const MaterialApp(
        home: AudioPlayerCard(Helper.kAudioRecord),
      ),
    );
    await tester.pumpWidget(widget);
    (logic as AudioPlayerLogic).notify = const AudioPlayerState.play();
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.pause), findsOneWidget);
    expect(find.byIcon(Icons.play_arrow), findsNothing);
  });
}
