import 'dart:io';

import 'package:blog/api/api_response.dart';
import 'package:blog/constants/constants.dart';
import 'package:blog/models/user.dart';
import 'package:blog/screens/auth/login.dart';
import 'package:blog/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Profiles extends StatefulWidget {
  const Profiles({Key? key}) : super(key: key);

  @override
  State<Profiles> createState() => _ProfilesState();
}

class _ProfilesState extends State<Profiles> {
  @override
  User? users;
  bool loading = true;
  File? imageFile;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  final _picker = ImagePicker();

  Future getImage() async{
    final pickerFile = await _picker.pickImage(source: ImageSource.gallery);
    if(pickerFile != null){
      setState(() {
        imageFile = File(pickerFile.path);
      });
    }
  }

  void getUsers() async{
    ApiResponse apiResponse = await getUserDetail();
    print("ApiResponse : ${apiResponse.error}");
    if(apiResponse.error == null){
      setState(() {
        users = apiResponse.data as User?;
        name.text = users!.name ?? '';
        loading = false;
      });
      print("users: ${users!.name}");
    }else if(apiResponse.error == unauthorized){
      logout().then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${apiResponse.error}")));
    }
  }

  void updateProfile() async{
    ApiResponse apiResponse = await updateUser(name.text, getStringImage(imageFile));
    setState(() {
      loading = false;
    });
    if(apiResponse.error == null){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${apiResponse.data}")));
    }else if(apiResponse.error == unauthorized){
      logout().then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${apiResponse.error}")));
    }
  }

  @override
  void initState() {
    getUsers();
    super.initState();
  }
  Widget build(BuildContext context) {
    return loading
        ? Center(child: CircularProgressIndicator(),)
        : Padding(
        padding: EdgeInsets.only(top: 40, left: 40, right: 40),
        child: ListView(
          children: [
            Center(
              child: GestureDetector(
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    image: imageFile == null
                        ? users!.image != null
                                ? DecorationImage(image: NetworkImage('${users!.image}'), fit: BoxFit.cover)
                                : null
                        : DecorationImage(
                            image: FileImage(imageFile ?? File('')),
                            fit: BoxFit.cover
                    ),
                    color: Colors.amber
                  ),
                ),
                onTap: (){
                  getImage();
                },
              ),
            ),
            SizedBox(height: 20,),
            Form(
                key: _formKey,
                child: TextFormField(
                decoration: kInputDecoration("Nom"),
                  controller: name,
                  validator: (valeur) => valeur!.isEmpty ? 'Nom invalid' : null,
            )),
            SizedBox(height: 20,),
            kTextButton("Modifier", (){
                if(_formKey.currentState!.validate()){
                  setState(() {
                    loading = true;
                  });
                  updateProfile();
                }
            }, Colors.blue),
          ],
        ),

    );
  }
}
