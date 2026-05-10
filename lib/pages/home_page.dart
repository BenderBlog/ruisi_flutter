// Copyright 2026 BenderBlog Rodriguez and Contributors.
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../widgets/topic_list_item.dart';
import 'topic_detail_page.dart';
import 'forum_list_page.dart';
import 'login_page.dart';
import 'user_page.dart';
import 'favorites_page.dart';
import 'messages_page.dart';
import 'search_page.dart';
import 'settings_page.dart';
import 'about_page.dart';

/// 首页
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
    _tabCtrl = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final app = context.read<AppProvider>();
      app.loadHotTopics();
      app.loadNewReplyTopics(refresh: true);
      app.loadNewTopics(refresh: true);
    });
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('睿思论坛'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchPage()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.forum),
            tooltip: '论坛板块',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ForumListPage()),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabCtrl,
          tabs: const [
            Tab(text: '热帖'),
            Tab(text: '最新回复'),
            Tab(text: '最新发表'),
            Tab(text: '我的'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: [
          // 热帖
          _buildTopicList(
            context,
            topics: app.hotTopics,
            isLoading: app.hotLoading,
            onRefresh: () => app.loadHotTopics(),
          ),
          // 最新回复
          _buildTopicList(
            context,
            topics: app.newReplyTopics,
            isLoading: app.newReplyLoading,
            onRefresh: () => app.loadNewReplyTopics(refresh: true),
            onLoadMore: app.hasMoreNewReply
                ? () => app.loadNewReplyTopics()
                : null,
          ),
          // 最新发表
          _buildTopicList(
            context,
            topics: app.newTopics,
            isLoading: app.newLoading,
            onRefresh: () => app.loadNewTopics(refresh: true),
            onLoadMore: app.hasMoreNew ? () => app.loadNewTopics() : null,
          ),
          // 我的
          _buildMyTab(context, app),
        ],
      ),
    );
  }

  Widget _buildTopicList(
    BuildContext context, {
    required List topics,
    required bool isLoading,
    VoidCallback? onRefresh,
    VoidCallback? onLoadMore,
  }) {
    if (isLoading && topics.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (topics.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('暂无内容'),
            const SizedBox(height: 8),
            FilledButton.tonal(onPressed: onRefresh, child: const Text('刷新')),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => onRefresh?.call(),
      child: ListView.separated(
        itemCount: topics.length + (onLoadMore != null ? 1 : 0),
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (_, i) {
          if (i == topics.length) {
            // 加载更多
            onLoadMore?.call();
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final topic = topics[i];
          return TopicListItem(
            topic: topic,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TopicDetailPage(tid: topic.tid),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMyTab(BuildContext context, AppProvider app) {
    if (!app.isLoggedIn) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.person_outline, size: 64),
            const SizedBox(height: 16),
            const Text('请先登录'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
              child: const Text('登录'),
            ),
          ],
        ),
      );
    }

    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('我的资料'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const UserPage()),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.article),
          title: const Text('我的帖子'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const UserPage(initialTab: 0)),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.bookmark),
          title: const Text('我的收藏'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FavoritesPage()),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.notifications),
          title: const Text('消息中心'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MessagesPage()),
          ),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.edit_calendar),
          title: const Text('每日签到'),
          onTap: () async {
            await app.sign();
            if (!context.mounted) return;
            final msg = app.signResult?.message ?? '签到完成';
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(msg)));
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('设置'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SettingsPage()),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('关于'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AboutPage()),
          ),
        ),
        const Divider(),
        ListTile(
          leading: Icon(
            Icons.logout,
            color: Theme.of(context).colorScheme.error,
          ),
          title: Text(
            '退出登录',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          onTap: () async {
            await app.logout();
            if (!context.mounted) return;
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('已退出登录')));
          },
        ),
      ],
    );
  }
}
