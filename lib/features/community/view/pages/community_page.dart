import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/widgets/error_text.dart';
import 'package:reddit_clone/core/widgets/loader.dart';
import 'package:reddit_clone/features/auth/view_model/auth_view_model.dart';
import 'package:reddit_clone/features/community/model/community_model.dart';
import 'package:reddit_clone/features/community/view/widgets/join_button.dart';
import 'package:reddit_clone/features/community/viewmodel/community_viewmodel.dart';
import 'package:reddit_clone/features/feed/view/widgets/post_card.dart';
import 'package:routemaster/routemaster.dart';

class CommunityPage extends ConsumerWidget {
  final String name;
  const CommunityPage({required this.name, super.key});

  void navigateToModTools(BuildContext context) {
    Routemaster.of(context).push('/mod-tools/$name');
  }

  void joinCommunity(WidgetRef ref, Community community, BuildContext context) {
    ref
        .read(communityViewModelProvider.notifier)
        .joinCommunity(community, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(userProvider)?.uid ?? '';

    return Scaffold(
      body: ref
          .watch(getCommunityByNameProvider(name))
          .when(
            data:
                (community) => NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        expandedHeight: 150,
                        floating: true,
                        snap: true,
                        flexibleSpace: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.network(
                                community.banner,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ).copyWith(top: 8),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            Align(
                              alignment: Alignment.topLeft,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(community.avatar),
                                radius: 35,
                              ),
                            ),
                            //const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'r/${community.name}',
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                community.mods.contains(userId)
                                    ? JoinButton(
                                      text: 'Mod Tools',
                                      onPressed:
                                          () => navigateToModTools(context),
                                    )
                                    : community.members.contains(userId)
                                    ? JoinButton(
                                      text: 'Joined',
                                      onPressed:
                                          () => joinCommunity(
                                            ref,
                                            community,
                                            context,
                                          ),
                                    )
                                    : JoinButton(
                                      text: 'Join',
                                      onPressed:
                                          () => joinCommunity(
                                            ref,
                                            community,
                                            context,
                                          ),
                                    ),
                              ],
                            ),
                            Text('${community.members.length} members'),
                          ]),
                        ),
                      ),
                    ];
                  },
                  body: ref
                      .watch(getCommunityPostsProvider(name))
                      .when(
                        data:
                            (data) => ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (BuildContext context, int index) {
                                final post = data[index];
                                return PostCard(post: post);
                              },
                            ),
                        error:
                            (error, stackTrace) =>
                                ErrorText(error: error.toString()),

                        loading: () => const Loader(),
                      ),
                ),
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
