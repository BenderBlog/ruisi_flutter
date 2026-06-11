// Copyright 2026 BenderBlog Rodriguez and Contributors.
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../l10n/app_localizations.dart';
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
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.aboutTitle)),
      body: ListView(
        children: [
          const SizedBox(height: 40),
          // Logo
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/app_logo.png',
                width: 80,
                height: 80,
                errorBuilder: (_, _, _) =>
                    const Icon(Icons.forum, size: 80, color: Colors.blue),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              AppLocalizations.of(context)!.aboutAppName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              AppLocalizations.of(context)!.aboutSubtitle,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          const SizedBox(height: 40),
          const Divider(),

          // 版本
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(AppLocalizations.of(context)!.aboutVersion),
            subtitle: Text(AppLocalizations.of(context)!.aboutVersionNumber),
          ),

          // 源代码
          ListTile(
            leading: const Icon(Icons.code),
            title: Text(AppLocalizations.of(context)!.aboutSourceCode),
            subtitle: Text(Urls.homePage),
            onTap: () => _openUrl(Urls.homePage),
          ),

          // 反馈
          ListTile(
            leading: const Icon(Icons.bug_report),
            title: Text(AppLocalizations.of(context)!.aboutBugReport),
            subtitle: Text(
              AppLocalizations.of(context)!.aboutBugReportSubtitle,
            ),
            onTap: () => _openUrl('${Urls.homePage}/issues'),
          ),

          const Divider(),

          // 隐私政策
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(AppLocalizations.of(context)!.aboutPrivacyPolicy),
            onTap: () => _showPrivacyPolicy(context),
          ),

          const Divider(),

          // 开源许可
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              AppLocalizations.of(context)!.aboutLicense,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
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
        title: Text(AppLocalizations.of(context)!.aboutPrivacyPolicy),
        content: SingleChildScrollView(
          child: Text(AppLocalizations.of(context)!.aboutPrivacyPolicyContent),
        ),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(),
            child: Text(AppLocalizations.of(context)!.commonConfirm),
          ),
        ],
      ),
    );
  }
}
