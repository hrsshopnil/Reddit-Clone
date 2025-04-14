import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/models/user_model.dart';
import 'package:reddit_clone/core/providers/firebase_provider.dart';
import 'package:reddit_clone/core/typedef.dart';

final userProfileRepositoryProvider = Provider(
  (ref) =>
      UserProfileRepository(firebaseFirestore: ref.read(firestoreProvider)),
);

class UserProfileRepository {
  final FirebaseFirestore _firebaseFirestore;

  UserProfileRepository({required FirebaseFirestore firebaseFirestore})
    : _firebaseFirestore = firebaseFirestore;

  CollectionReference get _user => _firebaseFirestore.collection('users');

  FutureVoid editCommunity(UserModel user) async {
    try {
      final updatedUser = _user.doc(user.uid).update(user.toMap());
      return right(updatedUser);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
