// Copyright 2026 BenderBlog Rodriguez and Contributors.
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/urls.dart';

/// 关于页面
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  void _openUrl(String url) {
    if (url.isNotEmpty) {
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('关于')),
      body: ListView(
        children: [
          const SizedBox(height: 40),
          // Logo
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/app_logo.png',
                width: 80,
                height: 80,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.forum, size: 80, color: Colors.blue),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              '睿思',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              '西安电子科技大学校园论坛客户端',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          const SizedBox(height: 40),
          const Divider(),

          // 版本
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('版本'),
            subtitle: Text('2.0.0 (Flutter)'),
          ),

          // 源代码
          ListTile(
            leading: const Icon(Icons.code),
            title: const Text('源代码'),
            subtitle: Text(Urls.homePage),
            onTap: () => _openUrl(Urls.homePage),
          ),

          // 反馈
          ListTile(
            leading: const Icon(Icons.bug_report),
            title: const Text('问题反馈'),
            subtitle: const Text('在 GitHub 上提交 issue'),
            onTap: () => _openUrl('${Urls.homePage}/issues'),
          ),

          const Divider(),

          // 隐私政策
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('隐私政策'),
            onTap: () => _showPrivacyPolicy(context),
          ),

          const Divider(),

          // 开源许可
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              '本应用基于 BSD-3-Clause 许可证开源',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('隐私政策'),
        content: const SingleChildScrollView(
          child: Text(
            '本应用仅在西安电子科技大学校园网内运行，访问睿思论坛 (rs.xidian.edu.cn) 的数据。\n\n'
            '本应用不会收集、存储或传输任何用户的个人信息到第三方服务器。\n\n'
            '用户的登录凭据仅保存在本地设备中，用于与睿思论坛服务器进行身份验证。\n\n'
            '本应用使用 Cookie 与睿思论坛服务器进行通信，所有数据交互均直接在用户的设备与睿思论坛服务器之间进行。\n\n'
            '如有任何疑问，请通过 GitHub 提交 issue 联系开发者。',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}
