import 'dart:convert';

import 'package:com.floridainc.dosparkles/actions/api/graphql_client.dart';
import 'package:com.floridainc.dosparkles/utils/general.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

import 'package:multi_image_picker/multi_image_picker.dart';

class MyImagePickerPage extends StatefulWidget {
  @override
  _MyImagePickerPageState createState() => _MyImagePickerPageState();
}

class _MyImagePickerPageState extends State<MyImagePickerPage> {
  List<Asset> images = <Asset>[];
  String _error = 'No Error Dectected';

  @override
  void initState() {
    super.initState();
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    _sendRequest(resultList);

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  void _sendRequest(imagesList) async {
    Uri uri = Uri.parse('https://backend.dosparkles.com/upload');

    MultipartRequest request = http.MultipartRequest("POST", uri);

    for (var i = 0; i < imagesList.length; i++) {
      var asset = imagesList[i];

      ByteData byteData = await asset.getByteData();
      List<int> imageData = byteData.buffer.asUint8List();

      MultipartFile multipartFile = MultipartFile.fromBytes(
        'files',
        imageData,
        filename: '${asset.name}',
        contentType: MediaType("image", "jpg"),
      );
      request.files.add(multipartFile);
    }

    http.Response response =
        await http.Response.fromStream(await request.send());
    List imagesResponse = json.decode(response.body);
    var listOfIds = imagesResponse.map((image) => "\"${image['id']}\"");
    //await BaseGraphQLClient.instance.addOrderImagesDetails(listOfIds.toList());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
            Center(child: Text('Error: $_error')),
            ElevatedButton(
              child: Text("Pick images"),
              onPressed: loadAssets,
            ),
            Expanded(
              child: buildGridView(),
            )
          ],
        ),
      ),
    );
  }
}
