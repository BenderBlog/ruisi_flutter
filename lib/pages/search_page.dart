// Copyright 2026 BenderBlog Rodriguez and Contributors.
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../widgets/topic_list_item.dart';
import 'topic_detail_page.dart';

/// 搜索页面
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchCtrl = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _doSearch() {
    final keyword = _searchCtrl.text.trim();
    if (keyword.isEmpty) return;
    context.read<AppProvider>().search(keyword);
  }

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchCtrl,
          focusNode: _focusNode,
          decoration: InputDecoration(
            hintText: '搜索帖子...',
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchCtrl.clear();
                app.clearSearch();
              },
            ),
          ),
          onSubmitted: (_) => _doSearch(),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: _doSearch),
        ],
      ),
      body: app.searchLoading
          ? const Center(child: CircularProgressIndicator())
          : app.searchResults.isEmpty
          ? Center(
              child: Text(app.searchKeyword.isEmpty ? '输入关键词搜索' : '未找到相关帖子'),
            )
          : RefreshIndicator(
              onRefresh: () async => _doSearch(),
              child: ListView.separated(
                itemCount: app.searchResults.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) {
                  final topic = app.searchResults[i];
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
