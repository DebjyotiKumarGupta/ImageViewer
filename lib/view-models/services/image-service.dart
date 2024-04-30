import 'package:newapp/models/image-model.dart';
import 'package:newapp/resources/app-url.dart';
import 'package:newapp/view-models/networks/network-api-services.dart';

class ImageServices {
  final _api = NetworkAPiServices();
  Future<ImageData> getImagesServices(
      {required String q, int perPage = 10, required int page}) async {
    final response = await _api
        .getApi("${AppUrl.imageUrl}&q=$q&per_page=$perPage&page=$page");
    return ImageData.fromJson(response);
  }
}
