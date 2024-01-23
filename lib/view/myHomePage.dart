import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:newapp/view-models/controller/image-controller.dart';
import 'package:newapp/view-models/response.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ImageController _imageController = Get.put(ImageController());
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _scrollController.addListener(() async {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          await _imageController.loadMore();
        }
      });
      await _imageController.loadMore();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget returnContainer(String url) {
      return Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.deepPurple),
          child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  useSafeArea: false,
                  barrierDismissible: true,
                  // barrierColor: AppColor.blackColor.withOpacity(0.7),
                  builder: (BuildContext context) => Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.62,
                      width: double.maxFinite,
                      // color: AppColor.blackColor,
                      child: PhotoView(
                        imageProvider: NetworkImage(
                          url,
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
              child: CachedNetworkImage(
                  // height: 100,
                  // width: 100,
                  fit: BoxFit.cover,
                  imageUrl: url,
                  placeholder: (context, url) => CircleAvatar(
                        // specify your desired height
                        child: CircularProgressIndicator(),
                      ),
                  errorWidget: (context, url, error) => Icon(Icons.error))));
    }

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Expert's Choice "),
      ),
      body: Obx(
        () => GridView.builder(
            controller: _scrollController,
            itemCount: _imageController.items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio:
                  1.0, // This will force the children Widgets to retain their intrinsic aspect ratio
            ),
            itemBuilder: (context, index) {
              return returnContainer(_imageController.items[index]);
            }),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
