// Copyright 2026 BenderBlog Rodriguez and Contributors.
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../models/message.dart';
import 'topic_detail_page.dart';
import 'login_page.dart';

/// 消息通知页面
class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final app = context.read<AppProvider>();
      if (!app.isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
        return;
      }
      app.loadMessages();
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
        title: const Text('消息'),
        bottom: TabBar(
          controller: _tabCtrl,
          tabs: const [
            Tab(text: '回复'),
            Tab(text: '@我'),
          ],
        ),
      ),
      body: app.messageLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabCtrl,
              children: [
                app.replyNotifications.isEmpty
                    ? const Center(child: Text('暂无回复通知'))
                    : _buildReplyList(app.replyNotifications),
                app.atNotifications.isEmpty
                    ? const Center(child: Text('暂无@通知'))
                    : _buildAtList(app.atNotifications),
              ],
            ),
    );
  }

  Widget _buildReplyList(List<ReplyNotification> items) {
    final app = context.read<AppProvider>();
    return RefreshIndicator(
      onRefresh: () async => app.loadMessages(),
      child: ListView.separated(
        itemCount: items.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (_, i) {
          final item = items[i];
          return ListTile(
            leading: CircleAvatar(
              child: Text(item.author.isNotEmpty ? item.author[0] : '?'),
            ),
            title: Text(item.title),
            subtitle: Text(
              '${item.author}: ${item.snippet}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(
              item.time,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => TopicDetailPage(tid: item.tid)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAtList(List<AtNotification> items) {
    final app = context.read<AppProvider>();
    return RefreshIndicator(
      onRefresh: () async => app.loadMessages(),
      child: ListView.separated(
        itemCount: items.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (_, i) {
          final item = items[i];
          return ListTile(
            leading: CircleAvatar(
              child: Text(item.author.isNotEmpty ? item.author[0] : '?'),
            ),
            title: Text(item.title),
            subtitle: Text(
              '${item.author}: ${item.snippet}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(
              item.time,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => TopicDetailPage(tid: item.tid)),
            ),
          );
        },
      ),
    );
  }
}
