// Copyright 2026 BenderBlog Rodriguez and Contributors.
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../widgets/topic_list_item.dart';
import 'topic_detail_page.dart';

/// 板块帖子列表
class ForumTopicsPage extends StatefulWidget {
  final int fid;
  final String title;

  const ForumTopicsPage({super.key, required this.fid, required this.title});

  @override
  State<ForumTopicsPage> createState() => _ForumTopicsPageState();
}

class _ForumTopicsPageState extends State<ForumTopicsPage> {
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().loadTopics(widget.fid, refresh: true);
    });
    _scrollCtrl.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollCtrl.position.pixels >=
        _scrollCtrl.position.maxScrollExtent - 200) {
      final app = context.read<AppProvider>();
      if (app.hasMoreTopics && !app.topicLoading) {
        app.loadTopics(widget.fid);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final topics = app.topics;

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: app.topicLoading && topics.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : topics.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('暂无帖子'),
                  const SizedBox(height: 8),
                  FilledButton.tonal(
                    onPressed: () => app.loadTopics(widget.fid, refresh: true),
                    child: const Text('刷新'),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async => app.loadTopics(widget.fid, refresh: true),
              child: ListView.separated(
                controller: _scrollCtrl,
                itemCount: topics.length + (app.hasMoreTopics ? 1 : 0),
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  if (i == topics.length) {
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
            ),
    );
  }
}
