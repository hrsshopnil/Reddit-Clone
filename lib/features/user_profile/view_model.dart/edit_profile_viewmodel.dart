import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/user_profile/repository/edit_profile_repository.dart';

class UserProfileViewmodel extends StateNotifier<bool> {
  final UserProfileRepository _userProfileRepository;
  final Ref _ref;

  UserProfileViewmodel({
    required UserProfileRepository userProfileRepository,
    required Ref ref,
  }) : _userProfileRepository = userProfileRepository,
       _ref = ref,
       super(false);
}
