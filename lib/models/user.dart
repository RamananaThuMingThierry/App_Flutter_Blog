class User{

  int? id;
  String? name;
  String? email;
  String? image;
  String? token;

  User({
    this.id,
    this.name,
    this.email,
    this.image,
    this.token
  });

  // function to convert json data to user model
  factory  User.fromJson(Map<String, dynamic> j){
    return User(
      id: j['user']['id'],
      name: j['user']['name'],
      email: j['user']['email'],
      image: j['user']['image'],
      token: j['token'],
    );
  }
}