// Copyright 2026 BenderBlog Rodriguez and Contributors.
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../widgets/topic_list_item.dart';
import 'topic_detail_page.dart';
import 'login_page.dart';

/// 论坛网络收藏
class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final app = context.read<AppProvider>();
      if (!app.isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
        return;
      }
      app.loadFavorites(refresh: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('我的收藏')),
      body: app.favoritesLoading && app.favorites.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : app.favorites.isEmpty
          ? const Center(child: Text('暂无收藏'))
          : RefreshIndicator(
              onRefresh: () async => app.loadFavorites(refresh: true),
              child: ListView.separated(
                itemCount: app.favorites.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final topic = app.favorites[i];
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
