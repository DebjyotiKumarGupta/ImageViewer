import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:newapp/models/image-model.dart';
import 'package:newapp/view-models/controller/image-controller.dart';
import 'package:newapp/view-models/response.dart';
import 'package:flutter/material.dart';
import 'package:newapp/view/widgets/imageWidget.dart';

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
  final ImageController _imageController = Get.put(ImageController());
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _scrollController.addListener(() async {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          _imageController.page.value++;
          await _imageController.loadMore(
              category: _imageController.searchController.value.text,
              page: _imageController.page.value);
        }
      });
      await _imageController.loadMore(
          category: _imageController.searchController.value.text,
          page: _imageController.page.value);
    });
  }

  @override
  Widget build(BuildContext context) {
// Debouncing logic
    Timer? _debounce;

    Future<void> _onSearchChanged() async {
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () async {
        _imageController.imageData.value.hits = null;
        await _imageController.loadMore(
            category: _imageController.searchController.value.text, page: 1);
      });
    }

    @override
    void dispose() {
      _debounce?.cancel();
      super.dispose();
    }

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0), // Set the AppBar height
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(20), // Round the bottom right corner
            bottomLeft: Radius.circular(20), // Round the bottom left corner
          ),
          child: Container(
            color: Theme.of(context).colorScheme.inversePrimary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Text("Expert's Choice"),
                Container(
                  margin: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: TextFormField(
                    controller: _imageController.searchController.value,
                    onChanged: (val) {
                      _onSearchChanged();
                    },
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Obx(
        () => (_imageController.imageData.value.hits == null &&
                _imageController.rxStatusValue.value == Status.LOADING)
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  _imageController.imageData.value.hits!.isNotEmpty
                      ? Expanded(
                          child: GridView.builder(
                            controller: _scrollController,
                            // itemCount: 1,
                            itemCount:
                                _imageController.imageData.value.hits!.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              childAspectRatio:
                                  1.0, // This will force the children Widgets to retain their intrinsic aspect ratio
                            ),
                            itemBuilder: (context, index) {
                              Hit imageInfo =
                                  _imageController.imageData.value.hits![index];
                              return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ImageWidget(
                                      likes: imageInfo.likes!,
                                      views: imageInfo.views!,
                                      url: imageInfo.largeImageUrl!));
                            },
                          ),
                        )
                      : const Center(
                          child: Text(
                            "No Image Found",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                  if (_imageController.rxStatusValue.value == Status.LOADING)
                    const Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(child: CircularProgressIndicator()),
                    )
                ],
              ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
