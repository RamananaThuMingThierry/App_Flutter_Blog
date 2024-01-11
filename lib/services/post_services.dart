import 'dart:convert';

import 'package:blog/api/api_response.dart';
import 'package:blog/constants/constants.dart';
import 'package:blog/models/post.dart';
import 'package:blog/services/user_services.dart';
import 'package:http/http.dart' as http;

/** ---------------- Get alL Posts ---------------- **/
Future<ApiResponse> getAllPosts() async{
  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();
    var url = Uri.parse(postsURL);
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
        apiResponse.data = jsonDecode(response.body)['posts'];
        apiResponse.data as List<dynamic>;
        break;
      case 401:
        apiResponse.error = unauthorized;
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

/** --------------- Create Post ----------------- **/
Future<ApiResponse> createPost({String? body, String? image}) async{
  ApiResponse apiResponse = ApiResponse();
  print("Image : ${image == null ? 'oui' : 'non'}");
  try{
    String token = await getToken();
    var url = Uri.parse(postsURL);
    final rep = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization' : 'Bearer $token'
      },
      body: image != null
          ? {
        'body' : body,
        'image' : image,
          }
          :{
        'body': body
      }
    );

    print("Status : ${rep.statusCode}");

    switch(rep.statusCode){
      case 200:
        apiResponse.data = jsonDecode(rep.body);
        break;
      case 422:
        final errors = jsonDecode(rep.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 401:
        apiResponse.error = unauthorized;
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

/** --------------- Update Post ----------------- **/
Future<ApiResponse> updatePost(int postId, String body) async{
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final rep = await http.put(Uri.parse('$postsURL/$postId'),
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $token'
        },
        body: {
          'body': body
        }
    );

    switch(rep.statusCode){
      case 200:
        apiResponse.data = jsonDecode(rep.body)['message'];
        break;
      case 403:
        apiResponse.data = jsonDecode(rep.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
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

/** --------------- Delete Post ----------------- **/
Future<ApiResponse> deletePost(int postId) async{
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final rep = await http.delete(Uri.parse('$postsURL/$postId'),
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $token'
        }
    );

    switch(rep.statusCode){
      case 200:
        apiResponse.data = jsonDecode(rep.body)['message'];
        break;
      case 403:
        apiResponse.data = jsonDecode(rep.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
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

/** ---------- Like or Dislike Post ---------------- **/
Future<ApiResponse> likeUnlikePost(int postId) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();
    var url = Uri.parse('$postsURL/$postId/likes');

    print("url : ${url}");

    final response = await http.post(
      url,
      headers: {
        'Accept' : 'application/json',
        'Authorization' : 'Bearer $token'
      }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
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