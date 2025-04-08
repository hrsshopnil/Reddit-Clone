import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/providers/firebase_provider.dart';
import 'package:reddit_clone/core/typedef.dart';
import 'package:reddit_clone/features/community/model/community_model.dart';

final communityRepositoryProvider = Provider(
  (ref) => CommunityRepository(firebaseFirestore: ref.read(firestoreProvider)),
);

class CommunityRepository {
  final FirebaseFirestore _firebaseFirestore;

  CommunityRepository({required FirebaseFirestore firebaseFirestore})
    : _firebaseFirestore = firebaseFirestore;

  CollectionReference get _communities =>
      _firebaseFirestore.collection('communities');

  CollectionReference get _users => _firebaseFirestore.collection('users');

  FutureVoid createCommunity(Community community, String uid) async {
    try {
      var communityDoc = await _communities.doc(community.name).get();
      if (communityDoc.exists) {
        throw 'Community with the same name already exists';
      }

      await _communities.doc(community.name).set(community.toMap());

      await _users.doc(uid).update({
        'communities': FieldValue.arrayUnion([community.name]),
      });

      return right(null);
    } on FirebaseException catch (e) {
      return left(Failure(e.message!));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Community>> getUserCommunities(List<String> communities) {
    if (communities.isEmpty) {
      return Stream.value([]);
    }

    return _communities
        .where('id', whereIn: communities)
        .snapshots()
        .map(
          (event) =>
              event.docs
                  .map(
                    (doc) =>
                        Community.fromMap(doc.data() as Map<String, dynamic>),
                  )
                  .toList(),
        );
  }

  Stream<Community> getCommunityByName(String name) {
    return _communities.doc(name).snapshots().map((event) {
      final data = event.data();
      if (data == null) throw Exception('Community not found');
      return Community.fromMap(data as Map<String, dynamic>);
    });
  }
}
