import 'package:blog/api/api_response.dart';
import 'package:blog/constants/constants.dart';
import 'package:blog/models/post.dart';
import 'package:blog/screens/auth/login.dart';
import 'package:blog/screens/comments/comment_screen.dart';
import 'package:blog/screens/posts/post_form.dart';
import 'package:blog/services/post_services.dart';
import 'package:blog/services/user_services.dart';
import 'package:flutter/material.dart';

class PostScreens extends StatefulWidget {
  const PostScreens({Key? key}) : super(key: key);

  @override
  State<PostScreens> createState() => _PostScreensState();
}

class _PostScreensState extends State<PostScreens> {
  List<Post> _postList = [];
  int userId = 0;
  bool loading = true;

  Future retreivePosts() async{
    userId = await getUserId();
    ApiResponse apiResponse = await getAllPosts();

    if(apiResponse.error == null){
      List<dynamic> postList = apiResponse.data as List<dynamic>;
      List<Post> posts = postList.map((p) => Post.fromJson(p)).toList();
      setState(() {
        _postList = posts;
         loading = loading ? !loading : loading;
      });

    }else if(apiResponse.error == unauthorized){
      logout().then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${apiResponse.error}")));
    }
  }

  // Post like or dislike
  void handlePostLikeDislike(int postId) async {

    ApiResponse apiResponse = await likeUnlikePost(postId);
    print("Je suis là");
    if(apiResponse.error == null){
      retreivePosts();
    }else if(apiResponse.error == unauthorized){
      logout().then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${apiResponse.error}")));
    }
  }

  // Delete Post
  void handleDeletePost(int postId) async{
    ApiResponse response = await deletePost(postId);
    if(response.error == null){
      retreivePosts();
    }else if(response.error == unauthorized){
      logout().then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${response.error}")));
    }
  }

  @override
  void initState() {
    retreivePosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Center(child: CircularProgressIndicator(),)
        : RefreshIndicator(
          onRefresh: () {
            return retreivePosts();
          },
          child: ListView.builder(
          itemCount: _postList!.length,
          itemBuilder: (BuildContext context, int index){
            Post post = _postList![index];
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            child: Row(
                              children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    image: post.user!.image != null 
                                        ? DecorationImage(image: NetworkImage('${post.user!.image}')) : null,
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.amber
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Text(
                                  "${post.user!.name}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14
                                  ),
                                )
                              ],
                            ),
                        ),
                        post.user!.id == userId
                            ?
                        PopupMenuButton(
                            child: Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(Icons.more_vert, color: Colors.black,),
                            ),
                            onSelected: (valeur){
                              if(valeur == "Modifier"){
                                  // Modifier
                                  Navigator.push(context, MaterialPageRoute(builder: (ctx) => PostForm(titre: "Modifier Post",post: post, nomBtnActin: "Modifier")));
                              }else{
                                  // Supprimer
                                handleDeletePost(post.id ?? 0);
                              }
                            },
                            itemBuilder: (ctx) => [
                              PopupMenuItem(
                                  child: Text("Modifier"),
                                  value: "Modifier",
                              ),
                              PopupMenuItem(
                                  child: Text("Supprimer"),
                                  value: "Supprimer",
                              )
                      ],
                    )
                            :
                        SizedBox()
                      ],
                    ),
              SizedBox(height: 12,),
              Text("${post.body}"),
              post.image != null
                  ?
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 180,
                    margin: EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage('${post.image}'),
                            fit: BoxFit.cover
                        ),
                  )
                  )
                  :
                  SizedBox(height: post!.image == null ? 0 : 10,),
                  Row(
                    children: [
                      KBtnLikesOrComment(
                          value: post.likesCount ?? 0,
                          onTap: (){
                              print("Nous somme là!");
                              handlePostLikeDislike(post.id ?? 0);
                          },
                          iconData: post.selfLiked == true ? Icons.favorite : Icons.favorite_outline,
                          color: post.selfLiked == true ? Colors.red : Colors.grey),
                      Container(
                        height: 40,
                        width: .5,
                        color: Colors.black38,
                      ),
                      KBtnLikesOrComment(value: post.commentsCount, onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (ctx) => CommentScreen(postId: post.id,)));
                      }, iconData: Icons.comment, color: Colors.grey),
                    ],
                  ),
                  Container(
                    height: .5,
                    color: Colors.black38,
                    width: MediaQuery.of(context).size.width,
                  ),
                ]
              )
            );
            },
          ),
        );
  }

}
