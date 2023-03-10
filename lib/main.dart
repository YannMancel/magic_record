import 'package:flutter/material.dart';
import 'package:magic_record/_features.dart';
import 'package:magic_record/app.dart';
import 'package:provider/provider.dart' show Provider;

void main() {
  runApp(
    Provider<PermissionLogicInterface>(
      create: (_) => const PermissionLogic(),
      child: const App(),
    ),
  );
}
