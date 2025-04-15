import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/models/post_model.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/view_model/auth_view_model.dart';
import 'package:reddit_clone/features/community/model/community_model.dart';
import 'package:reddit_clone/features/posts/repository/add_post_repository.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

final addPostViewModelProvider = StateNotifierProvider<AddPostViewmodel, bool>(
  (ref) => AddPostViewmodel(
    addPostRepository: ref.watch(addPostRepositoryProvider),
    ref: ref,
  ),
);

final getUserPostsProvider = StreamProvider.family((
  ref,
  List<Community> communities,
) {
  final addPostViewModel = ref.watch(addPostViewModelProvider.notifier);
  return addPostViewModel.getUserPosts(communities);
});

class AddPostViewmodel extends StateNotifier<bool> {
  final AddPostRepository _addPostRepository;
  final Ref _ref;

  AddPostViewmodel({
    required AddPostRepository addPostRepository,
    required Ref ref,
  }) : _addPostRepository = addPostRepository,
       _ref = ref,
       super(false);

  void shareTextPost(
    BuildContext context,
    String title,
    Community community,
    String description,
  ) async {
    state = true;
    String postId = const Uuid().v1();

    final user = _ref.read(userProvider)!;

    final Post post = Post(
      id: postId,
      title: title,
      communityName: community.name,
      communityProfilePic: community.avatar,
      upvotes: [],
      downvotes: [],
      commentCount: 0,
      username: user.name,
      uid: user.uid,
      type: 'text',
      createdAt: DateTime.now(),
      awards: [],
      description: description,
    );

    final res = await _addPostRepository.addPost(post);

    state = false;

    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Routemaster.of(context).pop(),
    );
  }

  void shareLinkPost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required String link,
  }) async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;

    final Post post = Post(
      id: postId,
      title: title,
      communityName: selectedCommunity.name,
      communityProfilePic: selectedCommunity.avatar,
      upvotes: [],
      downvotes: [],
      commentCount: 0,
      username: user.name,
      uid: user.uid,
      type: 'link',
      createdAt: DateTime.now(),
      awards: [],
      link: link,
    );

    final res = await _addPostRepository.addPost(post);
    //_ref.read(userProfileControllerProvider.notifier).updateUserKarma(UserKarma.linkPost);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Posted successfully!');
      Routemaster.of(context).pop();
    });
  }

  Stream<List<Post>> getUserPosts(List<Community> communities) {
    if (communities.isNotEmpty) {
      return _addPostRepository.getUserPosts(communities);
    }
    return Stream.value([]);
  }

  void deletePost(BuildContext context, String postId) async {
    state = true;
    final res = await _addPostRepository.deletePost(postId);
    state = false;

    res.fold((l) => null, (r) => null);
  }

  void upvote(Post post) {
    final uid = _ref.read(userProvider)!.uid;
    _addPostRepository.upvote(post, uid);
  }

  void downvote(Post post) {
    final uid = _ref.read(userProvider)!.uid;
    _addPostRepository.downvote(post, uid);
  }
}
