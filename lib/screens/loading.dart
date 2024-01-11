import 'package:blog/api/api_response.dart';
import 'package:blog/constants/constants.dart';
import 'package:blog/screens/auth/login.dart';
import 'package:blog/screens/home.dart';
import 'package:blog/services/user_services.dart';
import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override

  void _loadUserInfo() async{
    String token = await getToken();
    if(token == ''){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (ctx) => Login()), (route) => false);
    }else{
      ApiResponse apiResponse = await getUserDetail();
      if(apiResponse.error == null){
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (ctx) => Home()), (route) => false);
      }else if(apiResponse.error == unauthorized){
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (ctx) => Login()), (route) => false);
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${apiResponse.error}')));
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _loadUserInfo();
    super.initState();
  }
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: Center(
        child: CircularProgressIndicator(
          color: Colors.green,
        ),
      ),
    );
  }
}
