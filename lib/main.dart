import 'package:flutter/material.dart';
import 'package:magic_record/_features.dart';
import 'package:magic_record/app.dart';
import 'package:provider/provider.dart' show MultiProvider, Provider;
import 'package:provider/single_child_widget.dart' show SingleChildWidget;

void main() {
  runApp(
    MultiProvider(
      providers: <SingleChildWidget>[
        Provider<PermissionRepositoryInterface>(
          lazy: true,
          create: (_) => const PermissionRepository(),
        ),
        Provider<StorageRepositoryInterface>(
          lazy: true,
          create: (_) => StorageRepository(),
        ),
      ],
      child: const App(),
    ),
  );
}
