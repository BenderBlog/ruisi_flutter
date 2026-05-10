// Copyright 2026 BenderBlog Rodriguez and Contributors.
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:talker/talker.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'providers/app_provider.dart';
import 'repository/ruisi_api.dart';
import 'services/api_service.dart';
import 'services/settings_service.dart';

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

  final settings = SettingsService();
  await settings.init();

  final docDir = await getApplicationDocumentsDirectory();
  final ruisiApi = RuisiApi(cookiePath: docDir.path, talker: talker);
  final api = ApiService(ruisiApi, settings);

  talker.info('睿思论坛 Flutter 客户端启动');

  // 应用已保存的代理设置
  if (settings.proxyEnabled) {
    ruisiApi.setProxy(
      enabled: true,
      host: settings.proxyHost,
      port: settings.proxyPort,
    );
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider(api, settings)),
        Provider<Talker>.value(value: talker),
      ],
      child: const RuisiApp(),
    ),
  );
}

class RuisiApp extends StatelessWidget {
  const RuisiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '睿思',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      home: context.read<AppProvider>().isLoggedIn
          ? const HomePage()
          : const LoginPage(),
    );
  }
}
