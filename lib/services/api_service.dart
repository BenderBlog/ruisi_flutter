// Copyright 2026 BenderBlog Rodriguez and Contributors.
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:html/parser.dart' as html_parser;

import '../constants/urls.dart';
import '../models/forum.dart';
import '../models/topic.dart';
import '../models/post.dart';
import '../models/message.dart';
import '../repository/ruisi_api.dart';
import 'settings_service.dart';

/// 业务 API 服务
///
/// 基于 [RuisiApi] 的底层 HTTP 能力，封装论坛业务逻辑。
/// Cookie 管理、formhash 注入等均由 [RuisiApi] 处理。
class ApiService {
  final RuisiApi _api;
  final SettingsService _settings;

  ApiService(this._api, this._settings);

  /// 底层 RuisiApi 实例（用于代理设置等底层操作）
  RuisiApi get ruisiApi => _api;

  // =========================================================================
  // 登录
  // =========================================================================

  /// 是否已登录
  bool get isLoggedIn => _settings.isLogin;

  /// 检查登录页是否需要验证码，返回 seccodehash（null 表示不需要）
  Future<String?> fetchLoginCaptchaHash() async {
    _api.talker.info('正在获取登录页验证码 hash...');
    final (ok, body) = await _api.get(Urls.loginUrl);
    if (!ok) {
      _api.talker.error('获取登录页失败');
      return null;
    }

    _api.talker.debug('登录页响应长度: ${body.length}');

    // 方式1: 从 <input name=seccodehash> 获取
    final doc = html_parser.parse(body);
    final input = doc.querySelector('input[name=seccodehash]');
    if (input != null) {
      final hash = input.attributes['value'];
      if (hash != null && hash.isNotEmpty) {
        _api.talker.info('验证码 hash 获取成功(input): $hash');
        return hash;
      }
    }

    // 方式2: Discuz 用 JS 动态渲染验证码，hash 在 updateseccode('HASH', ...) 中
    final jsMatch = RegExp(r"updateseccode\('(\w+)'").firstMatch(body);
    if (jsMatch != null) {
      final hash = jsMatch.group(1)!;
      _api.talker.info('验证码 hash 获取成功(js): $hash');
      return hash;
    }

    _api.talker.warning('登录页不需要验证码');
    return null;
  }

  /// 获取验证码的 update token
  Future<String?> _fetchCaptchaUpdate(String hash) async {
    final (ok, body) = await _api.get(Urls.getValidUpdateUrl(hash));
    if (!ok) return null;

    // 解析响应中的 update 值: update('xxxx')
    final match = RegExp(r"update\('(\w+)'").firstMatch(body);
    return match?.group(1);
  }

  /// 获取验证码图片二进制数据
  Future<Uint8List?> fetchCaptchaImage(String hash) async {
    _api.talker.info('正在获取验证码图片, hash=$hash');
    final update = await _fetchCaptchaUpdate(hash);
    _api.talker.info('验证码 update token: $update');
    final url = Urls.updateValidUrl(update ?? '0', hash);
    _api.talker.info('验证码图片 URL: $url');
    final (ok, data) = await _api.getRaw(url);
    if (ok) {
      _api.talker.info('验证码图片获取成功, 大小: ${data?.length ?? 0} bytes');
    } else {
      _api.talker.error('验证码图片获取失败');
    }
    return ok ? data : null;
  }

  /// 校验验证码是否正确
  Future<bool> verifyCaptcha(String hash, String value) async {
    final (ok, body) = await _api.get(Urls.checkValidUrl(hash, value));
    if (!ok) return false;
    return body.contains('succeed');
  }

  /// 登录
  Future<bool> login(
    String username,
    String password, {
    String? seccodeHash,
    String? seccodeVerify,
  }) async {
    final (webpageOk, webpage) = await _api.get(Urls.loginUrl);

    if (!webpageOk) return false;

    var document = html_parser.parse(webpage);

    String? formhash = document
        .querySelector('input[name="formhash"]')
        ?.attributes['value'];
    String? action = document
        .querySelector('form[id^="loginform_"]')
        ?.attributes['action'];
    String loginhash =
        RegExp(r'loginhash=(\w+)').firstMatch(action ?? '')?.group(1) ?? '';

    if (formhash == null || loginhash.isEmpty) return false;

    final params = <String, dynamic>{
      'formhash': formhash,
      'referer': Urls.baseUrl,
      'loginfield': 'username',
      'username': username,
      'password': md5.convert(utf8.encode(password)).toString(),
      'questionid': '0',
      'answer': '',
      'cookietime': '315360000',
    };

    // 如果有验证码，附加参数
    if (seccodeHash != null && seccodeVerify != null) {
      params['seccodehash'] = seccodeHash;
      params['seccodeverify'] = seccodeVerify;
    }

    final (ok, body) = await _api.post(
      "${Urls.loginUrl}&loginsubmit=yes&loginhash=$loginhash&inajax=1",
      params: params,
    );

    if (!ok) return false;

    // 登录后通过桌面端方式检查 uid
    final (checkOk, checkBody) = await _api.get(Urls.checkLoginUrl);

    if (!checkOk) return false;

    // 桌面端登录检查：如果响应中不包含 "succeed"，说明登录失败
    // 重新访问登录页获取用户信息
    final (pageOk, pageBody) = await _api.get(Urls.loginUrl);
    if (!pageOk) return false;

    final checkDoc = html_parser.parse(pageBody);
    // 桌面端登录成功后，页面顶部会显示用户名和退出链接
    final userLink = checkDoc.querySelector('.vwmy a[href*="space"]');
    final logoutLink = checkDoc.querySelector('a[href*="action=logout"]');

    if (userLink != null || logoutLink != null) {
      // 从页面提取 uid
      final href = userLink?.attributes['href'] ?? '';
      final uidMatch = RegExp(r'uid=(\d+)').firstMatch(href);
      final uid = uidMatch != null ? int.parse(uidMatch.group(1)!) : 0;
      final uname = userLink?.text.trim() ?? username;

      if (uid > 0) {
        await _settings.saveLogin(
          uid: uid,
          username: uname,
          formhash: _api.formhash ?? '',
          password: password,
        );
        return true;
      }
    }
    return false;
  }

  // =========================================================================
  // 板块列表
  // =========================================================================

  Future<List<ForumGroup>> getForumList() async {
    final (ok, body) = await _api.get(Urls.forumlistUrl);
    if (!ok) return [];

    final doc = html_parser.parse(body);
    final groups = <ForumGroup>[];

    final sections = doc.querySelectorAll('.bm_c');
    for (int i = 0; i < sections.length; i++) {
      final section = sections[i];
      final forumItems = section.querySelectorAll('a[href*="forumdisplay"]');
      if (forumItems.isEmpty) continue;

      final forums = <Forum>[];
      for (final item in forumItems) {
        final name = item.text.trim();
        final href = item.attributes['href'] ?? '';
        final fidMatch = RegExp(r'fid=(\d+)').firstMatch(href);
        if (fidMatch != null && name.isNotEmpty) {
          forums.add(Forum(fid: int.parse(fidMatch.group(1)!), name: name));
        }
      }

      if (forums.isNotEmpty) {
        final title =
            section.parent?.querySelector('h2')?.text.trim() ?? '板块 $i';
        groups.add(ForumGroup(fgId: i, name: title, forums: forums));
      }
    }
    return groups;
  }

  // =========================================================================
  // 帖子列表
  // =========================================================================

  /// 板块帖子
  Future<List<Topic>> getTopicList(int fid, {int page = 1}) async {
    final (ok, body) = await _api.get('${Urls.getPostsUrl(fid)}&page=$page');
    if (!ok) return [];
    return _parseTopicList(body);
  }

  /// 热帖
  Future<List<Topic>> getHotTopics() async {
    final (ok, body) = await _api.get(Urls.hotUrl);
    if (!ok) return [];
    return _parseTopicList(body);
  }

  /// 最新帖子
  Future<List<Topic>> getNewTopics({int page = 1}) async {
    final (ok, body) = await _api.get('${Urls.newUrl}&page=$page');
    if (!ok) return [];
    return _parseTopicList(body);
  }

  /// 最新回复
  Future<List<Topic>> getNewReplyTopics({int page = 1}) async {
    final (ok, body) = await _api.get('${Urls.newReplyUrl}&page=$page');
    if (!ok) return [];
    return _parseTopicList(body);
  }

  /// 我的帖子
  Future<List<Topic>> getMyTopics({int page = 1}) async {
    final (ok, body) = await _api.get(
      '${Urls.getMyPostsUrl(_settings.uid)}&page=$page',
    );
    if (!ok) return [];
    return _parseTopicList(body);
  }

  /// 收藏列表
  Future<List<Topic>> getFavorites({int page = 1}) async {
    final (ok, body) = await _api.get('${Urls.starUrl}&page=$page');
    if (!ok) return [];
    return _parseTopicList(body);
  }

  List<Topic> _parseTopicList(String html) {
    final doc = html_parser.parse(html);
    final topics = <Topic>[];

    // 策略1: 桌面端 forumdisplay 页面 (板块帖子列表)
    // 结构: <tbody id="normalthread_xxx"> 包含帖子行
    final normalthreads = doc.querySelectorAll('tbody[id^="normalthread_"]');
    for (final item in normalthreads) {
      final link = item.querySelector('a.s.xst, a[href*="viewthread"]');
      if (link == null) continue;

      final title = link.text.trim();
      final href = link.attributes['href'] ?? '';
      final tidMatch = RegExp(r'tid=(\d+)').firstMatch(href);
      if (tidMatch == null || title.isEmpty) continue;

      final authorEl = item.querySelector(
        'td.by a[href*="space"], .by a[href*="space"]',
      );
      final author = authorEl?.text.trim() ?? '未知';
      final authorHref = authorEl?.attributes['href'] ?? '';
      final uidMatch = RegExp(r'uid[=:\-](\d+)').firstMatch(authorHref);

      final replyEl = item.querySelector('td.num a, .num a');
      final viewEl = item.querySelector('td.num em, .num em');

      topics.add(
        Topic(
          tid: int.parse(tidMatch.group(1)!),
          fid: 0,
          title: title,
          author: author,
          authorId: uidMatch != null ? int.parse(uidMatch.group(1)!) : 0,
          replies: replyEl != null
              ? (int.tryParse(replyEl.text.trim()) ?? 0)
              : 0,
          views: viewEl != null ? (int.tryParse(viewEl.text.trim()) ?? 0) : 0,
        ),
      );
    }

    // 策略2: 桌面端 guide 页面 (hot/new/newReply)
    // 结构: #threadlist 内的 li 元素，或 .bm_c 下的列表
    if (topics.isEmpty) {
      final guideItems = doc.querySelectorAll(
        '#threadlist li, .threadlist li, .bm_c .tl li, .bm_c ul li',
      );
      for (final item in guideItems) {
        final link = item.querySelector('a[href*="viewthread"]');
        if (link == null) continue;

        final title = link.text.trim();
        final href = link.attributes['href'] ?? '';
        final tidMatch = RegExp(r'tid=(\d+)').firstMatch(href);
        if (tidMatch == null || title.isEmpty) continue;

        final authorEl = item.querySelector('a[href*="space"]');
        final author = authorEl?.text.trim() ?? '未知';
        final authorHref = authorEl?.attributes['href'] ?? '';
        final uidMatch = RegExp(r'uid[=:\-](\d+)').firstMatch(authorHref);

        // 尝试提取回复数
        int replies = 0;
        int views = 0;
        final numText =
            item.querySelector('.num, .nums, td:last-child')?.text ?? '';
        final numMatch = RegExp(r'(\d+)').allMatches(numText).toList();
        if (numMatch.isNotEmpty) {
          replies = int.tryParse(numMatch[0].group(1)!) ?? 0;
        }
        if (numMatch.length > 1) {
          views = int.tryParse(numMatch[1].group(1)!) ?? 0;
        }

        topics.add(
          Topic(
            tid: int.parse(tidMatch.group(1)!),
            fid: 0,
            title: title,
            author: author,
            authorId: uidMatch != null ? int.parse(uidMatch.group(1)!) : 0,
            replies: replies,
            views: views,
          ),
        );
      }
    }

    // 策略3: 通用降级匹配 - 任何包含 viewthread 链接的容器
    if (topics.isEmpty) {
      final allLinks = doc.querySelectorAll('a[href*="viewthread"]');
      final seenTids = <int>{};
      for (final link in allLinks) {
        final title = link.text.trim();
        final href = link.attributes['href'] ?? '';
        final tidMatch = RegExp(r'tid=(\d+)').firstMatch(href);
        if (tidMatch == null || title.isEmpty) continue;

        final tid = int.parse(tidMatch.group(1)!);
        if (seenTids.contains(tid)) continue;
        seenTids.add(tid);

        // 向上查找最近的容器来获取作者信息
        final container = link.parent?.parent;
        final authorEl = container?.querySelector('a[href*="space"]');
        final author = authorEl?.text.trim() ?? '未知';
        final authorHref = authorEl?.attributes['href'] ?? '';
        final uidMatch = RegExp(r'uid[=:\-](\d+)').firstMatch(authorHref);

        topics.add(
          Topic(
            tid: tid,
            fid: 0,
            title: title,
            author: author,
            authorId: uidMatch != null ? int.parse(uidMatch.group(1)!) : 0,
            replies: 0,
            views: 0,
          ),
        );
      }
    }
    return topics;
  }

  // =========================================================================
  // 帖子详情
  // =========================================================================

  Future<TopicDetail> getTopicDetail(int tid, {int page = 1}) async {
    final (ok, body) = await _api.get('${Urls.getPostUrl(tid)}&page=$page');
    if (!ok) {
      return TopicDetail(
        tid: tid,
        fid: 0,
        title: '加载失败',
        author: '',
        authorId: 0,
        time: '',
      );
    }

    final doc = html_parser.parse(body);
    final title = doc.querySelector('#thread_subject')?.text.trim() ?? '';

    final posts = <Post>[];
    // Discuz 桌面端：每层楼是 <table id="pidXXX" class="plhin">
    // 遍历 table 而非 .plc，避免 pid 提取失败和嵌套重复
    final postTables = doc.querySelectorAll(
      '#postlist table[id^="pid"], #postlist table.plhin',
    );

    int index = (page - 1) * 30 + 1;
    for (final table in postTables) {
      // 从 table 的 id 提取 pid（格式: pid12345）
      final tableId = table.attributes['id'] ?? '';
      final pidMatch = RegExp(r'pid(\d+)').firstMatch(tableId);

      // 作者信息在 <td class="pls"> 侧栏中
      // Discuz 桌面端用户链接格式多样：
      //   - space-uid-XXX.html
      //   - home.php?mod=space&uid=XXX
      //   - space-username-XXX.html
      final pls = table.querySelector('td.pls');
      var authorEl = pls?.querySelector(
        'a[href*="space-uid"], a[href*="mod=space&uid"], a[href*="space&uid="]',
      );
      // 降级：pls 中任何包含 "space" 的链接
      authorEl ??= pls?.querySelector('a[href*="space"]');
      // 降级：pls 中带 target="_blank" 的第一个链接（通常是作者名）
      authorEl ??= pls?.querySelector('a[target="_blank"]');
      // 再降级：整个 table 中的空间链接（排除 .plc 内容区的链接）
      if (authorEl == null) {
        for (final a in table.querySelectorAll('a[href*="space"]')) {
          // 排除内容区的链接（手动遍历父元素检查）
          var parent = a.parent;
          var inContent = false;
          while (parent != null && parent != table) {
            final cls = parent.className;
            if (cls.contains('t_f') || cls.contains('postmessage')) {
              inContent = true;
              break;
            }
            parent = parent.parent;
          }
          if (!inContent &&
              !(a.attributes['href'] ?? '').contains('attachment')) {
            authorEl = a;
            break;
          }
        }
      }
      final author = authorEl?.text.trim() ?? '未知';
      final authorHref = authorEl?.attributes['href'] ?? '';
      final uidMatch = RegExp(r'uid[=:\-](\d+)').firstMatch(authorHref);

      // 头像：pls 区域中的 <img>（Discuz 桌面端头像通常在 .avatar 或 <a> 内的 <img>）
      String? avatar;
      final avatarImg = pls?.querySelector('.avatar img, img.avatar');
      avatar = avatarImg?.attributes['src'];
      // 降级：pls 中第一个带 src 且 src 包含 avatar/uc_server 的 img
      if (avatar == null) {
        for (final img in pls?.querySelectorAll('img') ?? []) {
          final src = img.attributes['src'] ?? '';
          if (src.contains('avatar') ||
              src.contains('uc_server') ||
              src.contains('ucenter')) {
            avatar = src;
            break;
          }
        }
      }
      // 确保头像 URL 是完整的
      if (avatar != null && !avatar.startsWith('http')) {
        avatar = '${Urls.baseUrl}$avatar';
      }

      // 帖子内容在 <td class="plc"> 中
      final plc = table.querySelector('td.plc');
      final contentEl = plc?.querySelector('.t_f, .postmessage');
      final content = contentEl?.innerHtml ?? '';

      // 时间在 plc 区域的 .authi em 中
      final timeEl = plc?.querySelector('.authi em, .postinfo em');

      final images = <ImageAttachment>[];
      for (final img in contentEl?.querySelectorAll('img[file]') ?? []) {
        final file = img.attributes['file'] ?? img.attributes['src'] ?? '';
        if (file.isNotEmpty && !file.contains('smiley')) {
          images.add(
            ImageAttachment(
              aid: images.length,
              url: file.startsWith('http') ? file : '${Urls.baseUrl}$file',
              filename: file.split('/').last,
            ),
          );
        }
      }

      posts.add(
        Post(
          pid: pidMatch != null ? int.parse(pidMatch.group(1)!) : 0,
          tid: tid,
          authorId: uidMatch != null ? int.parse(uidMatch.group(1)!) : 0,
          author: author,
          avatar: avatar,
          time: timeEl?.text.trim() ?? '',
          content: content,
          images: images,
          index: index++,
        ),
      );
    }

    int maxPage = page;
    for (final link in doc.querySelectorAll('.pg a[href*="page="]')) {
      final m = RegExp(r'page=(\d+)').firstMatch(link.attributes['href'] ?? '');
      if (m != null) {
        final p = int.parse(m.group(1)!);
        if (p > maxPage) maxPage = p;
      }
    }

    return TopicDetail(
      tid: tid,
      fid: 0,
      title: title,
      author: posts.isNotEmpty ? posts.first.author : '',
      authorId: posts.isNotEmpty ? posts.first.authorId : 0,
      time: posts.isNotEmpty ? posts.first.time : '',
      posts: posts,
      currentPage: page,
      totalPages: maxPage,
    );
  }

  // =========================================================================
  // 收藏
  // =========================================================================

  Future<bool> addFavorite(int tid) async {
    final (ok, body) = await _api.post(
      Urls.addStarUrl(tid),
      params: {'addsubmit': 'true'},
    );
    return ok && !body.contains('error');
  }

  // =========================================================================
  // 回复
  // =========================================================================

  Future<bool> replyTopic(int tid, String content) async {
    // 1. 先访问回复页面获取最新的 formhash 和正确的 fid
    final replyPageUrl =
        '${Urls.baseUrl}forum.php?mod=post&action=reply&tid=$tid';
    final (pageOk, pageBody) = await _api.get(replyPageUrl);
    if (!pageOk) {
      _api.talker.error('获取回复页面失败');
      return false;
    }

    // 从回复页面提取 formhash
    final replyDoc = html_parser.parse(pageBody);
    final freshFormhash = replyDoc
        .querySelector('input[name="formhash"]')
        ?.attributes['value'];
    if (freshFormhash != null) {
      _api.formhash = freshFormhash;
      _api.talker.info('回复页面 formhash 已更新: $freshFormhash');
    }

    // 从回复页面 URL 提取 fid（Discuz 回复页面通常包含 fid 参数）
    final fidMatch = RegExp(r'fid=(\d+)').firstMatch(pageBody);
    final fid = fidMatch?.group(1) ?? '2';

    // 2. 提交回复
    final (ok, body) = await _api.post(
      '${Urls.baseUrl}forum.php?mod=post&action=reply&fid=$fid&tid=$tid&extra=&replysubmit=yes&inajax=1&handlekey=fastpost',
      params: {'message': content, 'usesig': '1'},
    );
    return ok && !body.contains('error');
  }

  // =========================================================================
  // 签到
  // =========================================================================

  Future<SignResult> sign() async {
    final (pageOk, pageBody) = await _api.get(Urls.signUrl);
    if (!pageOk) return SignResult(message: '签到请求失败');

    if (pageBody.contains('已签到') || pageBody.contains('您今日已经签到')) {
      return SignResult(alreadySigned: true, message: '今日已签到');
    }

    final (ok, body) = await _api.post(
      Urls.signPostUrl,
      params: {'qdxq': 'kx', 'qdmode': '1', 'todaysay': '', 'faession': '1'},
    );

    if (!ok) return SignResult(message: '签到请求失败');

    if (body.contains('签到成功')) {
      return SignResult(alreadySigned: false, message: '签到成功');
    } else if (body.contains('已签到')) {
      return SignResult(alreadySigned: true, message: '今日已签到');
    }
    return SignResult(message: '签到完成');
  }

  // =========================================================================
  // 消息通知
  // =========================================================================

  Future<List<ReplyNotification>> getReplyNotifications() async {
    final (ok, body) = await _api.get(Urls.messageReply);
    if (!ok) return [];
    return _parseNotifications<ReplyNotification>(body, (args) {
      return ReplyNotification(
        id: args['id'],
        tid: args['tid'],
        title: args['title'],
        author: '',
        time: '',
        snippet: args['snippet'],
        pid: args['pid'],
        isNew: args['isNew'],
      );
    });
  }

  Future<List<AtNotification>> getAtNotifications() async {
    final (ok, body) = await _api.get(Urls.messageAt);
    if (!ok) return [];
    return _parseNotifications<AtNotification>(body, (args) {
      return AtNotification(
        id: args['id'],
        tid: args['tid'],
        title: args['title'],
        author: '',
        time: '',
        snippet: args['snippet'],
        pid: args['pid'],
        isNew: args['isNew'],
      );
    });
  }

  List<T> _parseNotifications<T>(
    String html,
    T Function(Map<String, dynamic>) factory,
  ) {
    final doc = html_parser.parse(html);
    final items = <T>[];
    int id = 0;

    for (final li in doc.querySelectorAll('li')) {
      final link = li.querySelector('a');
      if (link == null) continue;

      final href = link.attributes['href'] ?? '';
      final tidMatch = RegExp(r'tid=(\d+)').firstMatch(href);
      final pidMatch = RegExp(r'pid=(\d+)').firstMatch(href);

      items.add(
        factory({
          'id': id++,
          'tid': tidMatch != null ? int.parse(tidMatch.group(1)!) : 0,
          'title': link.text.trim(),
          'snippet': li.text.trim(),
          'pid': pidMatch != null ? int.parse(pidMatch.group(1)!) : 0,
          'isNew':
              li.classes.contains('new') || li.querySelector('.new') != null,
        }),
      );
    }
    return items;
  }

  // =========================================================================
  // 搜索
  // =========================================================================

  Future<List<Topic>> search(String keyword) async {
    final (ok, body) = await _api.post(
      Urls.searchUrl,
      params: {'srchtxt': keyword, 'searchsubmit': 'yes'},
    );
    if (!ok) return [];

    if (body.contains('searchid')) {
      final m = RegExp(r'searchid=(\d+)').firstMatch(body);
      if (m != null) {
        final (rOk, rBody) = await _api.get(Urls.getSearchUrl2(m.group(1)!));
        if (!rOk) return [];
        return _parseTopicList(rBody);
      }
    }
    return _parseTopicList(body);
  }
}
