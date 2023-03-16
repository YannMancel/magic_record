import 'package:flutter_test/flutter_test.dart'
    show anything, expect, setUp, tearDown, test;
import 'package:magic_record/_features.dart';
import 'package:mockito/mockito.dart'
    show any, anyNamed, reset, verifyInOrder, when;

import '../repositories/storage_repository_test.mocks.dart'
    show MockHiveBoxOfList, MockHiveInterface;

void main() {
  late MockHiveInterface mockHiveInterface;
  late MockHiveBoxOfList mockHiveBox;
  late StorageRepositoryInterface repository;
  late MyAudioRecordsLogicInterface logic;

  const kAudioRecord = AudioRecord(
    formattedDate: 'fakeDate',
    audioPath: 'FakePath',
  );

  final audioRecordJson = <String, String>{
    MyAudioRecordsLogic.kFormattedDateKey: kAudioRecord.formattedDate,
    MyAudioRecordsLogic.kAudioPathKey: kAudioRecord.audioPath,
  };

  setUp(() {
    mockHiveInterface = MockHiveInterface();
    mockHiveBox = MockHiveBoxOfList();

    when(mockHiveInterface.openBox<List<dynamic>>(any))
        .thenAnswer((_) async => mockHiveBox);

    repository = StorageRepository(hive: mockHiveInterface);
    logic = MyAudioRecordsLogic(storageRepository: repository);
  });

  tearDown(() async {
    await repository.onDispose();
    reset(mockHiveInterface);
    reset(mockHiveBox);
  });

  test('Setup async must called HiveInterface.openBox', () async {
    await (logic as MyAudioRecordsLogic).completer.future;
    verifyInOrder([
      mockHiveInterface.openBox<List<dynamic>>(any),
      mockHiveBox.get(anything, defaultValue: anyNamed('defaultValue')),
    ]);
  });

  test('fromJson call must be a success', () async {
    final audioRecord = MyAudioRecordsLogic.fromJson(audioRecordJson);
    expect(audioRecord, kAudioRecord);
  });

  test('toJson call must be a success', () async {
    final json = MyAudioRecordsLogic.toJson(kAudioRecord);
    expect(json, audioRecordJson);
  });

  test('Add call must be a success', () async {
    final data = List<dynamic>.empty(growable: true);

    when(mockHiveBox.get(anything, defaultValue: anyNamed('defaultValue')))
        .thenAnswer((_) => data);
    when(mockHiveBox.put(anything, any)).thenAnswer((_) async {
      // We should pass kAudioRecord json but here there is no importance.
      data.add(kAudioRecord);
    });

    expect(logic.stateNotifier.value, List<AudioRecord>.empty());
    await logic.add(kAudioRecord);
    expect(logic.stateNotifier.value, const <AudioRecord>[kAudioRecord]);
    verifyInOrder([
      mockHiveInterface.openBox<List<dynamic>>(any),
      mockHiveBox.get(anything, defaultValue: anyNamed('defaultValue')),
      mockHiveBox.put(anything, any),
    ]);
  });

  test('Delete call must be a success', () async {
    final data = List<dynamic>.empty(growable: true);

    when(mockHiveBox.get(anything, defaultValue: anyNamed('defaultValue')))
        .thenAnswer((_) => data);
    when(mockHiveBox.put(anything, any)).thenAnswer((_) async {
      // We should pass kAudioRecord json but here there is no importance.
      data.add(kAudioRecord);
    });
    when(mockHiveBox.delete(anything)).thenAnswer((_) async {
      // We should pass kAudioRecord json but here there is no importance.
      data.remove(kAudioRecord);
    });

    await logic.add(kAudioRecord);
    expect(logic.stateNotifier.value, const <AudioRecord>[kAudioRecord]);
    await logic.delete(kAudioRecord, needToRemoveFile: false);
    expect(logic.stateNotifier.value, List<AudioRecord>.empty());
    verifyInOrder([
      mockHiveInterface.openBox<List<dynamic>>(any),
      mockHiveBox.get(anything, defaultValue: anyNamed('defaultValue')),
      mockHiveBox.put(anything, any),
      mockHiveBox.put(anything, any),
    ]);
  });
}
