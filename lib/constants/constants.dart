import 'package:flutter/material.dart';

/** ------------- String -----------**/

const baseURL = 'http://192.168.1.107:8000/api';
const loginURL = baseURL + '/login';
const registerURL = baseURL + '/register';
const logoutURL = baseURL + '/logout';
const userURL = baseURL + '/user';
const postsURL = baseURL + '/posts';
const comments = baseURL + '/comments';

/** -------------- Erreurs -------------- **/
const serverError = 'Erreur du serveur';
const unauthorized = 'Non autorisé';
const somethingWentWrong = 'Quelque chose s\'est mal passé essaie encore';

/** --------------- Input Decoration ---------------- **/

InputDecoration kInputDecoration(String label){
  return  InputDecoration(
    labelText: label,
    contentPadding: EdgeInsets.symmetric(horizontal: 5),
  );
}

/** -------------- Button --------------------- **/

TextButton kTextButton(String label, Function onPressed){
  return TextButton(
    child: Text(label, style: TextStyle(color: Colors.white),),
    style: ButtonStyle(
      backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blue),
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