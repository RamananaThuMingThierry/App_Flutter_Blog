import 'package:blog/screens/auth/login.dart';
import 'package:blog/screens/posts/post_form.dart';
import 'package:blog/screens/posts/post_screen.dart';
import 'package:blog/screens/profiles/profiles.dart';
import 'package:blog/services/user_services.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Déclarations des variables
  int? currentIndex = 0;
  String? title = "Acceuil";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$title'),
        backgroundColor: Colors.blueGrey,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () => logout().then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false)),
              icon: Icon(Icons.logout))
        ],
      ),
      body: currentIndex == 0 ? PostScreens() : Profiles(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => PostForm(titre: "Ajouter une Post", nomBtnActin: "Enregistre",)), (route) => false),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        notchMargin: 5,
        elevation: 5,
        clipBehavior: Clip.antiAlias,
        shape: CircularNotchedRectangle(),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home,),
                label: ''
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person,),
                label: ''
            ),
          ],
          currentIndex: currentIndex!,
          onTap: (valeur) => setState(() {
            currentIndex = valeur;
            if(currentIndex == 0){
              setState(() {
                title = "Acceuil";
              });
            }else{
              setState(() {
                title = "Apropos";
              });
            }
          }),
        ),
      ),
    );
  }
}
