// Copyright 2026 BenderBlog Rodriguez and Contributors.
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import '../constants/forum_id.dart';

import '../controller/ruisi_controller.dart';

import '../constants/urls.dart';
import 'topic_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = GetIt.instance<RuisiService>();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.homeTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: AppLocalizations.of(context)!.homeSearch,
            onPressed: () => context.push('/search'),
          ),
          IconButton(
            icon: const Icon(Icons.edit_note),
            tooltip: AppLocalizations.of(context)!.homeNewPost,
            onPressed: () => context.push('/new-post'),
          ),
          IconButton(
            icon: const Icon(Icons.forum),
            tooltip: AppLocalizations.of(context)!.homeForumList,
            onPressed: () => context.push('/forums'),
          ),
          IconButton(
            icon: ClipOval(
              child: Image.network(
                Urls.getAvaterUrl(c.settings.uid, size: 0),
                width: 28,
                height: 28,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const Icon(Icons.person, size: 24),
              ),
            ),
            tooltip: AppLocalizations.of(context)!.homeMyProfile,
            onPressed: () => context.push('/user'),
          ),
        ],
        bottom: TabBar(
          isScrollable: true,
          controller: _tabCtrl,
          tabs: [
            Tab(
              text: AppLocalizations.of(context)!.homeTabNewPost,
            ),
            Tab(
              text: AppLocalizations.of(context)!.homeTabNewReply,
            ),
            Tab(text: AppLocalizations.of(context)!.homeTabWater),
            Tab(
              text: AppLocalizations.of(context)!.homeTabPhotography,
            ),
            Tab(text: AppLocalizations.of(context)!.homeTabTrade),
            Tab(
              text: AppLocalizations.of(context)!.homeTabEmployment,
            ),
            Tab(
              text: AppLocalizations.of(context)!.homeTabLostFound,
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: [
          // 首页帖子列表使用预览语义，避免分屏误触后直接丢失原详情链。
          TopicListPage(
            getTopicList: (int page) => c.api.getNewTopics(page: page),
            useHomeTopicPreviewNavigation: true,
          ),
          TopicListPage(
            getTopicList: (int page) => c.api.getNewReplyTopics(page: page),
            useHomeTopicPreviewNavigation: true,
          ),
          TopicListPage(
            getTopicList: (int page) =>
                c.api.getTopicList(ForumId.randomChat, page: page),
            useHomeTopicPreviewNavigation: true,
          ),
          TopicListPage(
            getTopicList: (int page) =>
                c.api.getTopicList(ForumId.photograph, page: page),
            useHomeTopicPreviewNavigation: true,
          ),
          TopicListPage(
            getTopicList: (int page) =>
                c.api.getTopicList(ForumId.secondHand, page: page),
            useHomeTopicPreviewNavigation: true,
          ),
          TopicListPage(
            getTopicList: (int page) =>
                c.api.getTopicList(ForumId.employment, page: page),
            useHomeTopicPreviewNavigation: true,
          ),
          TopicListPage(
            getTopicList: (int page) =>
                c.api.getTopicList(ForumId.lostAndFound, page: page),
            useHomeTopicPreviewNavigation: true,
          ),
        ],
      ),
    );
  }
}
