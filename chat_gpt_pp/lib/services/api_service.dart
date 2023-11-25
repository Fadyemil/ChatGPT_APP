// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chat_gpt_pp/constants/api_constants.dart';
import 'package:chat_gpt_pp/models/chat_model.dart';
import 'package:chat_gpt_pp/models/models_models.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<List<ModelsModel>> getModels() async {
    try {
      var response = await http.get(
        Uri.parse("$BASE_URL/models"),
        headers: {'Authorization': 'Bearer $API_KEY'},
      );
      Map jsonResponse = jsonDecode(response.body);
      if (jsonResponse['error'] != null) {
        // print("jsonResponse['error'] ${jsonResponse['error']["message"]}");
        throw HttpException(jsonResponse['error']["message"]);
      }
      log('jsonResponse : ${jsonResponse}');
      List temp = [];
      for (var value in jsonResponse['data']) {
        temp.add(value);
        log("temp ${value["id"]}");
      }
      return ModelsModel.modelsFromSnapshot(temp);
    } catch (e) {
      log("error $e");
      rethrow;
    }
  }

  // send Message using ChatGPT API
  static Future<List<ChatModel>> sendMessageGPT(
      {required String message, required String modelID}) async {
    try {
      var response = await http.post(
        Uri.parse("$BASE_URL/chat/completions"),
        headers: {
          'Authorization': 'Bearer $API_KEY',
          "Content-Type": "application/json",
        },
        body: jsonEncode(
          {
            "model": modelID,
            "messages": [
              {
                "role": "user",
                "content": message,
              }
            ]
          },
        ),
      );
      Map jsonResponse = jsonDecode(response.body);
      if (jsonResponse['error'] != null) {
        // print("jsonResponse['error'] ${jsonResponse['error']["message"]}");
        throw HttpException(jsonResponse['error']["message"]);
      }
      List<ChatModel> chatList = [];
      if (jsonResponse["choices"].length > 0) {
        //  log("=====================json === = =  ${jsonResponse["choices"][0]["prompt"]}");
        chatList = List.generate(
            jsonResponse["choices"].length,
            (index) => ChatModel(
                msg: jsonResponse["choices"][index]["message"]["content"], chatIndex: 1));
      }
      return chatList;
    } catch (e) {
      // log("error ====== $e");
      rethrow;
    }
  }

  // send Message fct
  static Future<List<ChatModel>> sendMessage(
      {required String message, required String modelID}) async {
    try {
      var response = await http.post(
        Uri.parse("$BASE_URL/completions"),
        headers: {
          'Authorization': 'Bearer $API_KEY',
          "Content-Type": "application/json",
        },
        body: jsonEncode(
          {
            "model": modelID,
            "prompt": message,
            "max_tokens": 300,
          },
        ),
      );
      Map jsonResponse = jsonDecode(response.body);
      if (jsonResponse['error'] != null) {
        // print("jsonResponse['error'] ${jsonResponse['error']["message"]}");
        throw HttpException(jsonResponse['error']["message"]);
      }
      List<ChatModel> chatList = [];
      if (jsonResponse["choices"].length > 0) {
        //  log("=====================json === = =  ${jsonResponse["choices"][0]["prompt"]}");
        chatList = List.generate(
            jsonResponse["choices"].length,
            (index) => ChatModel(
                msg: jsonResponse["choices"][index]["text"], chatIndex: 1));
      }
      return chatList;
    } catch (e) {
      // log("error ====== $e");
      rethrow;
    }
  }
}
