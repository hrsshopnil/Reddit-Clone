import 'package:flutter/material.dart';
import 'package:reddit_clone/features/auth/view/pages/login_page.dart';
import 'package:reddit_clone/features/community/view/pages/community_page.dart';
import 'package:reddit_clone/features/community/view/pages/create_community_page.dart';
import 'package:reddit_clone/features/community/view/pages/edit_community_page.dart';
import 'package:reddit_clone/features/community/view/pages/mode_tools_page.dart';
import 'package:reddit_clone/features/home/view/pages/home_page.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(
  routes: {'/': (_) => const MaterialPage(child: LoginPage())},
);

final loggedInRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: HomePage()),
    '/create-community':
        (_) => const MaterialPage(child: CreateCommunityPage()),
    '/r/:name':
        (route) => MaterialPage(
          child: CommunityPage(name: route.pathParameters['name']!),
        ),
    '/mod-tools/:name':
        (route) => MaterialPage(
          child: ModeToolsPage(name: route.pathParameters['name']!),
        ),
    '/edit_community/:name':
        (route) => MaterialPage(
          child: EditCommunityPage(name: route.pathParameters['name']!),
        ),
  },
);
