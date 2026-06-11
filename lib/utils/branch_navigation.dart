// Copyright 2026 BenderBlog Rodriguez and Contributors.
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

extension RuisiBranchNavigation on BuildContext {
  /// 从首页帖子列表打开帖子详情。
  ///
  /// 如果当前已在帖子详情页，替换而非压栈，避免连续点击时无限叠栈。
  void pushTopicDetail(int tid) {
    final router = GoRouter.of(this);
    final location = router.state.matchedLocation;
    if (location.startsWith('/topic/')) {
      replace('/topic/$tid');
    } else {
      push('/topic/$tid');
    }
  }
}
