// Copyright 2026 BenderBlog Rodriguez and Contributors.
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../l10n/app_localizations.dart';

import '../models/topic.dart';
import '../controller/ruisi_controller.dart';
import '../widgets/topic_list_item.dart';

/// 搜索页面
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String search = '';
  late final _textEditingController = TextEditingController.fromValue(
    TextEditingValue(text: search),
  );
  late final _pagingController = PagingController<int, Topic>(
    getNextPageKey: (state) =>
        state.lastPageIsEmpty ? null : state.nextIntPageKey,
    fetchPage: (pageKey) =>
        GetIt.instance<RuisiService>().search(search, pageKey),
  );

  @override
  void dispose() {
    _textEditingController.dispose();
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: _textEditingController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.searchHint,
            border: InputBorder.none,
          ),
          onChanged: (String textFieldValue) => search = textFieldValue,
          onFieldSubmitted: (value) {
            _pagingController.refresh();
          },
        ),
      ),
      body: PagingListener(
        controller: _pagingController,
        builder: (context, state, fetchNextPage) => LayoutBuilder(
          builder: (context, constraints) =>
              PagedListView<int, Topic>.separated(
                state: state,
                fetchNextPage: fetchNextPage,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                builderDelegate: PagedChildBuilderDelegate(
                  itemBuilder: (context, item, index) => TopicListItem(
                    topic: item,
                    onTap: () => context.push('/topic/${item.tid}'),
                  ),
                ),
                separatorBuilder: (_, _) => const Divider(height: 1),
              ),
        ),
      ),
    );
  }
}
