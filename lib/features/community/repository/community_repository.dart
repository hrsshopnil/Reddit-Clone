import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/models/post_model.dart';
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
  CollectionReference get _posts => _firebaseFirestore.collection('posts');

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

    final userCommunities = _communities
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
    return userCommunities;
  }

  Stream<Community> getCommunityByName(String name) {
    return _communities.doc(name).snapshots().map((event) {
      final data = event.data();
      if (data == null) throw Exception('Community not found');
      return Community.fromMap(data as Map<String, dynamic>);
    });
  }

  FutureVoid editCommunity(Community community) async {
    try {
      final updatedCommunity = _communities
          .doc(community.name)
          .update(community.toMap());
      return right(updatedCommunity);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid joinCummuniy(String communityName, String uid) async {
    try {
      await _users.doc(uid).update({
        'communities': FieldValue.arrayUnion([communityName]),
      });
      await _communities.doc(communityName).update({
        'members': FieldValue.arrayUnion([uid]),
      });
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid leaveCummuniy(String communityName, String uid) async {
    try {
      await _users.doc(uid).update({
        'communities': FieldValue.arrayRemove([communityName]),
      });
      await _communities.doc(communityName).update({
        'members': FieldValue.arrayRemove([uid]),
      });
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Community>> searchCommunity(String query) {
    return _communities
        .where(
          'name',
          isGreaterThanOrEqualTo: query.isEmpty ? 0 : query,
          isLessThan: '$query\uf8ff',
        )
        .snapshots()
        .map((event) {
          List<Community> communities = [];
          for (var doc in event.docs) {
            communities.add(
              Community.fromMap(doc.data() as Map<String, dynamic>),
            );
          }
          return communities;
        });
  }

  FutureVoid addMods(String communityName, List<String> uids) async {
    try {
      return right(_communities.doc(communityName).update({'mods': uids}));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Post>> getCommunityPosts(String communityName) {
    return _posts
        .where('communityName', isEqualTo: communityName)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) =>
              event.docs
                  .map((e) => Post.fromMap(e.data() as Map<String, dynamic>))
                  .toList(),
        );
  }
}
