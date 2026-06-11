// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get commonRefresh => '刷新';

  @override
  String get commonConfirm => '确定';

  @override
  String get commonCancel => '取消';

  @override
  String get commonRetry => '重试';

  @override
  String get commonNoTopics => '暂无帖子';

  @override
  String get commonNoContent => '暂无内容';

  @override
  String get commonReply => '回复';

  @override
  String get commonFavorite => '收藏';

  @override
  String get commonNotImplemented => '未实现';

  @override
  String get commonLogin => '登录';

  @override
  String get commonLogout => '退出登录';

  @override
  String get commonLoggedOut => '已退出登录';

  @override
  String get commonSubmit => '提交';

  @override
  String get aboutTitle => '关于';

  @override
  String get aboutAppName => '睿思';

  @override
  String get aboutSubtitle => '西安电子科技大学校园论坛客户端';

  @override
  String get aboutVersion => '版本';

  @override
  String get aboutVersionNumber => '2.0.0 (随 XDYou 1.6.0 分发)';

  @override
  String get aboutSourceCode => '源代码';

  @override
  String get aboutBugReport => '问题反馈';

  @override
  String get aboutBugReportSubtitle => '在 GitHub 上提交 issue';

  @override
  String get aboutPrivacyPolicy => '隐私政策';

  @override
  String get aboutLicense =>
      '本应用基于 BSD-3-Clause 许可证开源\n基于 Ruisi-iOS 和 Ruisi-Android 在 AI 辅助下重写';

  @override
  String get aboutPrivacyPolicyContent =>
      '本应用仅在西安电子科技大学校园网内运行，访问睿思论坛 (rs.xidian.edu.cn) 的数据。\n\n本应用不会收集、存储或传输任何用户的个人信息到第三方服务器。\n\n用户的登录凭据仅保存在本地设备中，用于与睿思论坛服务器进行身份验证。\n\n本应用使用 Cookie 与睿思论坛服务器进行通信，所有数据交互均直接在用户的设备与睿思论坛服务器之间进行。\n\n如有任何疑问，请通过 GitHub 提交 issue 联系开发者。';

  @override
  String get homeTitle => '睿思论坛';

  @override
  String get homeNewPost => '发帖';

  @override
  String get homeForumList => '论坛板块';

  @override
  String get homeTabHot => '热帖';

  @override
  String get homeTabNewReply => '最新回复';

  @override
  String get homeTabNewPost => '最新发表';

  @override
  String get homeTabMy => '我的';

  @override
  String get homeTabTrade => '二手交易';

  @override
  String get homeTabWater => '灌水';

  @override
  String get homeTabLostFound => '失物招领';

  @override
  String get homeTabEmployment => '就业';

  @override
  String get homeTabPhotography => '摄影';

  @override
  String get homePleaseLogin => '请先登录';

  @override
  String get homeMyProfile => '我的资料';

  @override
  String get homeMyPosts => '我的帖子';

  @override
  String get homeMyFavorites => '我的收藏';

  @override
  String get homeMessageCenter => '消息中心';

  @override
  String get homeDailyCheckin => '每日签到';

  @override
  String get homeSettings => '设置';

  @override
  String get homeAbout => '关于';

  @override
  String get homeSearch => '搜索帖子...';

  @override
  String get loginTitle => '登录睿思';

  @override
  String get loginUsername => '用户名';

  @override
  String get loginUsernameHint => '请输入用户名';

  @override
  String get loginPassword => '密码';

  @override
  String get loginPasswordHint => '请输入密码';

  @override
  String get loginCaptcha => '验证码';

  @override
  String get loginCaptchaHint => '请输入验证码';

  @override
  String get loginBack => '返回';

  @override
  String get loginResetLoginState => '重置登录状态';

  @override
  String get loginResetConfirmTitle => '确认重置';

  @override
  String get loginResetConfirmContent => '确定要重置登录状态吗？这将清除所有登录信息。';

  @override
  String get loginResetSuccess => '登录状态已重置';

  @override
  String get loginViewLogs => '查看日志';

  @override
  String get postTitle => '发帖';

  @override
  String get postPublish => '发布';

  @override
  String get postSelectForum => '选择板块';

  @override
  String get postSelectForumHint => '请选择板块';

  @override
  String get postSubject => '标题';

  @override
  String get postSubjectHint => '请输入标题';

  @override
  String get postContent => '内容';

  @override
  String get postContentHint => '请输入内容';

  @override
  String get postSuccess => '发帖成功';

  @override
  String get postFailure => '发帖失败';

  @override
  String get postSmiley => '表情';

  @override
  String get topicDetailTitle => '帖子详情';

  @override
  String get topicDetailReplyTooShort => '回复内容不能少于 13 个字符';

  @override
  String get topicDetailReplySuccess => '回复成功';

  @override
  String get topicDetailReplyFailure => '回复失败';

  @override
  String get topicDetailFavoriteSuccess => '收藏成功';

  @override
  String get topicDetailFavoriteFailure => '收藏失败';

  @override
  String get topicDetailNoData => '无数据';

  @override
  String get topicDetailReplyHint => '写回复...';

  @override
  String get topicDetailVoteSingleSelect => '单选';

  @override
  String topicDetailVoteMultiSelect(int count) {
    return '多选，最多 $count 项';
  }

  @override
  String get topicDetailVoteTitlePrefix => '投票';

  @override
  String topicDetailVoteCount(int count) {
    return '共 $count 人参与';
  }

  @override
  String get topicDetailVoteOpen => '点此投票';

  @override
  String get topicDetailVoteSheetTitle => '投票';

  @override
  String topicDetailVoteMaxSelection(int count) {
    return '最多只能选择 $count 项';
  }

  @override
  String get topicDetailVoteNotSelected => '你还没有选择';

  @override
  String get topicDetailVoteSuccess => '投票成功';

  @override
  String get topicDetailVoteFailure => '投票失败';

  @override
  String get topicDetailVoteParamError => '投票失败：参数错误';

  @override
  String get topicDetailVoteAlreadyVoted => '您已经投过票，谢谢您的参与';

  @override
  String get topicDetailVoteExpired => '该投票已过期或关闭';

  @override
  String get topicDetailVoteEnded => '投票已经结束';

  @override
  String get topicListItemSticky => '置顶';

  @override
  String get forumListTitle => '论坛板块';

  @override
  String get forumListEmpty => '暂无板块';

  @override
  String get favoritesTitle => '我的收藏';

  @override
  String get favoritesEmpty => '暂无收藏';

  @override
  String get messagesTitle => '消息';

  @override
  String get messagesTabAt => '@我';

  @override
  String get messagesNoReply => '暂无回复通知';

  @override
  String get messagesNoAt => '暂无@通知';

  @override
  String get searchHint => '搜索帖子...';

  @override
  String get searchInputHint => '输入关键词搜索';

  @override
  String get searchNoResults => '无搜索结果';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsSectionProxy => '代理';

  @override
  String get settingsProxyEnable => '启用代理';

  @override
  String get settingsProxyDisabled => '未启用';

  @override
  String get settingsProxyAddress => '代理地址';

  @override
  String get settingsSectionDebug => '调试';

  @override
  String get settingsViewLogs => '查看日志';

  @override
  String get settingsProxyDialogTitle => '代理设置';

  @override
  String get settingsProxyHost => '主机地址';

  @override
  String get settingsProxyHostHint => '例如 127.0.0.1';

  @override
  String get settingsProxyPort => '端口';

  @override
  String get settingsProxyPortHint => '例如 7890';

  @override
  String get userTitle => '我的';

  @override
  String get userTabProfile => '资料';

  @override
  String get userUnknown => '未知用户';

  @override
  String get captchaUnavailable => '验证码不可用';

  @override
  String get captchaLoadFailed => '验证码加载失败';

  @override
  String get loginFailed => '登录失败';

  @override
  String get imageFormatNotSupported => '仅支持 jpg/jpeg/png/gif/bmp/webp 图片';

  @override
  String get imageReadFailed => '读取图片失败';

  @override
  String get imageUploadFailed => '图片上传失败';

  @override
  String get uploadImage => '上传图片';

  @override
  String get currentForumNoUploadSupport => '当前板块暂不支持上传图片';

  @override
  String get checkInComplete => '签到完成';

  @override
  String get loadFailed => '加载失败';

  @override
  String get tapToRetry => '点击重试';

  @override
  String get newPostMetaLoadFailed => '加载发帖信息失败';

  @override
  String get postSubjectCategory => '主题分类';

  @override
  String topicDetailReplyToPost(int index, String author) {
    return '回复 #$index $author\n';
  }

  @override
  String get postForumLoading => '正在加载板块...';

  @override
  String get postForumLoadFailed => '加载失败，请返回重试';
}

/// The translations for Chinese, using the Han script (`zh_Hans`).
class AppLocalizationsZhHans extends AppLocalizationsZh {
  AppLocalizationsZhHans() : super('zh_Hans');

  @override
  String get commonRefresh => '刷新';

  @override
  String get commonConfirm => '确定';

  @override
  String get commonCancel => '取消';

  @override
  String get commonRetry => '重试';

  @override
  String get commonNoTopics => '暂无帖子';

  @override
  String get commonNoContent => '暂无内容';

  @override
  String get commonReply => '回复';

  @override
  String get commonFavorite => '收藏';

  @override
  String get commonNotImplemented => '未实现';

  @override
  String get commonLogin => '登录';

  @override
  String get commonLogout => '退出登录';

  @override
  String get commonLoggedOut => '已退出登录';

  @override
  String get commonSubmit => '提交';

  @override
  String get aboutTitle => '关于';

  @override
  String get aboutAppName => '睿思';

  @override
  String get aboutSubtitle => '西安电子科技大学校园论坛客户端';

  @override
  String get aboutVersion => '版本';

  @override
  String get aboutVersionNumber => '2.0.0 (随 XDYou 1.6.0 分发)';

  @override
  String get aboutSourceCode => '源代码';

  @override
  String get aboutBugReport => '问题反馈';

  @override
  String get aboutBugReportSubtitle => '在 GitHub 上提交 issue';

  @override
  String get aboutPrivacyPolicy => '隐私政策';

  @override
  String get aboutLicense =>
      '本应用基于 BSD-3-Clause 许可证开源\n基于 Ruisi-iOS 和 Ruisi-Android 在 AI 辅助下重写';

  @override
  String get aboutPrivacyPolicyContent =>
      '本应用仅在西安电子科技大学校园网内运行，访问睿思论坛 (rs.xidian.edu.cn) 的数据。\n\n本应用不会收集、存储或传输任何用户的个人信息到第三方服务器。\n\n用户的登录凭据仅保存在本地设备中，用于与睿思论坛服务器进行身份验证。\n\n本应用使用 Cookie 与睿思论坛服务器进行通信，所有数据交互均直接在用户的设备与睿思论坛服务器之间进行。\n\n如有任何疑问，请通过 GitHub 提交 issue 联系开发者。';

  @override
  String get homeTitle => '睿思论坛';

  @override
  String get homeNewPost => '发帖';

  @override
  String get homeForumList => '论坛板块';

  @override
  String get homeTabHot => '热帖';

  @override
  String get homeTabNewReply => '最新回复';

  @override
  String get homeTabNewPost => '最新发表';

  @override
  String get homeTabMy => '我的';

  @override
  String get homeTabTrade => '二手交易';

  @override
  String get homeTabWater => '灌水';

  @override
  String get homeTabLostFound => '失物招领';

  @override
  String get homeTabEmployment => '就业';

  @override
  String get homeTabPhotography => '摄影';

  @override
  String get homePleaseLogin => '请先登录';

  @override
  String get homeMyProfile => '我的资料';

  @override
  String get homeMyPosts => '我的帖子';

  @override
  String get homeMyFavorites => '我的收藏';

  @override
  String get homeMessageCenter => '消息中心';

  @override
  String get homeDailyCheckin => '每日签到';

  @override
  String get homeSettings => '设置';

  @override
  String get homeAbout => '关于';

  @override
  String get homeSearch => '搜索帖子...';

  @override
  String get loginTitle => '登录睿思';

  @override
  String get loginUsername => '用户名';

  @override
  String get loginUsernameHint => '请输入用户名';

  @override
  String get loginPassword => '密码';

  @override
  String get loginPasswordHint => '请输入密码';

  @override
  String get loginCaptcha => '验证码';

  @override
  String get loginCaptchaHint => '请输入验证码';

  @override
  String get loginBack => '返回';

  @override
  String get loginResetLoginState => '重置登录状态';

  @override
  String get loginResetConfirmTitle => '确认重置';

  @override
  String get loginResetConfirmContent => '确定要重置登录状态吗？这将清除所有登录信息。';

  @override
  String get loginResetSuccess => '登录状态已重置';

  @override
  String get loginViewLogs => '查看日志';

  @override
  String get postTitle => '发帖';

  @override
  String get postPublish => '发布';

  @override
  String get postSelectForum => '选择板块';

  @override
  String get postSelectForumHint => '请选择板块';

  @override
  String get postSubject => '标题';

  @override
  String get postSubjectHint => '请输入标题';

  @override
  String get postContent => '内容';

  @override
  String get postContentHint => '请输入内容';

  @override
  String get postSuccess => '发帖成功';

  @override
  String get postFailure => '发帖失败';

  @override
  String get postSmiley => '表情';

  @override
  String get topicDetailTitle => '帖子详情';

  @override
  String get topicDetailReplyTooShort => '回复内容不能少于 13 个字符';

  @override
  String get topicDetailReplySuccess => '回复成功';

  @override
  String get topicDetailReplyFailure => '回复失败';

  @override
  String get topicDetailFavoriteSuccess => '收藏成功';

  @override
  String get topicDetailFavoriteFailure => '收藏失败';

  @override
  String get topicDetailNoData => '无数据';

  @override
  String get topicDetailReplyHint => '写回复...';

  @override
  String get topicDetailVoteSingleSelect => '单选';

  @override
  String topicDetailVoteMultiSelect(int count) {
    return '多选，最多 $count 项';
  }

  @override
  String get topicDetailVoteTitlePrefix => '投票';

  @override
  String topicDetailVoteCount(int count) {
    return '共 $count 人参与';
  }

  @override
  String get topicDetailVoteOpen => '点此投票';

  @override
  String get topicDetailVoteSheetTitle => '投票';

  @override
  String topicDetailVoteMaxSelection(int count) {
    return '最多只能选择 $count 项';
  }

  @override
  String get topicDetailVoteNotSelected => '你还没有选择';

  @override
  String get topicDetailVoteSuccess => '投票成功';

  @override
  String get topicDetailVoteFailure => '投票失败';

  @override
  String get topicDetailVoteParamError => '投票失败：参数错误';

  @override
  String get topicDetailVoteAlreadyVoted => '您已经投过票，谢谢您的参与';

  @override
  String get topicDetailVoteExpired => '该投票已过期或关闭';

  @override
  String get topicDetailVoteEnded => '投票已经结束';

  @override
  String get topicListItemSticky => '置顶';

  @override
  String get forumListTitle => '论坛板块';

  @override
  String get forumListEmpty => '暂无板块';

  @override
  String get favoritesTitle => '我的收藏';

  @override
  String get favoritesEmpty => '暂无收藏';

  @override
  String get messagesTitle => '消息';

  @override
  String get messagesTabAt => '@我';

  @override
  String get messagesNoReply => '暂无回复通知';

  @override
  String get messagesNoAt => '暂无@通知';

  @override
  String get searchHint => '搜索帖子...';

  @override
  String get searchInputHint => '输入关键词搜索';

  @override
  String get searchNoResults => '无搜索结果';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsSectionProxy => '代理';

  @override
  String get settingsProxyEnable => '启用代理';

  @override
  String get settingsProxyDisabled => '未启用';

  @override
  String get settingsProxyAddress => '代理地址';

  @override
  String get settingsSectionDebug => '调试';

  @override
  String get settingsViewLogs => '查看日志';

  @override
  String get settingsProxyDialogTitle => '代理设置';

  @override
  String get settingsProxyHost => '主机地址';

  @override
  String get settingsProxyHostHint => '例如 127.0.0.1';

  @override
  String get settingsProxyPort => '端口';

  @override
  String get settingsProxyPortHint => '例如 7890';

  @override
  String get userTitle => '我的';

  @override
  String get userTabProfile => '资料';

  @override
  String get userUnknown => '未知用户';

  @override
  String get captchaUnavailable => '验证码不可用';

  @override
  String get captchaLoadFailed => '验证码加载失败';

  @override
  String get loginFailed => '登录失败';

  @override
  String get imageFormatNotSupported => '仅支持 jpg/jpeg/png/gif/bmp/webp 图片';

  @override
  String get imageReadFailed => '读取图片失败';

  @override
  String get imageUploadFailed => '图片上传失败';

  @override
  String get uploadImage => '上传图片';

  @override
  String get currentForumNoUploadSupport => '当前板块暂不支持上传图片';

  @override
  String get checkInComplete => '签到完成';

  @override
  String get loadFailed => '加载失败';

  @override
  String get tapToRetry => '点击重试';

  @override
  String get newPostMetaLoadFailed => '加载发帖信息失败';

  @override
  String get postSubjectCategory => '主题分类';

  @override
  String topicDetailReplyToPost(int index, String author) {
    return '回复 #$index $author\n';
  }

  @override
  String get postForumLoading => '正在加载板块...';

  @override
  String get postForumLoadFailed => '加载失败，请返回重试';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get commonRefresh => '重新整理';

  @override
  String get commonConfirm => '確定';

  @override
  String get commonCancel => '取消';

  @override
  String get commonRetry => '重試';

  @override
  String get commonNoTopics => '暫無帖子';

  @override
  String get commonNoContent => '暫無內容';

  @override
  String get commonReply => '回覆';

  @override
  String get commonFavorite => '收藏';

  @override
  String get commonNotImplemented => '未實現';

  @override
  String get commonLogin => '登入';

  @override
  String get commonLogout => '登出';

  @override
  String get commonLoggedOut => '已登出';

  @override
  String get commonSubmit => '提交';

  @override
  String get aboutTitle => '關於';

  @override
  String get aboutAppName => '睿思';

  @override
  String get aboutSubtitle => '西安電子科技大學校園論壇客戶端';

  @override
  String get aboutVersion => '版本';

  @override
  String get aboutVersionNumber => '2.0.0 (隨 XDYou 1.6.0 分發)';

  @override
  String get aboutSourceCode => '原始碼';

  @override
  String get aboutBugReport => '問題回報';

  @override
  String get aboutBugReportSubtitle => '在 GitHub 上提交 issue';

  @override
  String get aboutPrivacyPolicy => '隱私政策';

  @override
  String get aboutLicense =>
      '本應用基於 BSD-3-Clause 授權條款開源\n基於 Ruisi-iOS 和 Ruisi-Android 在 AI 輔助下重寫';

  @override
  String get aboutPrivacyPolicyContent =>
      '本應用僅在西安電子科技大學校園網內運行，訪問睿思論壇 (rs.xidian.edu.cn) 的資料。\n\n本應用不會收集、儲存或傳輸任何使用者的個人資訊到第三方伺服器。\n\n使用者的登入憑證僅儲存在本機裝置中，用於與睿思論壇伺服器進行身份驗證。\n\n本應用使用 Cookie 與睿思論壇伺服器進行通訊，所有資料互動均直接在使用者的裝置與睿思論壇伺服器之間進行。\n\n如有任何疑問，請透過 GitHub 提交 issue 聯繫開發者。';

  @override
  String get homeTitle => '睿思論壇';

  @override
  String get homeNewPost => '發帖';

  @override
  String get homeForumList => '論壇版塊';

  @override
  String get homeTabHot => '熱帖';

  @override
  String get homeTabNewReply => '最新回覆';

  @override
  String get homeTabNewPost => '最新發表';

  @override
  String get homeTabMy => '我的';

  @override
  String get homeTabTrade => '二手交易';

  @override
  String get homeTabWater => '灌水';

  @override
  String get homeTabLostFound => '失物招領';

  @override
  String get homeTabEmployment => '就業';

  @override
  String get homeTabPhotography => '攝影';

  @override
  String get homePleaseLogin => '請先登入';

  @override
  String get homeMyProfile => '我的資料';

  @override
  String get homeMyPosts => '我的帖子';

  @override
  String get homeMyFavorites => '我的收藏';

  @override
  String get homeMessageCenter => '訊息中心';

  @override
  String get homeDailyCheckin => '每日簽到';

  @override
  String get homeSettings => '設定';

  @override
  String get homeAbout => '關於';

  @override
  String get homeSearch => '搜尋帖子...';

  @override
  String get loginTitle => '登入睿思';

  @override
  String get loginUsername => '使用者名稱';

  @override
  String get loginUsernameHint => '請輸入使用者名稱';

  @override
  String get loginPassword => '密碼';

  @override
  String get loginPasswordHint => '請輸入密碼';

  @override
  String get loginCaptcha => '驗證碼';

  @override
  String get loginCaptchaHint => '請輸入驗證碼';

  @override
  String get loginBack => '返回';

  @override
  String get loginResetLoginState => '重設登入狀態';

  @override
  String get loginResetConfirmTitle => '確認重設';

  @override
  String get loginResetConfirmContent => '確定要重設登入狀態嗎？這將清除所有登入資訊。';

  @override
  String get loginResetSuccess => '登入狀態已重設';

  @override
  String get loginViewLogs => '檢視日誌';

  @override
  String get postTitle => '發帖';

  @override
  String get postPublish => '發布';

  @override
  String get postSelectForum => '選擇版塊';

  @override
  String get postSelectForumHint => '請選擇版塊';

  @override
  String get postSubject => '標題';

  @override
  String get postSubjectHint => '請輸入標題';

  @override
  String get postContent => '內容';

  @override
  String get postContentHint => '請輸入內容';

  @override
  String get postSuccess => '發帖成功';

  @override
  String get postFailure => '發帖失敗';

  @override
  String get postSmiley => '表情';

  @override
  String get topicDetailTitle => '帖子詳情';

  @override
  String get topicDetailReplyTooShort => '回覆內容不能少於 13 個字元';

  @override
  String get topicDetailReplySuccess => '回覆成功';

  @override
  String get topicDetailReplyFailure => '回覆失敗';

  @override
  String get topicDetailFavoriteSuccess => '收藏成功';

  @override
  String get topicDetailFavoriteFailure => '收藏失敗';

  @override
  String get topicDetailNoData => '無資料';

  @override
  String get topicDetailReplyHint => '寫回覆...';

  @override
  String get topicDetailVoteSingleSelect => '單選';

  @override
  String topicDetailVoteMultiSelect(int count) {
    return '多選，最多 $count 項';
  }

  @override
  String get topicDetailVoteTitlePrefix => '投票';

  @override
  String topicDetailVoteCount(int count) {
    return '共 $count 人參與';
  }

  @override
  String get topicDetailVoteOpen => '點此投票';

  @override
  String get topicDetailVoteSheetTitle => '投票';

  @override
  String topicDetailVoteMaxSelection(int count) {
    return '最多只能選擇 $count 項';
  }

  @override
  String get topicDetailVoteNotSelected => '你還沒有選擇';

  @override
  String get topicDetailVoteSuccess => '投票成功';

  @override
  String get topicDetailVoteFailure => '投票失敗';

  @override
  String get topicDetailVoteParamError => '投票失敗：參數錯誤';

  @override
  String get topicDetailVoteAlreadyVoted => '您已經投過票，謝謝您的參與';

  @override
  String get topicDetailVoteExpired => '該投票已過期或關閉';

  @override
  String get topicDetailVoteEnded => '投票已經結束';

  @override
  String get topicListItemSticky => '置頂';

  @override
  String get forumListTitle => '論壇版塊';

  @override
  String get forumListEmpty => '暫無版塊';

  @override
  String get favoritesTitle => '我的收藏';

  @override
  String get favoritesEmpty => '暫無收藏';

  @override
  String get messagesTitle => '訊息';

  @override
  String get messagesTabAt => '@我';

  @override
  String get messagesNoReply => '暫無回覆通知';

  @override
  String get messagesNoAt => '暫無@通知';

  @override
  String get searchHint => '搜尋帖子...';

  @override
  String get searchInputHint => '輸入關鍵詞搜尋';

  @override
  String get searchNoResults => '無搜尋結果';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsSectionProxy => '代理';

  @override
  String get settingsProxyEnable => '啟用代理';

  @override
  String get settingsProxyDisabled => '未啟用';

  @override
  String get settingsProxyAddress => '代理位址';

  @override
  String get settingsSectionDebug => '偵錯';

  @override
  String get settingsViewLogs => '檢視日誌';

  @override
  String get settingsProxyDialogTitle => '代理設定';

  @override
  String get settingsProxyHost => '主機位址';

  @override
  String get settingsProxyHostHint => '例如 127.0.0.1';

  @override
  String get settingsProxyPort => '連接埠';

  @override
  String get settingsProxyPortHint => '例如 7890';

  @override
  String get userTitle => '我的';

  @override
  String get userTabProfile => '資料';

  @override
  String get userUnknown => '未知使用者';

  @override
  String get captchaUnavailable => '驗證碼不可用';

  @override
  String get captchaLoadFailed => '驗證碼載入失敗';

  @override
  String get loginFailed => '登入失敗';

  @override
  String get imageFormatNotSupported => '僅支援 jpg/jpeg/png/gif/bmp/webp 圖片';

  @override
  String get imageReadFailed => '讀取圖片失敗';

  @override
  String get imageUploadFailed => '圖片上傳失敗';

  @override
  String get uploadImage => '上傳圖片';

  @override
  String get currentForumNoUploadSupport => '當前版塊暫不支援上傳圖片';

  @override
  String get checkInComplete => '簽到完成';

  @override
  String get loadFailed => '載入失敗';

  @override
  String get tapToRetry => '點擊重試';

  @override
  String get newPostMetaLoadFailed => '載入發帖資訊失敗';

  @override
  String get postSubjectCategory => '主題分類';

  @override
  String topicDetailReplyToPost(int index, String author) {
    return '回覆 #$index $author\n';
  }

  @override
  String get postForumLoading => '正在載入版塊...';

  @override
  String get postForumLoadFailed => '載入失敗，請返回重試';
}
