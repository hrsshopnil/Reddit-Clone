import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reddit_clone/core/models/user_model.dart';
import 'package:reddit_clone/core/utils.dart';
import 'package:reddit_clone/features/auth/repository/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);
final userRef = FirebaseFirestore.instance.collection('users');

final userStreamProvider = StreamProvider.family<UserModel?, String>((
  ref,
  uid,
) {
  final user = userRef
      .doc(uid)
      .snapshots()
      .map((event) => UserModel.fromMap(event.data()!))
      .distinct(
        (prev, next) =>
            const DeepCollectionEquality().equals(prev.toMap(), next.toMap()),
      );
  return user;
});

final authViewModelProvider = StateNotifierProvider<AuthViewModel, bool>(
  (ref) => AuthViewModel(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  ),
);

final authStateChangeProvider = StreamProvider((ref) {
  final authViewModel = ref.watch(authViewModelProvider.notifier);
  return authViewModel.authStateChange;
});

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authViewModel = ref.watch(authViewModelProvider.notifier);
  return authViewModel.getUserData(uid);
});

class AuthViewModel extends StateNotifier<bool> {
  final AuthRepository _authRepository;

  final Ref _ref;
  AuthViewModel({required AuthRepository authRepository, required Ref ref})
    : _authRepository = authRepository,
      _ref = ref,
      super(false);

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  void signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInWithGoogle();
    state = false;
    user.fold(
      (l) => showSnackBar(context, l.message),
      (user) => _ref.read(userProvider.notifier).update((state) => user),
    );
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  void signInAsGuest(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInAsGuest();
    state = false;
    user.fold(
      (l) => showSnackBar(context, l.message),
      (userModel) =>
          _ref.read(userProvider.notifier).update((state) => userModel),
    );
  }

  void logout() async {
    _authRepository.logout();
  }
}
