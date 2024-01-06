import 'package:flutter/material.dart';

class PostScreens extends StatefulWidget {
  const PostScreens({Key? key}) : super(key: key);

  @override
  State<PostScreens> createState() => _PostScreensState();
}

class _PostScreensState extends State<PostScreens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Text("Posts..."),
      ),
    );
  }
}
