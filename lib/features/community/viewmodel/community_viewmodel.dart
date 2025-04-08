import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/view_model/auth_view_model.dart';
import 'package:reddit_clone/features/community/model/community_model.dart';
import 'package:reddit_clone/features/community/repository/community_repository.dart';

final userCommunitiesProvider = StreamProvider<List<Community>>((ref) {
  final user = ref.watch(userProvider);
  if (user == null) return const Stream.empty();

  final communityRepo = ref.watch(communityRepositoryProvider);
  return communityRepo.getUserCommunities(user.communities);
});

final communityViewModelProvider =
    StateNotifierProvider<CommunityViewmodel, bool>(
      (ref) => CommunityViewmodel(
        communityRepository: ref.watch(communityRepositoryProvider),
        ref: ref,
      ),
    );

final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  return ref
      .watch(communityViewModelProvider.notifier)
      .getCommunityByName(name);
});

class CommunityViewmodel extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final Ref _ref;

  CommunityViewmodel({
    required CommunityRepository communityRepository,
    required Ref ref,
  }) : _communityRepository = communityRepository,
       _ref = ref,
       super(false);

  void createCommunity(String name, BuildContext context) async {
    state = true;

    final user = _ref.read(userProvider);
    if (user == null) {
      showSnackBar(context, 'User not logged in');
      state = false;
      return;
    }

    Community community = Community(
      id: name,
      name: name,
      banner: Constants.bannerDefault,
      avatar: Constants.avatarDefault,
      members: [user.uid],
      mods: [user.uid],
    );

    final res = await _communityRepository.createCommunity(community, user.uid);

    state = false;

    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Navigator.pop(context),
    );
  }

  // Only used by getCommunityByNameProvider now
  Stream<Community> getCommunityByName(String name) {
    return _communityRepository.getCommunityByName(name);
  }
}
