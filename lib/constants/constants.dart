import 'package:flutter/material.dart';

/** ------------- String -----------**/

const baseURL = 'http://192.168.1.107:8000/api';
const loginURL = baseURL + '/login';
const registerURL = baseURL + '/register';
const logoutURL = baseURL + '/logout';
const userURL = baseURL + '/user';
const postsURL = baseURL + '/posts';
const commentsURL = baseURL + '/comments';

/** -------------- Erreurs -------------- **/
const serverError = 'Erreur du serveur';
const unauthorized = 'Non autorisé';
const somethingWentWrong = 'Quelque chose s\'est mal passé! essaie encore';

/** --------------- Input Decoration ---------------- **/

InputDecoration kInputDecoration(String label){
  return  InputDecoration(
    labelText: label,
    contentPadding: EdgeInsets.symmetric(horizontal: 5),
  );
}

/** -------------- Button --------------------- **/

TextButton kTextButton(String label, Function onPressed, Color? color){
  return TextButton(
    child: Text(label, style: TextStyle(color: Colors.white),),
    style: ButtonStyle(
      backgroundColor: MaterialStateColor.resolveWith((states) => color!),
      padding: MaterialStateProperty.resolveWith((states) => EdgeInsets.symmetric(vertical: 10))
    ),
    onPressed: () => onPressed(),
  );
}

Row kLoginOrRegisterHint(String text, String label, Function onTap){
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(text),
      SizedBox(width: 5,),
      GestureDetector(
        child: Text(label, style: TextStyle(color: Colors.blue),),
        onTap: () => onTap(),
      ),
    ],
  );
}

Expanded KBtnLikesOrComment({int? value, required Function onTap, IconData? iconData, Color? color}){
  return Expanded(
      child: Material(
        child: InkWell(
          onTap: () => onTap(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(iconData, size: 16, color: color,),
                SizedBox(width: 4,),
                Text("$value")
              ],
            ),
          ),
        ),
      ));
}