import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_steganography/decoder.dart';
import 'package:flutter_steganography/encoder.dart';
import 'package:flutter_steganography/requests/decode_request.dart';
import 'package:flutter_steganography/requests/encode_request.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flash_chat/components/roundedButtton.dart';
import 'package:flash_chat/constants.dart';
import 'dart:io';

class SteganographyApp extends StatefulWidget {
  static String id = 'img_screen';
  @override
  _SteganographyAppState createState() => _SteganographyAppState();
}

class _SteganographyAppState extends State<SteganographyApp> {
  File _image;
  String hiddenMessage;
  Uint8List encryptedImage;

  TextEditingController textController = new TextEditingController(text: "");

  getImage(bool isCamera) async {
    File image;

    if (isCamera) {
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    } else {
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    }

    setState(() {
      _image = image;
    });
  }

  _hideMessage() {
// the key is use to encrypt your message with AES256 algorithm

    print("----------");
    EncodeRequest request = EncodeRequest(_image.readAsBytesSync(), hiddenMessage, key: "123456");

    Uint8List response = encodeMessageIntoImage(request);

    setState(() {
      encryptedImage = response;
    });

    print(response);
  }

  _getHiddenMessage() async {
    if (encryptedImage != null) {
      DecodeRequest request = DecodeRequest(encryptedImage, key: "123456");

//    String response = decodeMessageFromImage(request);
      String response = await decodeMessageFromImageAsync(request);

      print("=========");
      print(response);

      setState(() {
        hiddenMessage = response;
        textController.text = hiddenMessage;
      });
    }
  }

  Widget displayImg() {
    if (_image == null && encryptedImage == null) {
      return Container();
    } else if (encryptedImage != null) {
      return Image.memory(
        encryptedImage,
        height: 300,
        width: 400,
      );
    } else {
      return Image.file(
        _image,
        height: 200,
        width: 300,
      );
    }
  }

  Widget displayText() {
    if (encryptedImage == null && hiddenMessage != null) {
      return Container();
    }

    return Column(children: [
      SizedBox(
        height: 40.0,
      ),
      Container(
          child: Center(
        child: Text(
          "Decrypted Text is: \n$hiddenMessage ",
          textAlign: TextAlign.center,
        ),
      )),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Steganography"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              FlatButton(
                textColor: Theme.of(context).primaryColor,
                child: Text('Use Camera'),
                onPressed: () {
                  getImage(true);
                },
              ),
              FlatButton(
                textColor: Theme.of(context).primaryColor,
                child: Text('Select Image From Gallery'),
                onPressed: () {
                  getImage(false);
                },
              ),
              Column(
                children: [
                  displayImg(),
                  TextField(
                    controller: textController,
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      backgroundColor: Colors.white,
                      color: Colors.black,
                    ),
                    autofocus: true,
                    onChanged: (value) {
                      //Do something with the user input.
                      hiddenMessage = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Encrypted Text',
                    ),
                  ),
                  RoundedButton(
                    title: 'Hide message',
                    colour: Colors.blueAccent,
                    onPressed: () async {
                      _hideMessage();
                    },
                  ),
                  RoundedButton(
                    title: 'Get Hidden Message',
                    colour: Colors.blueAccent,
                    onPressed: () async {
                      _getHiddenMessage();
                    },
                  ),
                  displayText(),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
