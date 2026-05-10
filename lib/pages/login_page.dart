// Copyright 2026 BenderBlog Rodriguez and Contributors.
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'home_page.dart';
import 'settings_page.dart';

/// 登录页面
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _captchaCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    // 页面加载后始终加载验证码
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().checkLoginCaptcha();
    });
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    _captchaCtrl.dispose();
    super.dispose();
  }

  Future<void> _doLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final app = context.read<AppProvider>();

    // 如果需要验证码但未输入
    if (app.captchaRequired && _captchaCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请输入验证码')));
      return;
    }

    final ok = await app.login(
      _usernameCtrl.text,
      _passwordCtrl.text,
      seccodeVerify: app.captchaRequired ? _captchaCtrl.text.trim() : null,
    );

    if (!mounted) return;

    if (ok) {
      // 登录成功，进入主页
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomePage()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('登录失败，请检查用户名和密码')));
      // 登录失败后刷新验证码
      _captchaCtrl.clear();
      context.read<AppProvider>().refreshCaptcha();
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('登录'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: '设置',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsPage()),
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo
                  Icon(
                    Icons.school,
                    size: 72,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '睿思论坛',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Text('西安电子科技大学校园论坛'),
                  const SizedBox(height: 32),

                  // 用户名
                  TextFormField(
                    controller: _usernameCtrl,
                    decoration: const InputDecoration(
                      labelText: '用户名',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (v) =>
                        v == null || v.trim().isEmpty ? '请输入用户名' : null,
                  ),
                  const SizedBox(height: 16),

                  // 密码
                  TextFormField(
                    controller: _passwordCtrl,
                    decoration: InputDecoration(
                      labelText: '密码',
                      prefixIcon: const Icon(Icons.lock),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    obscureText: _obscure,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: null,
                    validator: (v) => v == null || v.isEmpty ? '请输入密码' : null,
                  ),

                  // 验证码区域（仅当服务器要求时显示）
                  if (app.captchaRequired) ...[
                    const SizedBox(height: 16),
                    _CaptchaWidget(
                      controller: _captchaCtrl,
                      imageBytes: app.captchaImageBytes,
                      loading: app.captchaLoading,
                      error: app.captchaError,
                      onRefresh: () {
                        _captchaCtrl.clear();
                        app.refreshCaptcha();
                      },
                      onSubmitted: (_) => _doLogin(),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // 登录按钮
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: app.loginLoading ? null : _doLogin,
                      child: app.loginLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('登录'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 验证码控件
class _CaptchaWidget extends StatelessWidget {
  final TextEditingController controller;
  final Uint8List? imageBytes;
  final bool loading;
  final String? error;
  final VoidCallback onRefresh;
  final ValueChanged<String> onSubmitted;

  const _CaptchaWidget({
    required this.controller,
    required this.imageBytes,
    required this.loading,
    required this.error,
    required this.onRefresh,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 验证码输入框
            Expanded(
              child: TextFormField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: '验证码',
                  prefixIcon: Icon(Icons.verified_user),
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.done,
                textCapitalization: TextCapitalization.characters,
                onFieldSubmitted: onSubmitted,
                validator: (v) => null, // 由外部校验
              ),
            ),
            const SizedBox(width: 12),
            // 验证码图片
            GestureDetector(
              onTap: onRefresh,
              child: Container(
                width: 120,
                height: 56,
                decoration: BoxDecoration(
                  border: Border.all(color: colorScheme.outline),
                  borderRadius: BorderRadius.circular(4),
                  color: colorScheme.surfaceContainerHighest,
                ),
                clipBehavior: Clip.antiAlias,
                child: _buildContent(colorScheme),
              ),
            ),
          ],
        ),
        if (error != null) ...[
          const SizedBox(height: 4),
          Text(
            error!,
            style: TextStyle(fontSize: 12, color: colorScheme.error),
          ),
        ],
        const SizedBox(height: 4),
        GestureDetector(
          onTap: onRefresh,
          child: Text(
            '点击图片刷新验证码',
            style: TextStyle(
              fontSize: 12,
              color: colorScheme.primary,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(ColorScheme colorScheme) {
    if (loading) {
      return const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    if (imageBytes != null && imageBytes!.isNotEmpty) {
      return Image.memory(
        imageBytes!,
        fit: BoxFit.contain,
        gaplessPlayback: true, // 防止刷新时闪烁
        errorBuilder: (_, __, ___) => Center(
          child: Icon(Icons.broken_image, color: colorScheme.error, size: 24),
        ),
      );
    }

    return Center(
      child: Icon(Icons.refresh, color: colorScheme.onSurfaceVariant, size: 24),
    );
  }
}
