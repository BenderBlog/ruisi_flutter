// Copyright 2026 BenderBlog Rodriguez and Contributors.
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../providers/app_provider.dart';
import '../models/post.dart';
import '../constants/urls.dart';
import 'login_page.dart';

/// 帖子详情页
class TopicDetailPage extends StatefulWidget {
  final int tid;

  const TopicDetailPage({super.key, required this.tid});

  @override
  State<TopicDetailPage> createState() => _TopicDetailPageState();
}

class _TopicDetailPageState extends State<TopicDetailPage> {
  final _replyCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  bool _showReply = false;

  dynamic _detail; // TopicDetail?
  bool _loading = true;
  String? _error;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _replyCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _load({int page = 1}) async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final app = context.read<AppProvider>();
    try {
      final detail = await app.api.getTopicDetail(widget.tid, page: page);
      if (!mounted) return;
      setState(() {
        _detail = detail;
        _currentPage = page;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _submitReply() async {
    final content = _replyCtrl.text.trim();
    if (content.isEmpty) return;

    if (content.length < 13) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('回复内容不能少于 13 个字符')));
      return;
    }

    final app = context.read<AppProvider>();
    if (!app.isLoggedIn) {
      if (!mounted) return;
      final result = await Navigator.push<bool>(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
      if (result != true) return;
    }

    final ok = await app.api.replyTopic(widget.tid, content);
    if (!mounted) return;

    if (ok) {
      _replyCtrl.clear();
      setState(() => _showReply = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('回复成功')));
      _load(page: _currentPage);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('回复失败')));
    }
  }

  Future<void> _addFavorite() async {
    final app = context.read<AppProvider>();
    if (!app.isLoggedIn) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
      return;
    }
    final ok = await app.addFavorite(widget.tid);
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(ok ? '收藏成功' : '收藏失败')));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_detail?.title ?? '帖子详情'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            tooltip: '收藏',
            onPressed: _addFavorite,
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              final url = '${Urls.baseUrl}viewthread.php?tid=${widget.tid}';
              launchUrl(Uri.parse(url));
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_error!),
                  const SizedBox(height: 8),
                  FilledButton.tonal(
                    onPressed: () => _load(),
                    child: const Text('重试'),
                  ),
                ],
              ),
            )
          : _detail == null
          ? const Center(child: Text('无数据'))
          : Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async => _load(page: _currentPage),
                    child: ListView.separated(
                      controller: _scrollCtrl,
                      itemCount: (_detail.posts?.length ?? 0) + 2,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (_, i) {
                        if (i == 0) {
                          return Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _detail.title ?? '',
                                  style: theme.textTheme.titleLarge,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${_detail.author ?? ""} · ${_detail.time ?? ""}',
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          );
                        }

                        final posts = _detail.posts as List<Post>? ?? [];
                        if (i <= posts.length) {
                          final post = posts[i - 1];
                          return _PostItem(
                            post: post,
                            onReply: () {
                              _replyCtrl.text = '回复 ${post.author}：\n';
                              setState(() => _showReply = true);
                            },
                          );
                        }

                        final totalPages = _detail.totalPages ?? 1;
                        if (totalPages <= 1) {
                          return const SizedBox();
                        }
                        return _Pagination(
                          current: _detail.currentPage ?? 1,
                          total: totalPages,
                          onPageChanged: (p) => _load(page: p),
                        );
                      },
                    ),
                  ),
                ),
                if (_showReply)
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.9),
                          blurRadius: 4,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _replyCtrl,
                            maxLines: 3,
                            minLines: 1,
                            decoration: const InputDecoration(
                              hintText: '写回复...',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton.filled(
                          icon: const Icon(Icons.send),
                          onPressed: _submitReply,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
      floatingActionButton: _showReply
          ? null
          : FloatingActionButton(
              onPressed: () => setState(() => _showReply = true),
              child: const Icon(Icons.reply),
            ),
    );
  }
}

/// 单条回复
class _PostItem extends StatelessWidget {
  final Post post;
  final VoidCallback? onReply;

  const _PostItem({required this.post, this.onReply});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: post.avatar != null
                    ? CachedNetworkImageProvider(post.avatar!)
                    : null,
                child: post.avatar == null
                    ? const Icon(Icons.person, size: 20)
                    : null,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.author,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (post.time.isNotEmpty)
                      Text(post.time, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              if (post.index > 0)
                Text(
                  '#${post.index}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Html(
            data: post.content,
            onLinkTap: (url, _, _) {
              if (url != null) launchUrl(Uri.parse(url));
            },
          ),
          if (post.images.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: post.images
                  .map(
                    (img) => GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => Dialog(
                            child: InteractiveViewer(
                              child: CachedNetworkImage(
                                imageUrl: img.url,
                                fit: BoxFit.contain,
                                placeholder: (_, _) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (_, _, _) =>
                                    const Icon(Icons.broken_image),
                              ),
                            ),
                          ),
                        );
                      },
                      child: CachedNetworkImage(
                        imageUrl: img.url,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        placeholder: (_, _) => Container(
                          width: 100,
                          height: 100,
                          color: theme.colorScheme.surfaceContainerHighest,
                        ),
                        errorWidget: (_, _, _) => Container(
                          width: 100,
                          height: 100,
                          color: theme.colorScheme.surfaceContainerHighest,
                          child: const Icon(Icons.broken_image),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.reply, size: 16),
                label: const Text('回复'),
                onPressed: onReply,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 分页组件
class _Pagination extends StatelessWidget {
  final int current;
  final int total;
  final ValueChanged<int> onPageChanged;

  const _Pagination({
    required this.current,
    required this.total,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pages = <int>[];
    for (
      int i = (current - 2).clamp(1, total);
      i <= (current + 2).clamp(1, total);
      i++
    ) {
      pages.add(i);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (current > 1)
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () => onPageChanged(current - 1),
            ),
          for (final p in pages)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: ChoiceChip(
                label: Text('$p'),
                selected: p == current,
                onSelected: p != current ? (_) => onPageChanged(p) : null,
                labelStyle: p == current
                    ? TextStyle(color: theme.colorScheme.onPrimary)
                    : null,
              ),
            ),
          if (current < total)
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () => onPageChanged(current + 1),
            ),
        ],
      ),
    );
  }
}
