import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/models/post_model.dart';
import 'package:reddit_clone/core/widgets/error_text.dart';
import 'package:reddit_clone/core/widgets/loader.dart';
import 'package:reddit_clone/features/auth/view_model/auth_view_model.dart';
import 'package:reddit_clone/features/feed/view/widgets/post_card.dart';
import 'package:reddit_clone/features/posts/view/widgets/comment_card.dart';
import 'package:reddit_clone/features/posts/viewmodel/add_post_viewmodel.dart';

class CommentsPage extends ConsumerStatefulWidget {
  final String postId;
  const CommentsPage({super.key, required this.postId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentsPageState();
}

class _CommentsPageState extends ConsumerState<CommentsPage> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  void addComment(Post post) {
    ref
        .read(addPostViewModelProvider.notifier)
        .addComment(
          context: context,
          text: commentController.text.trim(),
          post: post,
        );
    setState(() {
      commentController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    return Scaffold(
      appBar: AppBar(),
      body: ref
          .watch(getPostByIdProvider(widget.postId))
          .when(
            data: (data) {
              return Column(
                children: [
                  PostCard(post: data),
                  if (!isGuest)
                    TextField(
                      onSubmitted: (val) => addComment(data),
                      controller: commentController,
                      decoration: const InputDecoration(
                        hintText: 'What are your thoughts?',
                        filled: true,
                        border: InputBorder.none,
                      ),
                    ),
                  ref
                      .watch(getCommentsByPostProvider(widget.postId))
                      .when(
                        data: (data) {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (BuildContext context, int index) {
                                final comment = data[index];
                                return CommentCard(comment: comment);
                              },
                            ),
                          );
                        },
                        error: (error, stackTrace) {
                          return ErrorText(error: error.toString());
                        },
                        loading: () => const Loader(),
                      ),
                ],
              );
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
