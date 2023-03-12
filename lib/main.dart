import 'package:flutter/material.dart';
import 'package:magic_record/_features.dart';
import 'package:magic_record/app.dart';
import 'package:provider/provider.dart' show Provider;

void main() {
  runApp(
    Provider<PermissionRepositoryInterface>(
      lazy: true,
      create: (_) => const PermissionRepository(),
      child: const App(),
    ),
  );
}
