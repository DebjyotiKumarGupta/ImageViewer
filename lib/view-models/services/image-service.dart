import 'package:newapp/models/image-model.dart';
import 'package:newapp/resources/app-url.dart';
import 'package:newapp/view-models/networks/network-api-services.dart';

class ImageServices {
  final _api = NetworkAPiServices();
  Future<dynamic> getImagesServices() async {
    final response = await _api.getApi(AppUrl.getImages);
    return response;
  }
}
