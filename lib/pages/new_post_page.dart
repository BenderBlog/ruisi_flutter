// Copyright 2026 BenderBlog Rodriguez and Contributors.
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../widgets/smiley_picker.dart';

/// 发帖页面
///
/// 支持输入标题和正文（BBCode），可插入表情和图片。
/// 图片上传后会在正文中插入对应的 BBCode 附件标签。
class NewPostPage extends StatefulWidget {
  /// 板块 fid，为 null 时显示论坛选择器
  final int? fid;

  /// 板块名称（仅用于 AppBar 显示）
  final String? forumName;

  const NewPostPage({super.key, this.fid, this.forumName});

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  final _titleFocus = FocusNode();
  final _contentFocus = FocusNode();

  int? _selectedFid;
  String? _selectedForumName;
  bool _submitting = false;
  bool _showSmiley = false;
  final List<_UploadedImage> _images = [];

  int? get _effectiveFid => widget.fid ?? _selectedFid;

  @override
  void initState() {
    super.initState();
    _selectedFid = widget.fid;
    _selectedForumName = widget.forumName;
    // 未指定板块时加载论坛列表供选择
    if (widget.fid == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final app = context.read<AppProvider>();
        if (app.forumGroups.isEmpty) {
          app.loadForums();
        }
      });
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    _titleFocus.dispose();
    _contentFocus.dispose();
    super.dispose();
  }

  // ===========================================================================
  // 表情
  // ===========================================================================

  void _toggleSmiley() {
    setState(() => _showSmiley = !_showSmiley);
    if (_showSmiley) {
      // 打开表情面板时收起键盘
      FocusScope.of(context).unfocus();
    }
  }

  void _insertSmiley(String value) {
    final text = _contentCtrl.text;
    final sel = _contentCtrl.selection;
    final newText = text.replaceRange(
      sel.start >= 0 ? sel.start : text.length,
      sel.end >= 0 ? sel.end : text.length,
      value,
    );
    _contentCtrl.text = newText;
    final newPos = (sel.start >= 0 ? sel.start : text.length) + value.length;
    _contentCtrl.selection = TextSelection.collapsed(offset: newPos);
  }

  // ===========================================================================
  // 图片上传
  // ===========================================================================

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 2048,
      maxHeight: 2048,
      imageQuality: 85,
    );
    if (picked == null) return;
    if (!mounted) return;

    setState(() => _showSmiley = false);

    final app = context.read<AppProvider>();
    final file = File(picked.path);

    // 显示上传中提示
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('图片上传中...'),
          duration: Duration(seconds: 30),
        ),
      );
    }

    final result = await app.uploadImage(file);
    if (!mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    if (result != null) {
      setState(() {
        _images.add(
          _UploadedImage(aid: result.$1, url: result.$2, filename: picked.name),
        );
      });
      // 在正文末尾插入附件标签
      final tag = '[attachimg]${result.$1}[/attachimg]';
      final text = _contentCtrl.text;
      final sel = _contentCtrl.selection;
      final pos = sel.isValid ? sel.end : text.length;
      _contentCtrl.text = text.replaceRange(pos, pos, '\n$tag\n');
      _contentCtrl.selection = TextSelection.collapsed(
        offset: pos + tag.length + 2,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('图片上传成功'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('图片上传失败'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  // ===========================================================================
  // 提交发帖
  // ===========================================================================

  Future<void> _submit() async {
    final fid = _effectiveFid;
    if (fid == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请先选择论坛板块')));
      return;
    }
    final title = _titleCtrl.text.trim();
    final content = _contentCtrl.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请输入标题')));
      _titleFocus.requestFocus();
      return;
    }
    if (content.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请输入内容')));
      _contentFocus.requestFocus();
      return;
    }

    setState(() => _submitting = true);

    final app = context.read<AppProvider>();
    final (ok, message) = await app.newPost(fid, title, content);

    if (!mounted) return;
    setState(() => _submitting = false);

    if (ok) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('发帖成功')));
      Navigator.pop(context, true); // 返回 true 表示发帖成功
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message ?? '发帖失败，请重试')));
    }
  }

  // ===========================================================================
  // 论坛选择器
  // ===========================================================================

  Widget _buildForumSelector(ThemeData theme) {
    return Consumer<AppProvider>(
      builder: (_, app, __) {
        if (app.forumLoading) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final allForums = app.forumGroups.expand((g) => g.forums).toList();
        if (allForums.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.warning_amber, size: 18),
                const SizedBox(width: 8),
                const Expanded(child: Text('无法加载论坛列表')),
                TextButton(
                  onPressed: () => app.loadForums(),
                  child: const Text('重试'),
                ),
              ],
            ),
          );
        }
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            border: Border(bottom: Divider.createBorderSide(context)),
          ),
          child: DropdownButton<int>(
            value: _selectedFid,
            hint: const Text('请选择论坛板块'),
            isExpanded: true,
            underline: const SizedBox(),
            items: [
              for (final group in app.forumGroups)
                for (final forum in group.forums)
                  DropdownMenuItem(value: forum.fid, child: Text(forum.name)),
            ],
            onChanged: (fid) {
              if (fid == null) return;
              final forum = allForums.firstWhere((f) => f.fid == fid);
              setState(() {
                _selectedFid = fid;
                _selectedForumName = forum.name;
              });
            },
          ),
        );
      },
    );
  }

  // ===========================================================================
  // UI
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedForumName != null ? '发帖 · $_selectedForumName' : '发帖',
        ),
        actions: [
          // 发布按钮
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilledButton(
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('发布'),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 未指定板块时显示论坛选择器
          if (widget.fid == null) _buildForumSelector(theme),
          // 标题输入
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: TextField(
              controller: _titleCtrl,
              focusNode: _titleFocus,
              style: theme.textTheme.titleMedium,
              decoration: const InputDecoration(
                hintText: '帖子标题',
                border: InputBorder.none,
              ),
              maxLength: 120,
              buildCounter:
                  (
                    _, {
                    required currentLength,
                    required isFocused,
                    required maxLength,
                  }) => null, // 隐藏字数统计
            ),
          ),
          const Divider(height: 1),
          // 内容输入
          Expanded(
            child: GestureDetector(
              onTap: () {
                // 点击内容区域时关闭表情面板，弹出键盘
                if (_showSmiley) {
                  setState(() => _showSmiley = false);
                }
                _contentFocus.requestFocus();
              },
              child: Container(
                color: theme.colorScheme.surface,
                child: TextField(
                  controller: _contentCtrl,
                  focusNode: _contentFocus,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    hintText: '说点什么吧…（支持 BBCode）',
                    contentPadding: EdgeInsets.all(16),
                    border: InputBorder.none,
                  ),
                  onTap: () {
                    if (_showSmiley) {
                      setState(() => _showSmiley = false);
                    }
                  },
                ),
              ),
            ),
          ),
          // 已上传图片预览
          if (_images.isNotEmpty)
            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                itemCount: _images.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final img = _images[i];
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          img.url,
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            width: 64,
                            height: 64,
                            color: theme.colorScheme.surfaceContainerHighest,
                            child: const Icon(Icons.image, size: 28),
                          ),
                        ),
                      ),
                      // 删除按钮
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () => setState(() => _images.removeAt(i)),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(2),
                            child: const Icon(
                              Icons.close,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          // 底部工具栏
          Container(
            decoration: BoxDecoration(
              border: Border(top: Divider.createBorderSide(context)),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  // 表情按钮
                  IconButton(
                    onPressed: _toggleSmiley,
                    icon: Icon(
                      _showSmiley
                          ? Icons.keyboard_outlined
                          : Icons.emoji_emotions_outlined,
                      color: _showSmiley
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                    tooltip: '表情',
                  ),
                  // 图片按钮
                  IconButton(
                    onPressed: _pickAndUploadImage,
                    icon: const Icon(Icons.image_outlined),
                    tooltip: '上传图片',
                  ),
                  const Spacer(),
                  // 字数
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Text(
                      '${_contentCtrl.text.length} 字',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // 表情选择器（可切换显示）
          if (_showSmiley)
            Container(
              decoration: BoxDecoration(
                border: Border(top: Divider.createBorderSide(context)),
                color: theme.colorScheme.surface,
              ),
              child: SmileyPicker(onSelected: _insertSmiley),
            ),
        ],
      ),
    );
  }
}

/// 已上传的图片信息
class _UploadedImage {
  final int aid;
  final String url;
  final String filename;

  _UploadedImage({
    required this.aid,
    required this.url,
    required this.filename,
  });
}
