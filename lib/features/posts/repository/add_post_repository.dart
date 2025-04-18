import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/core/failure.dart';
import 'package:reddit_clone/core/models/post_model.dart';
import 'package:reddit_clone/core/providers/firebase_provider.dart';
import 'package:reddit_clone/core/typedef.dart';
import 'package:reddit_clone/features/community/model/community_model.dart';
import 'package:reddit_clone/features/posts/model/comment_model.dart';

final addPostRepositoryProvider = Provider(
  (ref) => AddPostRepository(firebaseFirestore: ref.read(firestoreProvider)),
);

class AddPostRepository {
  final FirebaseFirestore _firebaseFirestore;

  AddPostRepository({required FirebaseFirestore firebaseFirestore})
    : _firebaseFirestore = firebaseFirestore;

  CollectionReference get _posts => _firebaseFirestore.collection('posts');
  CollectionReference get _users => _firebaseFirestore.collection('users');
  CollectionReference get _comments =>
      _firebaseFirestore.collection('comments');

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
          print(posts);
          return posts;
        });
  }

  FutureVoid deletePost(String postId) async {
    try {
      await _posts.doc(postId).delete();
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  void upvote(Post post, String uid) async {
    if (post.upvotes.contains(uid)) {
      _posts.doc(post.id).update({
        'upvotes': FieldValue.arrayRemove([uid]),
      });
    } else if (post.downvotes.contains(uid)) {
      _posts.doc(post.id).update({
        'downvotes': FieldValue.arrayRemove([uid]),
        'upvotes': FieldValue.arrayUnion([uid]),
      });
    } else {
      _posts.doc(post.id).update({
        'upvotes': FieldValue.arrayUnion([uid]),
      });
    }
  }

  void downvote(Post post, String uid) async {
    if (post.downvotes.contains(uid)) {
      _posts.doc(post.id).update({
        'downvotes': FieldValue.arrayRemove([uid]),
      });
    } else if (post.upvotes.contains(uid)) {
      _posts.doc(post.id).update({
        'upvotes': FieldValue.arrayRemove([uid]),
        'downvotes': FieldValue.arrayUnion([uid]),
      });
    } else {
      _posts.doc(post.id).update({
        'downvotes': FieldValue.arrayUnion([uid]),
      });
    }
  }

  Stream<Post> getPostById(String id) {
    return _posts.doc(id).snapshots().map((event) {
      final data = event.data();
      if (data == null) throw Exception('Post not found');
      return Post.fromMap(data as Map<String, dynamic>);
    });
  }

  FutureVoid addComment(Comment comment) async {
    try {
      await _comments.doc(comment.id).set(comment.toMap());

      return right(
        _posts.doc(comment.postId).update({
          'commentCount': FieldValue.increment(1),
        }),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Comment>> getCommentsByPost(String postId) {
    return _comments
        .where('postId', isEqualTo: postId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) =>
              event.docs
                  .map((e) => Comment.fromMap(e.data() as Map<String, dynamic>))
                  .toList(),
        );
  }

  FutureVoid awardPost(Post post, String award, String senderId) async {
    try {
      _posts.doc(post.id).update({
        'awards': FieldValue.arrayUnion([award]),
      });
      _users.doc(senderId).update({
        'awards': FieldValue.arrayRemove([award]),
      });
      return right(
        _users.doc(post.uid).update({
          'awards': FieldValue.arrayUnion([award]),
        }),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
