// Copyright 2026 BenderBlog Rodriguez and Contributors.
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import 'forum_topics_page.dart';

/// 论坛板块列表
class ForumListPage extends StatefulWidget {
  const ForumListPage({super.key});

  @override
  State<ForumListPage> createState() => _ForumListPageState();
}

class _ForumListPageState extends State<ForumListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().loadForums();
    });
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('论坛板块')),
      body: app.forumGroups.isEmpty && app.forumLoading
          ? const Center(child: CircularProgressIndicator())
          : app.forumGroups.isEmpty
          ? const Center(child: Text('暂无板块'))
          : ListView.builder(
              itemCount: app.forumGroups.length,
              itemBuilder: (_, i) {
                final group = app.forumGroups[i];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text(
                        group.name,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ...group.forums.map(
                      (forum) => ListTile(
                        leading: const Icon(Icons.forum_outlined),
                        title: Text(forum.name),
                        subtitle: forum.description != null
                            ? Text(
                                forum.description!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                            : null,
                        trailing: forum.todayPosts > 0
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${forum.todayPosts}',
                                  style: Theme.of(context).textTheme.labelSmall,
                                ),
                              )
                            : null,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ForumTopicsPage(
                              fid: forum.fid,
                              title: forum.name,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (i < app.forumGroups.length - 1) const Divider(),
                  ],
                );
              },
            ),
    );
  }
}
