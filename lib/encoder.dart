import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/views/steganography_app.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/roundedButtton.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:encrypt/encrypt.dart';

class EncoderScreen extends StatefulWidget {
  static String id = 'encoder_screen';
  @override
  _EncoderScreenState createState() => _EncoderScreenState();
}

class _EncoderScreenState extends State<EncoderScreen> {
  //final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  encrypt.Encrypted CiperText;
  String deciper;
  String plainText;
  String password;
  TextEditingController plainTextController = new TextEditingController(text: "");
  TextEditingController ciperTextController = new TextEditingController(text: "");

  String EncryptText() {
//    final plainText = 'some plain text here';
    final key = encrypt.Key.fromUtf8('abcdefghijklmnop');
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
//    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    CiperText = encrypted;
//    print(CiperText);
//    print(encrypted.base64);
  }

  String DecryptText() {
//    final plainText = 'some plain text here';
    final key = encrypt.Key.fromUtf8('abcdefghijklmnop');
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));
//    final encrypted = encrypter.encrypt(PlainText, iv: iv);
    final decrypted = encrypter.decrypt(CiperText, iv: iv);
    deciper = decrypted;
    print(decrypted);
//    print(encrypted.base64);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Encoder Screen"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SteganographyApp()));
            },
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.text,
                textAlign: TextAlign.center,
                controller: ciperTextController,
                style: TextStyle(
                  backgroundColor: Colors.white,
                  color: Colors.black,
                ),
                autofocus: true,
                onChanged: (value) {
                  //Do something with the user input.
                  plainText = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter Text To Encrypt',
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              TextField(
                keyboardType: TextInputType.text,
                textAlign: TextAlign.center,
                controller: plainTextController,
                style: TextStyle(
                  backgroundColor: Colors.white,
                  color: Colors.black,
                ),
                autofocus: true,
                onChanged: (value) {
                  //Do something with the user input.
                  plainText = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Encrypted Text',
                ),
              ),
              RoundedButton(
                title: 'Encrypt',
                colour: Colors.blueAccent,
                onPressed: () async {
                  EncryptText();
                  setState(() {
                    plainTextController.text = CiperText.base64;
                  });
                },
              ),
              SizedBox(
                height: 8.0,
              ),
              RoundedButton(
                title: 'Decrypt',
                colour: Colors.blueAccent,
                onPressed: () async {
                  DecryptText();
                  setState(() {
                    ciperTextController.text = deciper;
                  });
                },
              ),
              SizedBox(
                height: 8.0,
              ),
              CiperText != null
                  ? Column(children: [
                      Container(
                          child: Center(
                        child: Text(
                          "Encrypted Text is: \n${CiperText.base64} ",
                          textAlign: TextAlign.center,
                        ),
                      )),
                      SizedBox(
                        height: 40.0,
                      ),
                      Container(
                          child: Center(
                        child: Text(
                          "Decrypted Text is: \n$deciper ",
                          textAlign: TextAlign.center,
                        ),
                      )),
                    ])
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
