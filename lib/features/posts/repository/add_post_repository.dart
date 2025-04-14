import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/models/post_model.dart';
import 'package:reddit_clone/core/providers/firebase_provider.dart';
import 'package:reddit_clone/core/typedef.dart';
import 'package:reddit_clone/features/community/model/community_model.dart';

final addPostRepositoryProvider = Provider(
  (ref) => AddPostRepository(firebaseFirestore: ref.read(firestoreProvider)),
);

class AddPostRepository {
  final FirebaseFirestore _firebaseFirestore;

  AddPostRepository({required FirebaseFirestore firebaseFirestore})
    : _firebaseFirestore = firebaseFirestore;

  CollectionReference get _posts => _firebaseFirestore.collection('posts');

  FutureVoid addPost(Post post) async {
    try {
      return right(_posts.doc(post.id).set(post.toMap()));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Post>> getUserPosts(List<Community> communities) {
    return _posts
        .where(
          'communityName',
          whereIn: communities.map((e) => e.name).toList(),
        )
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((event) {
          List<Post> posts = [];
          for (var doc in event.docs) {
            posts.add(Post.fromMap(doc.data() as Map<String, dynamic>));
          }
          return posts;
        });
  }
}
