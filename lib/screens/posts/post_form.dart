import 'dart:io';
import 'dart:math';

import 'package:blog/api/api_response.dart';
import 'package:blog/constants/constants.dart';
import 'package:blog/models/post.dart';
import 'package:blog/screens/auth/login.dart';
import 'package:blog/screens/home.dart';
import 'package:blog/services/post_services.dart';
import 'package:blog/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

class PostForm extends StatefulWidget {
  final Post? post;
  final String? titre;
  final String? nomBtnActin;

  PostForm({this.post, this.titre, this.nomBtnActin});

  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  /** ---------- Déclarations des variables ---------------- **/
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController body = TextEditingController();
  bool loading = false;
  File? imageFile = null;
  final _picker = ImagePicker();

  Future getImage() async{
    final pickerFile = await _picker.pickImage(source: ImageSource.gallery);
    if(pickerFile != null){
        setState(() {
          imageFile = File(pickerFile.path);
        });
    }
  }

  void _createPost() async {
    String? image = imageFile == null ? null : getStringImage(imageFile);
     ApiResponse apiResponse = await createPost(body: body.text,image: image);
    if(apiResponse.error == null){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Home()), (route) => false);
    }else if(apiResponse.error == unauthorized){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false);
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${apiResponse.error}")));
      setState(() {
        loading = !loading;
      });
    }
  }

  void _editPost(int postId) async{
    ApiResponse apiResponse = await updatePost(postId, body.text);

    if(apiResponse.error == null){

      Navigator.pop(context);

    }else if(apiResponse.error == unauthorized){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false);
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${apiResponse.error}")));
      setState(() {
        loading = !loading;
      });
    }
  }

  @override
  void initState() {
    if(widget.post != null){
      body.text = widget.post!.body! ?? '';
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text("${widget.titre}", style: TextStyle(color: Colors.grey),),
        centerTitle: true,
      ),
      body: loading
      ? Center(
        child: CircularProgressIndicator(),
      )
      : ListView(
        children: [
          widget.post != null
              ? SizedBox()
              : Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            decoration: BoxDecoration(
              image: imageFile == null 
                  ? null
                  : DecorationImage(
                  image: FileImage(imageFile ?? File('')),
                  fit: BoxFit.cover
              ),
            ),
            child: Center(
              child: IconButton(
                icon: Icon(Icons.image, size: 50, color: Colors.black38,),
                onPressed: (){
                  getImage();
                },
              ),
            ),
          ),
          Form(
              key: _formKey,
              child: Padding(
                 padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                 child: TextFormField(
                   controller: body,
                   keyboardType: TextInputType.multiline,
                   maxLines: 9,
                   validator: (value) =>
                     value!.isEmpty
                     ? "Veuillez remplir ce champ!"
                     : null,
                   decoration: kInputDecoration("Body"),
                 ),
              ),
          ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: kTextButton("${widget.nomBtnActin}", (){
                if(_formKey.currentState!.validate()){
                  setState(() {
                    loading = !loading;
                  });
                  widget.post == null ? _createPost() : _editPost(widget.post!.id ?? 0);
                }
              }, Colors.blue),
            ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: kTextButton("Annuler", () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Home()), (route) => false), Colors.red),
              ),
            ],
      ),
    );
  }
}
