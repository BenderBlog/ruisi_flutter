// Copyright 2026 BenderBlog Rodriguez and Contributors.
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../widgets/topic_list_item.dart';
import 'topic_detail_page.dart';
import 'login_page.dart';

/// 用户页面（我的帖子、我的资料）
class UserPage extends StatefulWidget {
  final int initialTab;

  const UserPage({super.key, this.initialTab = 0});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final app = context.read<AppProvider>();
      if (!app.isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
        return;
      }
      app.loadMyTopics(refresh: true);
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
        title: const Text('我的'),
        bottom: TabBar(
          controller: _tabCtrl,
          tabs: const [
            Tab(text: '我的帖子'),
            Tab(text: '资料'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: [
          // 我的帖子
          app.myTopicsLoading && app.myTopics.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : app.myTopics.isEmpty
              ? const Center(child: Text('暂无帖子'))
              : RefreshIndicator(
                  onRefresh: () async => app.loadMyTopics(refresh: true),
                  child: ListView.separated(
                    itemCount: app.myTopics.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final topic = app.myTopics[i];
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
                ),

          // 资料
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Icon(Icons.person, size: 64),
                      const SizedBox(height: 12),
                      Text(
                        app.username ?? '未知用户',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'uid: ${app.settings.uid ?? ""}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
