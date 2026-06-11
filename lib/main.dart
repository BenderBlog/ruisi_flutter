// Copyright 2026 BenderBlog Rodriguez and Contributors.
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker/talker.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'controller/ruisi_controller.dart';
import 'l10n/app_localizations.dart';
import 'router.dart';

/// 全局 Talker 实例，整个应用共用
final talker = Talker(
  settings: TalkerSettings(
    enabled: true,
    useConsoleLogs: true,
    useHistory: true,
    maxHistoryItems: 1000,
  ),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(),
  );
  final docDir = await getApplicationDocumentsDirectory();

  final ruisiService = RuisiService(
    prefs: prefs,
    cookiePath: docDir.path,
    talker: talker,
  );
  GetIt.instance.registerSingleton<RuisiService>(ruisiService);

  talker.info('睿思论坛 Flutter 客户端启动');

  runApp(const RuisiApp());
}

class RuisiApp extends StatelessWidget {
  const RuisiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '睿思',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      routerConfig: createRouter(),
    );
  }
}
