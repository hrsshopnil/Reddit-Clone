import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/models/post_model.dart';
import 'package:reddit_clone/features/user_profile/repository/edit_profile_repository.dart';

final getUserPostsProviders = StreamProvider.family((ref, String uid) {
  final userProfileViewModel = ref.watch(userProfileViewModelProvider.notifier);
  return userProfileViewModel.getUserPosts(uid);
});

final userProfileViewModelProvider =
    StateNotifierProvider<UserProfileViewmodel, bool>(
      (ref) => UserProfileViewmodel(
        userProfileRepository: ref.watch(userProfileRepositoryProvider),
        ref: ref,
      ),
    );

class UserProfileViewmodel extends StateNotifier<bool> {
  final UserProfileRepository _userProfileRepository;
  final Ref _ref;

  UserProfileViewmodel({
    required UserProfileRepository userProfileRepository,
    required Ref ref,
  }) : _userProfileRepository = userProfileRepository,
       _ref = ref,
       super(false);

  Stream<List<Post>> getUserPosts(String uid) {
    return _userProfileRepository.getUserPosts(uid);
  }
}
