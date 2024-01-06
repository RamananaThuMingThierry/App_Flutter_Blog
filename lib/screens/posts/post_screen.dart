import 'package:blog/api/api_response.dart';
import 'package:blog/constants/constants.dart';
import 'package:blog/models/post.dart';
import 'package:blog/screens/auth/login.dart';
import 'package:blog/services/post_services.dart';
import 'package:blog/services/user_services.dart';
import 'package:flutter/material.dart';

class PostScreens extends StatefulWidget {
  const PostScreens({Key? key}) : super(key: key);

  @override
  State<PostScreens> createState() => _PostScreensState();
}

class _PostScreensState extends State<PostScreens> {
  List<dynamic> _postList = [];
  int userId = 0;
  bool loading = true;

  Future retreivePosts() async{
    userId = await getUserId();
    ApiResponse apiResponse = await getAllPosts();

    if(apiResponse.error == null){
      setState(() {
        _postList = apiResponse.data as List<dynamic>;
        loading = loading ? !loading : loading;
      });

    }else if(apiResponse.error == unauthorized){
      logout().then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${apiResponse.error}")));
    }
  }

  @override
  void initState() {
    retreivePosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _postList.length,
        itemBuilder: (BuildContext context, int index){
          Post post = _postList[index];
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
                                  fontSize: 17
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
                            }else{
                                // Supprimer
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
                SizedBox()
            ]
            )
          );
          },
        );
  }
}
