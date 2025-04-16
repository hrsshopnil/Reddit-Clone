import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/widgets/error_text.dart';
import 'package:reddit_clone/core/widgets/loader.dart';
import 'package:reddit_clone/features/auth/view_model/auth_view_model.dart';
import 'package:reddit_clone/features/community/view/widgets/join_button.dart';
import 'package:reddit_clone/features/posts/viewmodel/add_post_viewmodel.dart';
import 'package:reddit_clone/features/user_profile/view_model.dart/edit_profile_viewmodel.dart';
import 'package:routemaster/routemaster.dart';

class UserProfilePage extends ConsumerWidget {
  final String uid;
  const UserProfilePage({super.key, required this.uid});

  void navigateToEditProfile(BuildContext context) {
    Routemaster.of(context).push('/edit_profile/$uid');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref
          .watch(getUserDataProvider(uid))
          .when(
            data:
                (user) => NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        expandedHeight: 250,
                        floating: true,
                        snap: true,
                        flexibleSpace: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.network(
                                user.banner,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              alignment: Alignment.bottomLeft,
                              padding: EdgeInsets.all(20),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(user.profilePic),
                                radius: 35,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            JoinButton(
                              text: 'EditProfile',
                              onPressed: () => navigateToEditProfile(context),
                            ),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'u/${user.name}',
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 10),
                            Text('Karma ${user.karma}'),
                            const SizedBox(height: 10),
                            const Divider(thickness: 1),
                          ]),
                        ),
                      ),
                    ];
                  },
                  body: ref
                      .watch(getUserPostsProviders(uid))
                      .when(
                        data:
                            (data) => ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (BuildContext context, int index) {
                                final post = data[index];
                                return Text(post.title);
                              },
                            ),
                        error: (error, stackTrace) {
                          print(error);
                          return ErrorText(error: error.toString());
                        },
                        loading: () => const Loader(),
                      ),
                ),
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
