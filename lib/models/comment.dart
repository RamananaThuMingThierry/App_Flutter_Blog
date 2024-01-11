import 'user.dart';

class Comment{
  int? id;
  String? comment;
  User? user;

  Comment({this.id, this.comment, this.user});

  // Map json to comment Model
  factory Comment.fromJson(Map<String, dynamic> c){
    return Comment(
      id: c['id'],
      comment: c['comment'],
      user: User(
        id: c['user']['id'],
        name: c['user']['name'],
        image: c['user']['image']
      )
    );
  }
}