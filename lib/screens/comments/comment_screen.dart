import 'package:blog/api/api_response.dart';
import 'package:blog/constants/constants.dart';
import 'package:blog/models/comment.dart';
import 'package:blog/screens/auth/login.dart';
import 'package:blog/services/comment_services.dart';
import 'package:blog/services/user_services.dart';
import 'package:flutter/material.dart';

class CommentScreen extends StatefulWidget {
  // Déclaration des variables
  final int? postId;

  CommentScreen({this.postId});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  // Déclarations des variables
  List<dynamic> _commentList = [];
  bool loading = true;
  int userId = 0;
  int _editCommentId = 0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController commentaire = TextEditingController();
  Color? color;

  // Get Comments
  Future<void> _getComments() async{
    userId = await getUserId();

    ApiResponse apiResponse = await getComments(widget.postId ?? 0);
    if(apiResponse.error == null){
      setState(() {
        _commentList = apiResponse.data as List<dynamic>;
        loading = loading ? !loading : loading;
      });
    }else if(apiResponse.error == unauthorized){
      logout().then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${apiResponse.error}")));
    }
  }

  void _createComment() async{
    ApiResponse apiResponse = await createComment(postId: widget.postId ?? 0, comment: commentaire.text);

    if(apiResponse.error == null){
      commentaire.clear();
      _getComments();
    }else if(apiResponse.error == unauthorized){
      logout().then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false));
    }else{
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${apiResponse.error}")));
    }
  }

  void _updateComment() async{
    ApiResponse apiResponse = await updateComment(_editCommentId, commentaire.text);

    if(apiResponse.error == null){
      _editCommentId = 0;
      commentaire.clear();
      _getComments();
    }else if(apiResponse.error == unauthorized){
      logout().then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false));
    }else{
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${apiResponse.error}")));
    }
  }

  void _deleteComment(int commentId) async{
    ApiResponse apiResponse = await deleteComment(commentId);
    if(apiResponse.error == null){
      _getComments();
    }else if(apiResponse.error == unauthorized){
      logout().then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false));
    }else{
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${apiResponse.error}")));
    }
  }

  @override
  void initState() {
    _getComments();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Commentaires"),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator(),)
          : Column(
        children: [
          Expanded(child: RefreshIndicator(
            onRefresh: () => _getComments(),
            child: ListView.builder(
                itemCount: _commentList.length,
                itemBuilder: (BuildContext context, int index){
                    Comment comment = _commentList[index];
                    return Container(
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.black26, width: .5),
                        )
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      image: comment.user!.image != null
                                          ? DecorationImage(image: NetworkImage('${comment.user!.image}'), fit: BoxFit.cover)
                                          : null,
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.blueGrey
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  Text("${comment.user!.name}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
                                ],
                              ),
                              comment.user!.id == userId
                              ? PopupMenuButton(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Icon(Icons.more_vert, color: Colors.black,),
                                ),
                                onSelected: (valeur){
                                  if(valeur == "Modifier"){
                                    // Modifier
                                    setState(() {
                                      _editCommentId = comment.id ?? 0;
                                      commentaire.text = comment.comment ?? '';
                                    });
                                  }else{
                                    // Supprimer
                                    _deleteComment(comment.id ?? 0);
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
                              : SizedBox()
                            ],
                          ),
                          SizedBox(height: 10,),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            child: Text("${comment.comment}"),)
                        ],
                      ),
                    );
                }),
          )),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.black26, width: .5),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                    child: TextFormField(
                      decoration: kInputDecoration("Commentaires"),
                      controller: commentaire,
                      onChanged: (value){
                          if(value.isEmpty){
                            setState(() {
                              color = Colors.grey;
                            });
                          }else{
                            setState(() {
                              color= Colors.blue;
                            });
                          }
                      },
                    ),
                ),
                IconButton(onPressed: () {
                  if(commentaire.text.isNotEmpty){
                    setState(() {
                      loading = true;
                    });
                    _editCommentId == 0
                    ? _createComment()
                    : _updateComment();
                  }
                }, icon: Icon(Icons.send, color: color))
              ],
            ),
          )
        ],
      )
    );
  }
}
