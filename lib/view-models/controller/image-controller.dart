import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:newapp/models/image-model.dart';
import 'package:newapp/view-models/response.dart';
import 'package:newapp/view-models/services/image-service.dart';

class ImageController extends GetxController {
  final _api = ImageServices();
  RxBool loading = false.obs;
  Rx<Status> rxStatusValue = Status.LOADING.obs;
  setRxStatusValue(Status statusVal) {
    rxStatusValue.value = statusVal;
  }

  RxList<ImagesModel> imagesData = <ImagesModel>[].obs;
  void setImageData(ImagesModel data) => imagesData.add(data);

  RxList items = <String>[].obs;

  Future<void> loadMore() async {
    rxStatusValue.value = Status.LOADING;
    loading.value = true;
    try {
      final response = await _api.getImagesServices();
      // setImageData(response);
      print("data got set");
      List<String> newItems = (response as List)
          .map((data) => data['download_url'] as String)
          .toList();

      items.addAll(newItems);
      rxStatusValue.value = Status.COMPLETED;
    } catch (e) {
      rxStatusValue.value = Status.ERROR;
      Get.snackbar("Unable to Load", "Sorry there is some error in loading");
    }
  }
}
