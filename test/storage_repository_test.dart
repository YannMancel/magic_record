import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart' show Box, HiveInterface;
import 'package:magic_record/_features.dart';
import 'package:mockito/annotations.dart' show GenerateNiceMocks, MockSpec;
import 'package:mockito/mockito.dart'
    show any, anyNamed, reset, verify, verifyInOrder, when;

import 'storage_repository_test.mocks.dart'
    show MockHiveBoxOfList, MockHiveInterface;

@GenerateNiceMocks(
  <MockSpec<dynamic>>[
    MockSpec<HiveInterface>(),
    MockSpec<Box<List<dynamic>>>(as: #MockHiveBoxOfList),
  ],
)
void main() {
  late MockHiveInterface mockHiveInterface;
  late MockHiveBoxOfList mockHiveBox;
  late StorageRepositoryInterface repository;

  setUp(() {
    mockHiveInterface = MockHiveInterface();
    mockHiveBox = MockHiveBoxOfList();

    when(mockHiveInterface.openBox<List<dynamic>>('my_audio_records'))
        .thenAnswer((_) async => mockHiveBox);

    repository = StorageRepository(
      hive: mockHiveInterface,
      needToInitiateHive: false,
    );
  });

  tearDown(() async {
    await repository.onDispose();
    reset(mockHiveInterface);
    reset(mockHiveBox);
  });

  test('Setup async must called HiveInterface.openBox', () async {
    await repository.completer.future;
    verify(mockHiveInterface.openBox<List<dynamic>>(any)).called(1);
  });

  test('get must called HiveBox.get', () async {
    const kKey = 'key';
    const kValue = <dynamic>['value1', 'value2'];

    when(mockHiveBox.get(anything, defaultValue: anyNamed('defaultValue')))
        .thenAnswer((_) => kValue);

    final listOrNull = await repository.get(key: kKey);

    expect(listOrNull, isNotNull);
    expect(listOrNull!.length, kValue.length);
    verifyInOrder([
      mockHiveInterface.openBox<List<dynamic>>(any),
      mockHiveBox.get(anything, defaultValue: anyNamed('defaultValue'))
    ]);
  });

  test('put must called HiveBox.put', () async {
    await repository.put(
      key: 'key',
      value: <String>['value1', 'value2'],
    );
    verifyInOrder([
      mockHiveInterface.openBox<List<dynamic>>(any),
      mockHiveBox.put(anything, any)
    ]);
  });

  test('delete must called HiveBox.delete', () async {
    await repository.delete(key: 'key');
    verifyInOrder([
      mockHiveInterface.openBox<List<dynamic>>(any),
      mockHiveBox.delete(anything)
    ]);
  });
}
