// Copyright 2026 BenderBlog Rodriguez and Contributors.
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';
import 'topic_list_page.dart';

import '../controller/ruisi_controller.dart';

class MyPostsPage extends StatelessWidget {
  const MyPostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.favoritesTitle),
      ),
      body: TopicListPage(
        getTopicList: (int page) =>
            GetIt.instance<RuisiService>().api.getMyTopics(page: page),
      ),
    );
  }
}
