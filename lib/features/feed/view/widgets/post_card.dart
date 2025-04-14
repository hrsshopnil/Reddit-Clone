import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/models/post_model.dart';
import 'package:reddit_clone/core/theme/pallete.dart';
import 'package:reddit_clone/features/auth/view_model/auth_view_model.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final user = ref.watch(userProvider)!;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: currentTheme.drawerTheme.backgroundColor,
          ), // BoxDecoration
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 16,
                      ).copyWith(right: 0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      post.communityProfilePic,
                                    ),
                                    radius: 16,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'r/${post.communityName}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'r/${post.username}',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              if (post.uid == user.uid)
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.delete,
                                    color: Pallete.redColor,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ), // EdgeInsets.symmetric
                    ), // Container
                  ],
                ), // Column
              ), // Expanded
            ],
          ), // Row
        ), // Container
      ],
    );
  }
}
