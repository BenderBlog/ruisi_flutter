// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get commonRefresh => 'Refresh';

  @override
  String get commonConfirm => 'OK';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonNoTopics => 'No topics';

  @override
  String get commonNoContent => 'No content';

  @override
  String get commonReply => 'Reply';

  @override
  String get commonFavorite => 'Favorite';

  @override
  String get commonNotImplemented => 'Not implemented';

  @override
  String get commonLogin => 'Login';

  @override
  String get commonLogout => 'Log out';

  @override
  String get commonLoggedOut => 'Logged out';

  @override
  String get commonSubmit => 'Submit';

  @override
  String get aboutTitle => 'About';

  @override
  String get aboutAppName => 'Ruisi';

  @override
  String get aboutSubtitle => 'Xidian University Campus Forum Client';

  @override
  String get aboutVersion => 'Version';

  @override
  String get aboutVersionNumber => '2.0.0 (bundled with XDYou 1.6.0)';

  @override
  String get aboutSourceCode => 'Source Code';

  @override
  String get aboutBugReport => 'Bug Report';

  @override
  String get aboutBugReportSubtitle => 'Submit an issue on GitHub';

  @override
  String get aboutPrivacyPolicy => 'Privacy Policy';

  @override
  String get aboutLicense =>
      'Licensed under the BSD-3-Clause License\nRewritten with AI assistance based on Ruisi-iOS and Ruisi-Android';

  @override
  String get aboutPrivacyPolicyContent =>
      'This app only runs on the Xidian University campus network, accessing data from the Ruisi Forum (rs.xidian.edu.cn).\n\nThis app does not collect, store, or transmit any user personal information to third-party servers.\n\nUser login credentials are stored only on the local device for authentication with the Ruisi Forum server.\n\nThis app uses cookies to communicate with the Ruisi Forum server. All data exchange occurs directly between the user\'s device and the Ruisi Forum server.\n\nIf you have any questions, please contact the developer by submitting an issue on GitHub.';

  @override
  String get homeTitle => 'Ruisi Forum';

  @override
  String get homeNewPost => 'New Post';

  @override
  String get homeForumList => 'Forums';

  @override
  String get homeTabHot => 'Hot';

  @override
  String get homeTabNewReply => 'Latest Replies';

  @override
  String get homeTabNewPost => 'Latest Posts';

  @override
  String get homeTabMy => 'My';

  @override
  String get homeTabTrade => 'Marketplace';

  @override
  String get homeTabWater => 'Casual';

  @override
  String get homeTabLostFound => 'Lost & Found';

  @override
  String get homeTabEmployment => 'Jobs';

  @override
  String get homeTabPhotography => 'Photography';

  @override
  String get homePleaseLogin => 'Please log in first';

  @override
  String get homeMyProfile => 'My Profile';

  @override
  String get homeMyPosts => 'My Posts';

  @override
  String get homeMyFavorites => 'My Favorites';

  @override
  String get homeMessageCenter => 'Messages';

  @override
  String get homeDailyCheckin => 'Daily Check-in';

  @override
  String get homeSettings => 'Settings';

  @override
  String get homeAbout => 'About';

  @override
  String get homeSearch => 'Search posts...';

  @override
  String get loginTitle => 'Login to Ruisi';

  @override
  String get loginUsername => 'Username';

  @override
  String get loginUsernameHint => 'Please enter your username';

  @override
  String get loginPassword => 'Password';

  @override
  String get loginPasswordHint => 'Please enter your password';

  @override
  String get loginCaptcha => 'Captcha';

  @override
  String get loginCaptchaHint => 'Please enter the captcha';

  @override
  String get loginBack => 'Back';

  @override
  String get loginResetLoginState => 'Reset Login State';

  @override
  String get loginResetConfirmTitle => 'Confirm Reset';

  @override
  String get loginResetConfirmContent =>
      'Are you sure you want to reset the login state? This will clear all login information.';

  @override
  String get loginResetSuccess => 'Login state has been reset';

  @override
  String get loginViewLogs => 'View Logs';

  @override
  String get postTitle => 'New Post';

  @override
  String get postPublish => 'Publish';

  @override
  String get postSelectForum => 'Select Forum';

  @override
  String get postSelectForumHint => 'Please select a forum';

  @override
  String get postSubject => 'Title';

  @override
  String get postSubjectHint => 'Please enter a title';

  @override
  String get postContent => 'Content';

  @override
  String get postContentHint => 'Please enter content';

  @override
  String get postSuccess => 'Post published successfully';

  @override
  String get postFailure => 'Failed to publish post';

  @override
  String get postSmiley => 'Emoji';

  @override
  String get topicDetailTitle => 'Topic Detail';

  @override
  String get topicDetailReplyTooShort => 'Reply must be at least 13 characters';

  @override
  String get topicDetailReplySuccess => 'Reply sent successfully';

  @override
  String get topicDetailReplyFailure => 'Failed to send reply';

  @override
  String get topicDetailFavoriteSuccess => 'Added to favorites';

  @override
  String get topicDetailFavoriteFailure => 'Failed to add to favorites';

  @override
  String get topicDetailNoData => 'No data';

  @override
  String get topicDetailReplyHint => 'Write a reply...';

  @override
  String get topicDetailVoteSingleSelect => 'Single choice';

  @override
  String topicDetailVoteMultiSelect(int count) {
    return 'Multiple choice, up to $count';
  }

  @override
  String get topicDetailVoteTitlePrefix => 'Vote';

  @override
  String topicDetailVoteCount(int count) {
    return '$count people voted';
  }

  @override
  String get topicDetailVoteOpen => 'Click to vote';

  @override
  String get topicDetailVoteSheetTitle => 'Vote';

  @override
  String topicDetailVoteMaxSelection(int count) {
    return 'You can select up to $count options';
  }

  @override
  String get topicDetailVoteNotSelected => 'You haven\'t selected anything';

  @override
  String get topicDetailVoteSuccess => 'Vote submitted successfully';

  @override
  String get topicDetailVoteFailure => 'Failed to submit vote';

  @override
  String get topicDetailVoteParamError => 'Vote failed: invalid parameters';

  @override
  String get topicDetailVoteAlreadyVoted =>
      'You have already voted. Thank you for participating.';

  @override
  String get topicDetailVoteExpired => 'This vote has expired or been closed';

  @override
  String get topicDetailVoteEnded => 'This vote has ended';

  @override
  String get topicListItemSticky => 'Pinned';

  @override
  String get forumListTitle => 'Forums';

  @override
  String get forumListEmpty => 'No forums available';

  @override
  String get favoritesTitle => 'My Favorites';

  @override
  String get favoritesEmpty => 'No favorites yet';

  @override
  String get messagesTitle => 'Messages';

  @override
  String get messagesTabAt => '@Mentions';

  @override
  String get messagesNoReply => 'No reply notifications';

  @override
  String get messagesNoAt => 'No mention notifications';

  @override
  String get searchHint => 'Search posts...';

  @override
  String get searchInputHint => 'Enter keywords to search';

  @override
  String get searchNoResults => 'No results found';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSectionProxy => 'Proxy';

  @override
  String get settingsProxyEnable => 'Enable Proxy';

  @override
  String get settingsProxyDisabled => 'Not enabled';

  @override
  String get settingsProxyAddress => 'Proxy Address';

  @override
  String get settingsSectionDebug => 'Debug';

  @override
  String get settingsViewLogs => 'View Logs';

  @override
  String get settingsProxyDialogTitle => 'Proxy Settings';

  @override
  String get settingsProxyHost => 'Host';

  @override
  String get settingsProxyHostHint => 'e.g. 127.0.0.1';

  @override
  String get settingsProxyPort => 'Port';

  @override
  String get settingsProxyPortHint => 'e.g. 7890';

  @override
  String get userTitle => 'My';

  @override
  String get userTabProfile => 'Profile';

  @override
  String get userUnknown => 'Unknown User';

  @override
  String get captchaUnavailable => 'Captcha unavailable';

  @override
  String get captchaLoadFailed => 'Failed to load captcha';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get imageFormatNotSupported =>
      'Only jpg/jpeg/png/gif/bmp/webp images are supported';

  @override
  String get imageReadFailed => 'Failed to read image';

  @override
  String get imageUploadFailed => 'Image upload failed';

  @override
  String get uploadImage => 'Upload Image';

  @override
  String get currentForumNoUploadSupport =>
      'Image upload is not supported in this forum';

  @override
  String get checkInComplete => 'Check-in complete';

  @override
  String get loadFailed => 'Load failed';

  @override
  String get tapToRetry => 'Tap to retry';

  @override
  String get newPostMetaLoadFailed => 'Failed to load post information';

  @override
  String get postSubjectCategory => 'Subject Category';

  @override
  String topicDetailReplyToPost(int index, String author) {
    return 'Reply to #$index $author\n';
  }

  @override
  String get postForumLoading => 'Loading forums...';

  @override
  String get postForumLoadFailed => 'Failed to load, please go back and retry';
}
