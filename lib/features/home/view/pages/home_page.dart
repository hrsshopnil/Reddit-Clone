import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/view_model/auth_view_model.dart';
import 'package:reddit_clone/features/community/viewmodel/community_viewmodel.dart';
import 'package:reddit_clone/features/home/view/delegates/search_community_delegate.dart';
import 'package:reddit_clone/features/home/view/drawers/community_list_drawer.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home', style: TextStyle(color: Colors.white)),
        centerTitle: false,
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () => displayDrawer(context),
              icon: Icon(Icons.menu),
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchCommunityDelegate(ref),
              );
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: CircleAvatar(backgroundImage: NetworkImage(user.profilePic)),
          ),
        ],
      ),
      drawer: CommunityListDrawer(),
      body: const Center(child: Text('Home')),
    );
  }
}
