import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';

class ImageWidget extends StatefulWidget {
  final String url;
  final int likes;
  final int views;
  const ImageWidget(
      {super.key, required this.url, required this.likes, required this.views});

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: Colors.deepPurple),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            useSafeArea: false,
            barrierDismissible: true,
            // barrierColor: AppColor.blackColor.withOpacity(0.7),
            builder: (BuildContext context) => Center(
              child: Container(
                width: double.maxFinite,
                // color: AppColor.blackColor,
                child: PhotoView(
                  imageProvider: NetworkImage(
                    widget.url,
                  ),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2,
                  backgroundDecoration: BoxDecoration(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          );
        },
        child: Stack(
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                  width: double.infinity,
                  fit: BoxFit
                      .cover, // This will cover the entire container space
                  imageUrl: widget.url,
                  placeholder: (context, url) => CircleAvatar(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              // left: MediaQuery.of(context).size.width * 0.05,
              child: Container(
                // height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.23,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black87, Colors.transparent],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.heart_broken, color: Colors.red),
                          Text(
                            " ${widget.likes} Likes",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.remove_red_eye, color: Colors.green),
                          Text(
                            " ${widget.views} views",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
