import 'package:flutter/material.dart';
import 'package:magic_record/_features.dart';
import 'package:provider/provider.dart'
    show MultiProvider, Provider, ReadContext;
import 'package:provider/single_child_widget.dart' show SingleChildWidget;

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: <SingleChildWidget>[
        Provider<AudioRecorderLogicInterface>(
          lazy: false,
          create: (context) => AudioRecorderLogic(
            permissionRepository: context.read<PermissionRepositoryInterface>(),
          ),
          dispose: (_, logic) => logic.onDispose(),
        ),
        Provider<MyAudioRecordsLogicInterface>(
          lazy: false,
          create: (context) => MyAudioRecordsLogic(
            storageRepository: context.read<StorageRepositoryInterface>(),
          ),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: const SafeArea(
          child: MyAudioRecordsWidget(
            padding: EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              bottom: 108.0,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: const AudioRecorderButton(),
      ),
    );
  }
}
