import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
    Locale('en'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  ];

  /// No description provided for @commonRefresh.
  ///
  /// In zh_Hans, this message translates to:
  /// **'刷新'**
  String get commonRefresh;

  /// No description provided for @commonConfirm.
  ///
  /// In zh_Hans, this message translates to:
  /// **'确定'**
  String get commonConfirm;

  /// No description provided for @commonCancel.
  ///
  /// In zh_Hans, this message translates to:
  /// **'取消'**
  String get commonCancel;

  /// No description provided for @commonRetry.
  ///
  /// In zh_Hans, this message translates to:
  /// **'重试'**
  String get commonRetry;

  /// No description provided for @commonNoTopics.
  ///
  /// In zh_Hans, this message translates to:
  /// **'暂无帖子'**
  String get commonNoTopics;

  /// No description provided for @commonNoContent.
  ///
  /// In zh_Hans, this message translates to:
  /// **'暂无内容'**
  String get commonNoContent;

  /// No description provided for @commonReply.
  ///
  /// In zh_Hans, this message translates to:
  /// **'回复'**
  String get commonReply;

  /// No description provided for @commonFavorite.
  ///
  /// In zh_Hans, this message translates to:
  /// **'收藏'**
  String get commonFavorite;

  /// No description provided for @commonNotImplemented.
  ///
  /// In zh_Hans, this message translates to:
  /// **'未实现'**
  String get commonNotImplemented;

  /// No description provided for @commonLogin.
  ///
  /// In zh_Hans, this message translates to:
  /// **'登录'**
  String get commonLogin;

  /// No description provided for @commonLogout.
  ///
  /// In zh_Hans, this message translates to:
  /// **'退出登录'**
  String get commonLogout;

  /// No description provided for @commonLoggedOut.
  ///
  /// In zh_Hans, this message translates to:
  /// **'已退出登录'**
  String get commonLoggedOut;

  /// No description provided for @commonSubmit.
  ///
  /// In zh_Hans, this message translates to:
  /// **'提交'**
  String get commonSubmit;

  /// No description provided for @aboutTitle.
  ///
  /// In zh_Hans, this message translates to:
  /// **'关于'**
  String get aboutTitle;

  /// No description provided for @aboutAppName.
  ///
  /// In zh_Hans, this message translates to:
  /// **'睿思'**
  String get aboutAppName;

  /// No description provided for @aboutSubtitle.
  ///
  /// In zh_Hans, this message translates to:
  /// **'西安电子科技大学校园论坛客户端'**
  String get aboutSubtitle;

  /// No description provided for @aboutVersion.
  ///
  /// In zh_Hans, this message translates to:
  /// **'版本'**
  String get aboutVersion;

  /// No description provided for @aboutVersionNumber.
  ///
  /// In zh_Hans, this message translates to:
  /// **'2.0.0 (随 XDYou 1.6.0 分发)'**
  String get aboutVersionNumber;

  /// No description provided for @aboutSourceCode.
  ///
  /// In zh_Hans, this message translates to:
  /// **'源代码'**
  String get aboutSourceCode;

  /// No description provided for @aboutBugReport.
  ///
  /// In zh_Hans, this message translates to:
  /// **'问题反馈'**
  String get aboutBugReport;

  /// No description provided for @aboutBugReportSubtitle.
  ///
  /// In zh_Hans, this message translates to:
  /// **'在 GitHub 上提交 issue'**
  String get aboutBugReportSubtitle;

  /// No description provided for @aboutPrivacyPolicy.
  ///
  /// In zh_Hans, this message translates to:
  /// **'隐私政策'**
  String get aboutPrivacyPolicy;

  /// No description provided for @aboutLicense.
  ///
  /// In zh_Hans, this message translates to:
  /// **'本应用基于 BSD-3-Clause 许可证开源\n基于 Ruisi-iOS 和 Ruisi-Android 在 AI 辅助下重写'**
  String get aboutLicense;

  /// No description provided for @aboutPrivacyPolicyContent.
  ///
  /// In zh_Hans, this message translates to:
  /// **'本应用仅在西安电子科技大学校园网内运行，访问睿思论坛 (rs.xidian.edu.cn) 的数据。\n\n本应用不会收集、存储或传输任何用户的个人信息到第三方服务器。\n\n用户的登录凭据仅保存在本地设备中，用于与睿思论坛服务器进行身份验证。\n\n本应用使用 Cookie 与睿思论坛服务器进行通信，所有数据交互均直接在用户的设备与睿思论坛服务器之间进行。\n\n如有任何疑问，请通过 GitHub 提交 issue 联系开发者。'**
  String get aboutPrivacyPolicyContent;

  /// No description provided for @homeTitle.
  ///
  /// In zh_Hans, this message translates to:
  /// **'睿思论坛'**
  String get homeTitle;

  /// No description provided for @homeNewPost.
  ///
  /// In zh_Hans, this message translates to:
  /// **'发帖'**
  String get homeNewPost;

  /// No description provided for @homeForumList.
  ///
  /// In zh_Hans, this message translates to:
  /// **'论坛板块'**
  String get homeForumList;

  /// No description provided for @homeTabHot.
  ///
  /// In zh_Hans, this message translates to:
  /// **'热帖'**
  String get homeTabHot;

  /// No description provided for @homeTabNewReply.
  ///
  /// In zh_Hans, this message translates to:
  /// **'最新回复'**
  String get homeTabNewReply;

  /// No description provided for @homeTabNewPost.
  ///
  /// In zh_Hans, this message translates to:
  /// **'最新发表'**
  String get homeTabNewPost;

  /// No description provided for @homeTabMy.
  ///
  /// In zh_Hans, this message translates to:
  /// **'我的'**
  String get homeTabMy;

  /// No description provided for @homeTabTrade.
  ///
  /// In zh_Hans, this message translates to:
  /// **'二手交易'**
  String get homeTabTrade;

  /// No description provided for @homeTabWater.
  ///
  /// In zh_Hans, this message translates to:
  /// **'灌水'**
  String get homeTabWater;

  /// No description provided for @homeTabLostFound.
  ///
  /// In zh_Hans, this message translates to:
  /// **'失物招领'**
  String get homeTabLostFound;

  /// No description provided for @homeTabEmployment.
  ///
  /// In zh_Hans, this message translates to:
  /// **'就业'**
  String get homeTabEmployment;

  /// No description provided for @homeTabPhotography.
  ///
  /// In zh_Hans, this message translates to:
  /// **'摄影'**
  String get homeTabPhotography;

  /// No description provided for @homePleaseLogin.
  ///
  /// In zh_Hans, this message translates to:
  /// **'请先登录'**
  String get homePleaseLogin;

  /// No description provided for @homeMyProfile.
  ///
  /// In zh_Hans, this message translates to:
  /// **'我的资料'**
  String get homeMyProfile;

  /// No description provided for @homeMyPosts.
  ///
  /// In zh_Hans, this message translates to:
  /// **'我的帖子'**
  String get homeMyPosts;

  /// No description provided for @homeMyFavorites.
  ///
  /// In zh_Hans, this message translates to:
  /// **'我的收藏'**
  String get homeMyFavorites;

  /// No description provided for @homeMessageCenter.
  ///
  /// In zh_Hans, this message translates to:
  /// **'消息中心'**
  String get homeMessageCenter;

  /// No description provided for @homeDailyCheckin.
  ///
  /// In zh_Hans, this message translates to:
  /// **'每日签到'**
  String get homeDailyCheckin;

  /// No description provided for @homeSettings.
  ///
  /// In zh_Hans, this message translates to:
  /// **'设置'**
  String get homeSettings;

  /// No description provided for @homeAbout.
  ///
  /// In zh_Hans, this message translates to:
  /// **'关于'**
  String get homeAbout;

  /// No description provided for @homeSearch.
  ///
  /// In zh_Hans, this message translates to:
  /// **'搜索帖子...'**
  String get homeSearch;

  /// No description provided for @loginTitle.
  ///
  /// In zh_Hans, this message translates to:
  /// **'登录睿思'**
  String get loginTitle;

  /// No description provided for @loginUsername.
  ///
  /// In zh_Hans, this message translates to:
  /// **'用户名'**
  String get loginUsername;

  /// No description provided for @loginUsernameHint.
  ///
  /// In zh_Hans, this message translates to:
  /// **'请输入用户名'**
  String get loginUsernameHint;

  /// No description provided for @loginPassword.
  ///
  /// In zh_Hans, this message translates to:
  /// **'密码'**
  String get loginPassword;

  /// No description provided for @loginPasswordHint.
  ///
  /// In zh_Hans, this message translates to:
  /// **'请输入密码'**
  String get loginPasswordHint;

  /// No description provided for @loginCaptcha.
  ///
  /// In zh_Hans, this message translates to:
  /// **'验证码'**
  String get loginCaptcha;

  /// No description provided for @loginCaptchaHint.
  ///
  /// In zh_Hans, this message translates to:
  /// **'请输入验证码'**
  String get loginCaptchaHint;

  /// No description provided for @loginBack.
  ///
  /// In zh_Hans, this message translates to:
  /// **'返回'**
  String get loginBack;

  /// No description provided for @loginResetLoginState.
  ///
  /// In zh_Hans, this message translates to:
  /// **'重置登录状态'**
  String get loginResetLoginState;

  /// No description provided for @loginResetConfirmTitle.
  ///
  /// In zh_Hans, this message translates to:
  /// **'确认重置'**
  String get loginResetConfirmTitle;

  /// No description provided for @loginResetConfirmContent.
  ///
  /// In zh_Hans, this message translates to:
  /// **'确定要重置登录状态吗？这将清除所有登录信息。'**
  String get loginResetConfirmContent;

  /// No description provided for @loginResetSuccess.
  ///
  /// In zh_Hans, this message translates to:
  /// **'登录状态已重置'**
  String get loginResetSuccess;

  /// No description provided for @loginViewLogs.
  ///
  /// In zh_Hans, this message translates to:
  /// **'查看日志'**
  String get loginViewLogs;

  /// No description provided for @postTitle.
  ///
  /// In zh_Hans, this message translates to:
  /// **'发帖'**
  String get postTitle;

  /// No description provided for @postPublish.
  ///
  /// In zh_Hans, this message translates to:
  /// **'发布'**
  String get postPublish;

  /// No description provided for @postSelectForum.
  ///
  /// In zh_Hans, this message translates to:
  /// **'选择板块'**
  String get postSelectForum;

  /// No description provided for @postSelectForumHint.
  ///
  /// In zh_Hans, this message translates to:
  /// **'请选择板块'**
  String get postSelectForumHint;

  /// No description provided for @postSubject.
  ///
  /// In zh_Hans, this message translates to:
  /// **'标题'**
  String get postSubject;

  /// No description provided for @postSubjectHint.
  ///
  /// In zh_Hans, this message translates to:
  /// **'请输入标题'**
  String get postSubjectHint;

  /// No description provided for @postContent.
  ///
  /// In zh_Hans, this message translates to:
  /// **'内容'**
  String get postContent;

  /// No description provided for @postContentHint.
  ///
  /// In zh_Hans, this message translates to:
  /// **'请输入内容'**
  String get postContentHint;

  /// No description provided for @postSuccess.
  ///
  /// In zh_Hans, this message translates to:
  /// **'发帖成功'**
  String get postSuccess;

  /// No description provided for @postFailure.
  ///
  /// In zh_Hans, this message translates to:
  /// **'发帖失败'**
  String get postFailure;

  /// No description provided for @postSmiley.
  ///
  /// In zh_Hans, this message translates to:
  /// **'表情'**
  String get postSmiley;

  /// No description provided for @topicDetailTitle.
  ///
  /// In zh_Hans, this message translates to:
  /// **'帖子详情'**
  String get topicDetailTitle;

  /// No description provided for @topicDetailReplyTooShort.
  ///
  /// In zh_Hans, this message translates to:
  /// **'回复内容不能少于 13 个字符'**
  String get topicDetailReplyTooShort;

  /// No description provided for @topicDetailReplySuccess.
  ///
  /// In zh_Hans, this message translates to:
  /// **'回复成功'**
  String get topicDetailReplySuccess;

  /// No description provided for @topicDetailReplyFailure.
  ///
  /// In zh_Hans, this message translates to:
  /// **'回复失败'**
  String get topicDetailReplyFailure;

  /// No description provided for @topicDetailFavoriteSuccess.
  ///
  /// In zh_Hans, this message translates to:
  /// **'收藏成功'**
  String get topicDetailFavoriteSuccess;

  /// No description provided for @topicDetailFavoriteFailure.
  ///
  /// In zh_Hans, this message translates to:
  /// **'收藏失败'**
  String get topicDetailFavoriteFailure;

  /// No description provided for @topicDetailNoData.
  ///
  /// In zh_Hans, this message translates to:
  /// **'无数据'**
  String get topicDetailNoData;

  /// No description provided for @topicDetailReplyHint.
  ///
  /// In zh_Hans, this message translates to:
  /// **'写回复...'**
  String get topicDetailReplyHint;

  /// No description provided for @topicDetailVoteSingleSelect.
  ///
  /// In zh_Hans, this message translates to:
  /// **'单选'**
  String get topicDetailVoteSingleSelect;

  /// No description provided for @topicDetailVoteMultiSelect.
  ///
  /// In zh_Hans, this message translates to:
  /// **'多选，最多 {count} 项'**
  String topicDetailVoteMultiSelect(int count);

  /// No description provided for @topicDetailVoteTitlePrefix.
  ///
  /// In zh_Hans, this message translates to:
  /// **'投票'**
  String get topicDetailVoteTitlePrefix;

  /// No description provided for @topicDetailVoteCount.
  ///
  /// In zh_Hans, this message translates to:
  /// **'共 {count} 人参与'**
  String topicDetailVoteCount(int count);

  /// No description provided for @topicDetailVoteOpen.
  ///
  /// In zh_Hans, this message translates to:
  /// **'点此投票'**
  String get topicDetailVoteOpen;

  /// No description provided for @topicDetailVoteSheetTitle.
  ///
  /// In zh_Hans, this message translates to:
  /// **'投票'**
  String get topicDetailVoteSheetTitle;

  /// No description provided for @topicDetailVoteMaxSelection.
  ///
  /// In zh_Hans, this message translates to:
  /// **'最多只能选择 {count} 项'**
  String topicDetailVoteMaxSelection(int count);

  /// No description provided for @topicDetailVoteNotSelected.
  ///
  /// In zh_Hans, this message translates to:
  /// **'你还没有选择'**
  String get topicDetailVoteNotSelected;

  /// No description provided for @topicDetailVoteSuccess.
  ///
  /// In zh_Hans, this message translates to:
  /// **'投票成功'**
  String get topicDetailVoteSuccess;

  /// No description provided for @topicDetailVoteFailure.
  ///
  /// In zh_Hans, this message translates to:
  /// **'投票失败'**
  String get topicDetailVoteFailure;

  /// No description provided for @topicDetailVoteParamError.
  ///
  /// In zh_Hans, this message translates to:
  /// **'投票失败：参数错误'**
  String get topicDetailVoteParamError;

  /// No description provided for @topicDetailVoteAlreadyVoted.
  ///
  /// In zh_Hans, this message translates to:
  /// **'您已经投过票，谢谢您的参与'**
  String get topicDetailVoteAlreadyVoted;

  /// No description provided for @topicDetailVoteExpired.
  ///
  /// In zh_Hans, this message translates to:
  /// **'该投票已过期或关闭'**
  String get topicDetailVoteExpired;

  /// No description provided for @topicDetailVoteEnded.
  ///
  /// In zh_Hans, this message translates to:
  /// **'投票已经结束'**
  String get topicDetailVoteEnded;

  /// No description provided for @topicListItemSticky.
  ///
  /// In zh_Hans, this message translates to:
  /// **'置顶'**
  String get topicListItemSticky;

  /// No description provided for @forumListTitle.
  ///
  /// In zh_Hans, this message translates to:
  /// **'论坛板块'**
  String get forumListTitle;

  /// No description provided for @forumListEmpty.
  ///
  /// In zh_Hans, this message translates to:
  /// **'暂无板块'**
  String get forumListEmpty;

  /// No description provided for @favoritesTitle.
  ///
  /// In zh_Hans, this message translates to:
  /// **'我的收藏'**
  String get favoritesTitle;

  /// No description provided for @favoritesEmpty.
  ///
  /// In zh_Hans, this message translates to:
  /// **'暂无收藏'**
  String get favoritesEmpty;

  /// No description provided for @messagesTitle.
  ///
  /// In zh_Hans, this message translates to:
  /// **'消息'**
  String get messagesTitle;

  /// No description provided for @messagesTabAt.
  ///
  /// In zh_Hans, this message translates to:
  /// **'@我'**
  String get messagesTabAt;

  /// No description provided for @messagesNoReply.
  ///
  /// In zh_Hans, this message translates to:
  /// **'暂无回复通知'**
  String get messagesNoReply;

  /// No description provided for @messagesNoAt.
  ///
  /// In zh_Hans, this message translates to:
  /// **'暂无@通知'**
  String get messagesNoAt;

  /// No description provided for @searchHint.
  ///
  /// In zh_Hans, this message translates to:
  /// **'搜索帖子...'**
  String get searchHint;

  /// No description provided for @searchInputHint.
  ///
  /// In zh_Hans, this message translates to:
  /// **'输入关键词搜索'**
  String get searchInputHint;

  /// No description provided for @searchNoResults.
  ///
  /// In zh_Hans, this message translates to:
  /// **'无搜索结果'**
  String get searchNoResults;

  /// No description provided for @settingsTitle.
  ///
  /// In zh_Hans, this message translates to:
  /// **'设置'**
  String get settingsTitle;

  /// No description provided for @settingsSectionProxy.
  ///
  /// In zh_Hans, this message translates to:
  /// **'代理'**
  String get settingsSectionProxy;

  /// No description provided for @settingsProxyEnable.
  ///
  /// In zh_Hans, this message translates to:
  /// **'启用代理'**
  String get settingsProxyEnable;

  /// No description provided for @settingsProxyDisabled.
  ///
  /// In zh_Hans, this message translates to:
  /// **'未启用'**
  String get settingsProxyDisabled;

  /// No description provided for @settingsProxyAddress.
  ///
  /// In zh_Hans, this message translates to:
  /// **'代理地址'**
  String get settingsProxyAddress;

  /// No description provided for @settingsSectionDebug.
  ///
  /// In zh_Hans, this message translates to:
  /// **'调试'**
  String get settingsSectionDebug;

  /// No description provided for @settingsViewLogs.
  ///
  /// In zh_Hans, this message translates to:
  /// **'查看日志'**
  String get settingsViewLogs;

  /// No description provided for @settingsProxyDialogTitle.
  ///
  /// In zh_Hans, this message translates to:
  /// **'代理设置'**
  String get settingsProxyDialogTitle;

  /// No description provided for @settingsProxyHost.
  ///
  /// In zh_Hans, this message translates to:
  /// **'主机地址'**
  String get settingsProxyHost;

  /// No description provided for @settingsProxyHostHint.
  ///
  /// In zh_Hans, this message translates to:
  /// **'例如 127.0.0.1'**
  String get settingsProxyHostHint;

  /// No description provided for @settingsProxyPort.
  ///
  /// In zh_Hans, this message translates to:
  /// **'端口'**
  String get settingsProxyPort;

  /// No description provided for @settingsProxyPortHint.
  ///
  /// In zh_Hans, this message translates to:
  /// **'例如 7890'**
  String get settingsProxyPortHint;

  /// No description provided for @userTitle.
  ///
  /// In zh_Hans, this message translates to:
  /// **'我的'**
  String get userTitle;

  /// No description provided for @userTabProfile.
  ///
  /// In zh_Hans, this message translates to:
  /// **'资料'**
  String get userTabProfile;

  /// No description provided for @userUnknown.
  ///
  /// In zh_Hans, this message translates to:
  /// **'未知用户'**
  String get userUnknown;

  /// No description provided for @captchaUnavailable.
  ///
  /// In zh_Hans, this message translates to:
  /// **'验证码不可用'**
  String get captchaUnavailable;

  /// No description provided for @captchaLoadFailed.
  ///
  /// In zh_Hans, this message translates to:
  /// **'验证码加载失败'**
  String get captchaLoadFailed;

  /// No description provided for @loginFailed.
  ///
  /// In zh_Hans, this message translates to:
  /// **'登录失败'**
  String get loginFailed;

  /// No description provided for @imageFormatNotSupported.
  ///
  /// In zh_Hans, this message translates to:
  /// **'仅支持 jpg/jpeg/png/gif/bmp/webp 图片'**
  String get imageFormatNotSupported;

  /// No description provided for @imageReadFailed.
  ///
  /// In zh_Hans, this message translates to:
  /// **'读取图片失败'**
  String get imageReadFailed;

  /// No description provided for @imageUploadFailed.
  ///
  /// In zh_Hans, this message translates to:
  /// **'图片上传失败'**
  String get imageUploadFailed;

  /// No description provided for @uploadImage.
  ///
  /// In zh_Hans, this message translates to:
  /// **'上传图片'**
  String get uploadImage;

  /// No description provided for @currentForumNoUploadSupport.
  ///
  /// In zh_Hans, this message translates to:
  /// **'当前板块暂不支持上传图片'**
  String get currentForumNoUploadSupport;

  /// No description provided for @checkInComplete.
  ///
  /// In zh_Hans, this message translates to:
  /// **'签到完成'**
  String get checkInComplete;

  /// No description provided for @loadFailed.
  ///
  /// In zh_Hans, this message translates to:
  /// **'加载失败'**
  String get loadFailed;

  /// No description provided for @tapToRetry.
  ///
  /// In zh_Hans, this message translates to:
  /// **'点击重试'**
  String get tapToRetry;

  /// No description provided for @newPostMetaLoadFailed.
  ///
  /// In zh_Hans, this message translates to:
  /// **'加载发帖信息失败'**
  String get newPostMetaLoadFailed;

  /// No description provided for @postSubjectCategory.
  ///
  /// In zh_Hans, this message translates to:
  /// **'主题分类'**
  String get postSubjectCategory;

  /// No description provided for @topicDetailReplyToPost.
  ///
  /// In zh_Hans, this message translates to:
  /// **'回复 #{index} {author}\n'**
  String topicDetailReplyToPost(int index, String author);

  /// No description provided for @postForumLoading.
  ///
  /// In zh_Hans, this message translates to:
  /// **'正在加载板块...'**
  String get postForumLoading;

  /// No description provided for @postForumLoadFailed.
  ///
  /// In zh_Hans, this message translates to:
  /// **'加载失败，请返回重试'**
  String get postForumLoadFailed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hans':
            return AppLocalizationsZhHans();
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
