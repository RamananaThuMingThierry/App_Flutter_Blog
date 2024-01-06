import 'user.dart';

class Post{

  int? id;
  String? body;
  String? image;
  int? likesCount;
  int? commentsCount;
  User? user;
  bool? selfLiked;

  Post({
    this.id,
    this.body,
    this.image,
    this.likesCount,
    this.commentsCount,
    this.user,
    this.selfLiked
  });

  // Map json to post model
  factory Post.fromJson(Map<String, dynamic> p){
    return Post(
      id: p['id'],
      body: p['body'],
      image: p['image'],
      likesCount: p['likes_count'],
      commentsCount: p['comments_count'],
      user: User(
        id: p['user']['id'],
        name: p['user']['name'],
        image: p['user']['image'],
      ),
      selfLiked: p['likes'].length > 0,
    );
  }
}