// Copyright 2026 BenderBlog Rodriguez and Contributors.
// SPDX-License-Identifier: BSD-3-Clause

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import 'controller/ruisi_controller.dart';
import 'pages/about_page.dart';
import 'pages/favorites_page.dart';
import 'pages/forum_list_page.dart';
import 'pages/forum_topics_page.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/my_posts_page.dart';
import 'pages/new_post_page.dart';
import 'pages/search_page.dart';
import 'pages/settings_page.dart';
import 'pages/topic_detail_page.dart';
import 'pages/user_page.dart';

GoRouter createRouter() {
  final rootNavigatorKey = GlobalKey<NavigatorState>();
  final ruisiService = GetIt.instance<RuisiService>();

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/home',
    refreshListenable: ruisiService.isLoggedInNotifier,
    redirect: (context, state) {
      final isLoggedIn = ruisiService.isLoggedIn;
      final onLogin = state.matchedLocation == '/login';
      if (!isLoggedIn && !onLogin) return '/login';
      if (isLoggedIn && onLogin) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (_, _) => const LoginPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (_, _) => const HomePage(),
      ),
      GoRoute(
        path: '/topic/:tid',
        builder: (_, state) {
          final tid = int.parse(state.pathParameters['tid']!);
          return TopicDetailPage(tid: tid);
        },
      ),
      GoRoute(
        path: '/forum/:fid',
        builder: (_, state) {
          final fid = int.parse(state.pathParameters['fid']!);
          final name = state.extra as String? ?? '';
          return ForumTopicsPage(fid: fid, name: name);
        },
      ),
      GoRoute(
        path: '/forums',
        builder: (_, _) => const ForumListPage(),
      ),
      GoRoute(
        path: '/new-post',
        builder: (_, _) => const NewPostPage(),
      ),
      GoRoute(
        path: '/search',
        builder: (_, _) => const SearchPage(),
      ),
      GoRoute(
        path: '/user',
        builder: (_, _) => const UserPage(),
      ),
      GoRoute(
        path: '/user/posts',
        builder: (_, _) => const MyPostsPage(),
      ),
      GoRoute(
        path: '/user/favorites',
        builder: (_, _) => const FavoritesPage(),
      ),
      GoRoute(
        path: '/settings',
        builder: (_, _) =>
            SettingsPage(talker: ruisiService.talker),
      ),
      GoRoute(
        path: '/about',
        builder: (_, _) => const AboutPage(),
      ),
    ],
  );
}
