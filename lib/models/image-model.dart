// To parse this JSON data, do
//
//     final imagesModel = imagesModelFromJson(jsonString);

import 'dart:convert';

List<ImagesModel> imagesModelFromJson(String str) => List<ImagesModel>.from(
    json.decode(str).map((x) => ImagesModel.fromJson(x)));

String imagesModelToJson(List<ImagesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ImagesModel {
  String? id;
  String? author;
  int? width;
  int? height;
  String? url;
  String? downloadUrl;

  ImagesModel({
    this.id,
    this.author,
    this.width,
    this.height,
    this.url,
    this.downloadUrl,
  });

  factory ImagesModel.fromJson(Map<String, dynamic> json) => ImagesModel(
        id: json["id"],
        author: json["author"],
        width: json["width"],
        height: json["height"],
        url: json["url"],
        downloadUrl: json["download_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "author": author,
        "width": width,
        "height": height,
        "url": url,
        "download_url": downloadUrl,
      };
}
