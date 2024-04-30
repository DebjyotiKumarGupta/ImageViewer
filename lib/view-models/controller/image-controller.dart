// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newapp/models/image-model.dart';
import 'package:newapp/view-models/response.dart';
import 'package:newapp/view-models/services/image-service.dart';

class ImageController extends GetxController {
  final _api = ImageServices();
  RxBool loading = false.obs;
  RxInt page = 1.obs;
  Rx<Status> rxStatusValue = Status.LOADING.obs;
  setRxStatusValue(Status statusVal) {
    rxStatusValue.value = statusVal;
  }

  Rx<TextEditingController> searchController = TextEditingController().obs;

  Rx<ImageData> imageData = ImageData().obs;
  void setImageDataAgain(ImageData data) =>
      imageData.value.hits?.addAll(data.hits!);
  void setImageDataInit(ImageData data) => imageData.value = data;

  RxString lastCategory = "".obs;

  Future<void> loadMore({required String category, required int page}) async {
    rxStatusValue.value = Status.LOADING;
    loading.value = true;
    try {
      ImageData response = await _api.getImagesServices(
          q: category.isEmpty ? "flower" : category, page: page);

      if (lastCategory.value == category && imageData.value.hits != null) {
        setImageDataAgain(response);
      } else {
        lastCategory.value = category;
        setImageDataInit(response);
      }

      rxStatusValue.value = Status.COMPLETED;
    } catch (e) {
      rxStatusValue.value = Status.ERROR;
      Get.snackbar("Unable to Load", "Sorry there is some error in loading");
    }
  }
}
