import 'package:blog/api/api_response.dart';
import 'package:blog/constants/constants.dart';
import 'package:blog/models/user.dart';
import 'package:blog/screens/auth/register.dart';
import 'package:blog/screens/home.dart';
import 'package:blog/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool loading = false;

  void _saveAndRedirectToHome(User user) async{
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setString('token', user.token ?? '');
      await sharedPreferences.setInt('userId', user.id ?? 0);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Home()), (route) => false);
  }

  void loginUser() async{
    ApiResponse apiResponse = await login(email.text, password.text);
    if(apiResponse.error == null){
      _saveAndRedirectToHome(apiResponse.data as User);
    }else{
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${apiResponse.error}')));
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login', style: TextStyle(color: Colors.grey),),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          children: [
            TextFormField(
              controller: email,
              validator: (valeur) => valeur!.isEmpty ? 'Adresse e-mail invalide' : null,
              keyboardType: TextInputType.emailAddress,
              decoration: kInputDecoration('Adresse e-mail')
            ),

            SizedBox(height: 10,),

            TextFormField(
                  obscureText: true,
                  controller: password,
                  validator: (valeur) => valeur!.isEmpty ? 'Mot de passe invalide' : null,
                  decoration: kInputDecoration('Mot de passe')
            ),

            SizedBox(height: 10,),

            loading
            ? Center(
              child: CircularProgressIndicator(),
            )
            : kTextButton('Login', (){
              if(_formKey.currentState!.validate()){
                  setState(() {
                    loading = true;
                    loginUser();
                  });
              }
            }, Colors.blue),

            SizedBox(height: 10,),

            kLoginOrRegisterHint('Je n\'ai pas de compte', 'S\'inscire', () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Register()), (route) => false)),
          ],
        ),
      ),
    );
  }
}
