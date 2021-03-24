import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'dart:convert';
import 'package:http_parser/http_parser.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File _image;
  var imageBytes;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() async {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        imageBytes = await _image.readAsBytes();

        uploadImage(pickedFile.path, imageBytes);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Example'),
      ),
      body: Center(
        child: _image == null ? Text('No image selected.') : Image.file(_image),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}

void uploadImage(String imageFilePath, imageBytes) async {
  String url = "https://backend.dosparkles.com/upload";
  PickedFile imageFile = PickedFile(imageFilePath);
  var stream = new http.ByteStream(imageFile.openRead());
  stream.cast();

  var uri = Uri.parse(url);
  int length = imageBytes.length;
  var request = new http.MultipartRequest("POST", uri);
  var multipartFile = new http.MultipartFile(
    'files',
    stream,
    length,
    filename: basename(imageFile.path),
    contentType: MediaType('image', 'png'),
  );

  request.files.add(multipartFile);
  var response = await request.send();
  print(response.statusCode);
  response.stream.transform(utf8.decoder).listen((value) {
    print(value);
  });
}
