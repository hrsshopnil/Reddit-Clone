import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/view_model/auth_view_model.dart';
import 'package:reddit_clone/features/community/model/community_model.dart';
import 'package:reddit_clone/features/community/repository/community_repository.dart';

final userCommunitiesProvider = StreamProvider<List<Community>>((ref) {
  final communityViewModel = ref.watch(communityViewModelProvider.notifier);
  return communityViewModel.getUserCommunities();
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
    final uid = _ref.read(userProvider)?.uid ?? '';
    Community community = Community(
      id: name,
      name: name,
      banner: Constants.bannerDefault,
      avatar: Constants.avatarDefault,
      members: [uid],
      mods: [uid],
    );

    final res = await _communityRepository.createCommunity(community);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Navigator.pop(context),
    );
  }

  Stream<List<Community>> getUserCommunities() {
    final user = _ref.read(userProvider)!;
    return _communityRepository.getUserCommunities(user.communities);
  }

  Stream<Community> getCommunityByName(String name) {
    return _communityRepository.getCommunityByName(name);
  }
}
