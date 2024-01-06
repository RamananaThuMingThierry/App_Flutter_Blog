import 'package:blog/api/api_response.dart';
import 'package:blog/constants/constants.dart';
import 'package:blog/models/user.dart';
import 'package:blog/screens/auth/login.dart';
import 'package:blog/screens/home.dart';
import 'package:blog/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController password_confirmation = TextEditingController();
  bool loading = false;

  void _registerUser() async{
    ApiResponse apiResponse = await register(name.text, email.text, password.text);
    if(apiResponse.error == null){
      _saveAndRedirectToHome(apiResponse.data as User);
    }else{
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${apiResponse.error}')));
    }
  }

  void _saveAndRedirectToHome(User user) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('token', user.token ?? '');
    sharedPreferences.setInt('userId', user.id ?? 0);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Home()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inscription', style: TextStyle(color: Colors.grey),),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          children: [

            TextFormField(
                controller: name,
                validator: (valeur) => valeur!.isEmpty ? 'Nom invalide' : null,
                keyboardType: TextInputType.name,
                decoration: kInputDecoration('Nom')
            ),

            SizedBox(height: 10,),

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

            TextFormField(
                obscureText: true,
                controller: password_confirmation,
                validator: (valeur){
                  if(valeur!.isEmpty){
                    return "Veuillez saisir votre mot de passe !";
                  }else if(valeur != password.text){
                     return 'Les deux mot de passe ne correspond pas!';
                  }else{
                    return null;
                  }
                },
                decoration: kInputDecoration('Confirmer votre mot de passe')
            ),

            SizedBox(height: 20,),
            loading
            ? Center(child: CircularProgressIndicator(),)
            : kTextButton('S\'inscrire', (){
              if(_formKey.currentState!.validate()){
                setState(() {
                  loading = !loading;
                  _registerUser();
                });
              }
            }, Colors.blue),

            SizedBox(height: 10,),

            kLoginOrRegisterHint('Vous avez déjà un compte', 'Se connecter', () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false)),
          ],
        ),
      ),
    );
  }
}
