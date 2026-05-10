// Copyright 2026 BenderBlog Rodriguez and Contributors.
// SPDX-License-Identifier: BSD-3-Clause

import 'package:shared_preferences/shared_preferences.dart';

/// 用户设置与认证状态管理
/// 假设程序仅在校内网运行
class SettingsService {
  static const _keyUid = 'uid';
  static const _keyUsername = 'username';
  static const _keyFormhash = 'formhash';
  static const _keyPassword = 'password';
  static const _keyShowFullStyle = 'showFullStylePosts';
  static const _keyProxyEnabled = 'proxyEnabled';
  static const _keyProxyHost = 'proxyHost';
  static const _keyProxyPort = 'proxyPort';

  late SharedPreferences _prefs;

  int? _uid;
  String? _username;
  String? _formhash;
  String? _password;
  bool _showFullStylePosts = false;
  bool _proxyEnabled = false;
  String _proxyHost = '';
  int _proxyPort = 0;

  int? get uid => _uid;
  String? get username => _username;
  String? get formhash => _formhash;
  String? get password => _password;
  bool get showFullStylePosts => _showFullStylePosts;
  bool get proxyEnabled => _proxyEnabled;
  String get proxyHost => _proxyHost;
  int get proxyPort => _proxyPort;
  bool get isLogin => _uid != null;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _uid = _prefs.getInt(_keyUid);
    _username = _prefs.getString(_keyUsername);
    _formhash = _prefs.getString(_keyFormhash);
    _password = _prefs.getString(_keyPassword);
    _showFullStylePosts = _prefs.getBool(_keyShowFullStyle) ?? false;
    _proxyEnabled = _prefs.getBool(_keyProxyEnabled) ?? false;
    _proxyHost = _prefs.getString(_keyProxyHost) ?? '';
    _proxyPort = _prefs.getInt(_keyProxyPort) ?? 0;
  }

  Future<void> saveLogin({
    required int uid,
    required String username,
    required String formhash,
    String? password,
  }) async {
    _uid = uid;
    _username = username;
    _formhash = formhash;
    _password = password;
    await _prefs.setInt(_keyUid, uid);
    await _prefs.setString(_keyUsername, username);
    await _prefs.setString(_keyFormhash, formhash);
    if (password != null) {
      await _prefs.setString(_keyPassword, password);
    }
  }

  Future<void> logout() async {
    _uid = null;
    _username = null;
    _formhash = null;
    _password = null;
    await _prefs.remove(_keyUid);
    await _prefs.remove(_keyUsername);
    await _prefs.remove(_keyFormhash);
    await _prefs.remove(_keyPassword);
  }

  Future<void> updateFormhash(String formhash) async {
    _formhash = formhash;
    await _prefs.setString(_keyFormhash, formhash);
  }

  Future<void> setShowFullStyle(bool value) async {
    _showFullStylePosts = value;
    await _prefs.setBool(_keyShowFullStyle, value);
  }

  Future<void> setProxy({
    required bool enabled,
    required String host,
    required int port,
  }) async {
    _proxyEnabled = enabled;
    _proxyHost = host;
    _proxyPort = port;
    await _prefs.setBool(_keyProxyEnabled, enabled);
    await _prefs.setString(_keyProxyHost, host);
    await _prefs.setInt(_keyProxyPort, port);
  }
}
