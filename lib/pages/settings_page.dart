// Copyright 2026 BenderBlog Rodriguez and Contributors.
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../main.dart';
import '../providers/app_provider.dart';
import 'about_page.dart';
import 'login_page.dart';

/// 设置页面
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final settings = app.settings;

    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        children: [
          // 账号信息
          if (app.isLoggedIn) ...[
            ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Text(app.username ?? '未知用户'),
              subtitle: Text('uid: ${settings.uid ?? ""}'),
            ),
            const Divider(),
          ],

          // 完整样式帖子
          SwitchListTile(
            title: const Text('完整样式帖子'),
            subtitle: const Text('显示帖子中的完整富文本样式'),
            value: settings.showFullStylePosts,
            onChanged: (value) => settings.setShowFullStyle(value),
          ),

          const Divider(),

          // 代理设置
          SwitchListTile(
            title: const Text('HTTP 代理'),
            subtitle: Text(
              settings.proxyEnabled
                  ? '${settings.proxyHost}:${settings.proxyPort}'
                  : '未启用',
            ),
            value: settings.proxyEnabled,
            onChanged: (value) {
              if (value) {
                _showProxyDialog(context, app);
              } else {
                app.updateProxy(enabled: false, host: '', port: 0);
              }
            },
          ),
          if (settings.proxyEnabled)
            ListTile(
              leading: const Icon(Icons.edit, size: 20),
              title: const Text('修改代理地址'),
              onTap: () => _showProxyDialog(context, app),
            ),

          const Divider(),

          // 日志查看
          ListTile(
            leading: const Icon(Icons.bug_report),
            title: const Text('查看日志'),
            subtitle: const Text('Talker 运行日志'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => TalkerScreen(talker: talker)),
            ),
          ),

          // 关于
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('关于'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AboutPage()),
            ),
          ),

          // 登录/登出
          const Divider(),
          if (app.isLoggedIn)
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('退出登录', style: TextStyle(color: Colors.red)),
              onTap: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('确认退出'),
                    content: const Text('确定要退出登录吗？'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('取消'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: const Text('确定'),
                      ),
                    ],
                  ),
                );
                if (confirmed == true) {
                  await app.logout();
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                      (route) => false,
                    );
                  }
                }
              },
            )
          else
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('登录'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              ),
            ),
        ],
      ),
    );
  }

  void _showProxyDialog(BuildContext context, AppProvider app) {
    final settings = app.settings;
    final hostController = TextEditingController(
      text: settings.proxyEnabled ? settings.proxyHost : '',
    );
    final portController = TextEditingController(
      text: settings.proxyEnabled ? settings.proxyPort.toString() : '',
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('代理设置'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: hostController,
              decoration: const InputDecoration(
                labelText: '主机地址',
                hintText: '例如 127.0.0.1',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: portController,
              decoration: const InputDecoration(
                labelText: '端口',
                hintText: '例如 7890',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              final host = hostController.text.trim();
              final port = int.tryParse(portController.text.trim()) ?? 0;
              if (host.isNotEmpty && port > 0) {
                app.updateProxy(enabled: true, host: host, port: port);
                Navigator.pop(ctx);
              }
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}
