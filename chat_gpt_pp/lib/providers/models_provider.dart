import 'package:chat_gpt_pp/models/models_models.dart';
import 'package:chat_gpt_pp/services/api_service.dart';
import 'package:flutter/material.dart';

class ModelsProvider with ChangeNotifier {
  // String currentModel = "text-davinci-003";
  String currentModel = "gpt-3.5-turbo-16k";
  String get getCurrentModel {
    return currentModel;
  }

  void setCurrentModel(String newModel) {
    currentModel = newModel;
    notifyListeners();
  }

  List<ModelsModel> modelList = [];

  List<ModelsModel> get getModelList {
    return modelList;
  }

  Future<List<ModelsModel>> getAllModels() async {
    modelList = await ApiService.getModels();
    return modelList;
  }
}
