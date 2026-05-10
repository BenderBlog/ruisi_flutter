// Copyright 2026 BenderBlog Rodriguez and Contributors.
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/foundation.dart';

import '../models/forum.dart';
import '../models/topic.dart';
import '../models/message.dart';
import '../services/api_service.dart';
import '../services/settings_service.dart';

/// 全局应用状态
class AppProvider extends ChangeNotifier {
  final ApiService api;
  final SettingsService settings;

  AppProvider(this.api, this.settings);

  // ========== 登录 ==========
  bool _loginLoading = false;
  bool get loginLoading => _loginLoading;

  bool get isLoggedIn => settings.isLogin;
  String? get username => settings.username;

  // ---- 验证码 ----
  bool _captchaRequired = false;
  bool get captchaRequired => _captchaRequired;

  String? _captchaHash;
  String? get captchaHash => _captchaHash;

  Uint8List? _captchaImageBytes;
  Uint8List? get captchaImageBytes => _captchaImageBytes;

  bool _captchaLoading = false;
  bool get captchaLoading => _captchaLoading;

  String? _captchaError;
  String? get captchaError => _captchaError;

  /// 检查登录是否需要验证码，并在需要时加载验证码图片
  Future<void> checkLoginCaptcha() async {
    _captchaHash = await api.fetchLoginCaptchaHash();
    _captchaRequired = _captchaHash != null;

    if (_captchaRequired) {
      await _loadCaptchaImage();
    }
    notifyListeners();
  }

  /// 刷新验证码图片
  Future<void> refreshCaptcha() async {
    _captchaHash = await api.fetchLoginCaptchaHash();
    await _loadCaptchaImage();
    notifyListeners();
  }

  Future<void> _loadCaptchaImage() async {
    _captchaLoading = true;
    _captchaError = null;
    notifyListeners();

    if (_captchaHash == null) {
      _captchaLoading = false;
      _captchaError = '验证码不可用';
      return;
    }

    _captchaImageBytes = await api.fetchCaptchaImage(_captchaHash!);
    _captchaLoading = false;

    if (_captchaImageBytes == null) {
      _captchaError = '验证码加载失败';
    }
  }

  /// 校验验证码
  Future<bool> verifyCaptcha(String value) async {
    if (_captchaHash == null) return false;
    return api.verifyCaptcha(_captchaHash!, value);
  }

  Future<bool> login(
    String username,
    String password, {
    String? seccodeVerify,
  }) async {
    _loginLoading = true;
    notifyListeners();

    final result = await api.login(
      username,
      password,
      seccodeHash: _captchaHash,
      seccodeVerify: seccodeVerify,
    );

    _loginLoading = false;
    notifyListeners();
    return result;
  }

  Future<void> logout() async {
    await settings.logout();
    notifyListeners();
  }

  // ========== 板块 ==========
  List<ForumGroup> _forumGroups = [];
  List<ForumGroup> get forumGroups => _forumGroups;

  bool _forumLoading = false;
  bool get forumLoading => _forumLoading;

  Future<void> loadForums() async {
    _forumLoading = true;
    notifyListeners();

    _forumGroups = await api.getForumList();

    _forumLoading = false;
    notifyListeners();
  }

  // ========== 帖子列表 ==========
  List<Topic> _topics = [];
  List<Topic> get topics => _topics;

  bool _topicLoading = false;
  bool get topicLoading => _topicLoading;

  int _currentFid = 0;
  int get currentFid => _currentFid;

  int _topicPage = 1;
  bool _hasMoreTopics = true;
  bool get hasMoreTopics => _hasMoreTopics;

  Future<void> loadTopics(int fid, {bool refresh = false}) async {
    if (refresh) {
      _topicPage = 1;
      _hasMoreTopics = true;
      _topics = [];
    }

    if (!_hasMoreTopics) return;

    _currentFid = fid;
    _topicLoading = true;
    notifyListeners();

    final newTopics = await api.getTopicList(fid, page: _topicPage);
    if (newTopics.isEmpty) {
      _hasMoreTopics = false;
    } else {
      _topics.addAll(newTopics);
      _topicPage++;
    }

    _topicLoading = false;
    notifyListeners();
  }

  // ========== 热帖 / 最新 ==========
  List<Topic> _hotTopics = [];
  List<Topic> get hotTopics => _hotTopics;

  bool _hotLoading = false;
  bool get hotLoading => _hotLoading;

  Future<void> loadHotTopics() async {
    _hotLoading = true;
    notifyListeners();
    _hotTopics = await api.getHotTopics();
    _hotLoading = false;
    notifyListeners();
  }

  List<Topic> _newTopics = [];
  List<Topic> get newTopics => _newTopics;

  bool _newLoading = false;
  bool get newLoading => _newLoading;

  int _newPage = 1;
  bool _hasMoreNew = true;
  bool get hasMoreNew => _hasMoreNew;

  Future<void> loadNewTopics({bool refresh = false}) async {
    if (refresh) {
      _newPage = 1;
      _hasMoreNew = true;
      _newTopics = [];
    }

    if (!_hasMoreNew) return;

    _newLoading = true;
    notifyListeners();

    final result = await api.getNewTopics(page: _newPage);
    if (result.isEmpty) {
      _hasMoreNew = false;
    } else {
      _newTopics.addAll(result);
      _newPage++;
    }

    _newLoading = false;
    notifyListeners();
  }

  // ========== 最新回复 ==========
  List<Topic> _newReplyTopics = [];
  List<Topic> get newReplyTopics => _newReplyTopics;

  bool _newReplyLoading = false;
  bool get newReplyLoading => _newReplyLoading;

  int _newReplyPage = 1;
  bool _hasMoreNewReply = true;
  bool get hasMoreNewReply => _hasMoreNewReply;

  Future<void> loadNewReplyTopics({bool refresh = false}) async {
    if (refresh) {
      _newReplyPage = 1;
      _hasMoreNewReply = true;
      _newReplyTopics = [];
    }

    if (!_hasMoreNewReply) return;

    _newReplyLoading = true;
    notifyListeners();

    final result = await api.getNewReplyTopics(page: _newReplyPage);
    if (result.isEmpty) {
      _hasMoreNewReply = false;
    } else {
      _newReplyTopics.addAll(result);
      _newReplyPage++;
    }

    _newReplyLoading = false;
    notifyListeners();
  }

  // ========== 我的帖子 ==========
  List<Topic> _myTopics = [];
  List<Topic> get myTopics => _myTopics;

  bool _myTopicsLoading = false;
  bool get myTopicsLoading => _myTopicsLoading;

  Future<void> loadMyTopics({bool refresh = false}) async {
    _myTopicsLoading = true;
    notifyListeners();

    if (refresh) _myTopics = [];
    _myTopics = await api.getMyTopics();

    _myTopicsLoading = false;
    notifyListeners();
  }

  // ========== 论坛网络收藏 ==========
  List<Topic> _favorites = [];
  List<Topic> get favorites => _favorites;

  bool _favoritesLoading = false;
  bool get favoritesLoading => _favoritesLoading;

  Future<void> loadFavorites({bool refresh = false}) async {
    _favoritesLoading = true;
    notifyListeners();

    if (refresh) _favorites = [];
    _favorites = await api.getFavorites();

    _favoritesLoading = false;
    notifyListeners();
  }

  Future<bool> addFavorite(int tid) async {
    return api.addFavorite(tid);
  }

  // ========== 签到 ==========
  SignResult? _signResult;
  SignResult? get signResult => _signResult;

  bool _signLoading = false;
  bool get signLoading => _signLoading;

  Future<void> sign() async {
    _signLoading = true;
    notifyListeners();

    _signResult = await api.sign();

    _signLoading = false;
    notifyListeners();
  }

  // ========== 消息通知 ==========
  List<ReplyNotification> _replyNotifications = [];
  List<ReplyNotification> get replyNotifications => _replyNotifications;

  List<AtNotification> _atNotifications = [];
  List<AtNotification> get atNotifications => _atNotifications;

  bool _messageLoading = false;
  bool get messageLoading => _messageLoading;

  Future<void> loadMessages() async {
    _messageLoading = true;
    notifyListeners();

    final results = await Future.wait([
      api.getReplyNotifications(),
      api.getAtNotifications(),
    ]);

    _replyNotifications = results[0] as List<ReplyNotification>;
    _atNotifications = results[1] as List<AtNotification>;

    _messageLoading = false;
    notifyListeners();
  }

  // ========== 搜索 ==========
  List<Topic> _searchResults = [];
  List<Topic> get searchResults => _searchResults;

  bool _searchLoading = false;
  bool get searchLoading => _searchLoading;

  Future<void> search(String keyword) async {
    _searchLoading = true;
    _searchKeyword = keyword;
    notifyListeners();

    _searchResults = await api.search(keyword);

    _searchLoading = false;
    notifyListeners();
  }

  String _searchKeyword = '';
  String get searchKeyword => _searchKeyword;

  void clearSearch() {
    _searchResults = [];
    _searchKeyword = '';
    notifyListeners();
  }

  // ========== 代理设置 ==========
  Future<void> updateProxy({
    required bool enabled,
    required String host,
    required int port,
  }) async {
    await settings.setProxy(enabled: enabled, host: host, port: port);
    api.ruisiApi.setProxy(enabled: enabled, host: host, port: port);
    notifyListeners();
  }
}
