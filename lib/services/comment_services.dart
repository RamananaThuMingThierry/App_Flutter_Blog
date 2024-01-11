import 'dart:convert';

import 'package:blog/api/api_response.dart';
import 'package:blog/constants/constants.dart';
import 'package:blog/services/user_services.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> getComments(int postId) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();
    var url = Uri.parse("$postsURL/$postId/comments");

    print("*---------------- Url : $url");
    final response = await http.get(url,
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $token'
        }
    );
    print(response.statusCode);

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['comments'];
        apiResponse.data as List<dynamic>;
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  }catch(e){
    apiResponse.error = serverError;
  }
  return apiResponse;
}