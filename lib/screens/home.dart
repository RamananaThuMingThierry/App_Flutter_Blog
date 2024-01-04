import 'package:blog/screens/auth/login.dart';
import 'package:blog/services/user_services.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acceuil'),
        actions: [
          IconButton(
              onPressed: () => logout().then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false)),
              icon: Icon(Icons.logout))
        ],
      ),
    );
  }
}
