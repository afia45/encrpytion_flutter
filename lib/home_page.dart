import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var textController = TextEditingController();
  String? encryptedMessage;
  String? decryptedMessage;

  final initVector=encrypt.IV.fromLength(16);
  final encrypter= encrypt.Encrypter(encrypt.AES(encrypt.Key.fromUtf8("16characterslong")));

  void encryptMessage(){
    final plainText=textController.text;
    if(plainText.isNotEmpty){
      final encrypted=encrypter.encrypt(plainText,iv:initVector);
      
      setState(() {
      encryptedMessage=encrypted.base64;
    });
    }

    
  }

  void decryptMessage(){
    if(encryptedMessage!=null){
      final encryptedData=encrypt.Encrypted.fromBase64(encryptedMessage!);
      final decrypted= encrypter.decrypt(encryptedData, iv: initVector);

      setState(() {
        decryptedMessage=decrypted;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Encrypt message", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: textController,
              decoration: InputDecoration(
                labelText: "Enter your message"
              ),
            ),
          ),
          SizedBox(height: 20,),
          ElevatedButton(onPressed: (){
            encryptMessage();
          }, 
          child: Text("Encrypt Message"),
          
          ),

          if(encryptedMessage!=null) ...[
            SizedBox(height: 20,),
            Text("Encrypted Message", style: TextStyle(
              fontWeight: FontWeight.bold
            ),),
            SizedBox(height: 20,),
            Text(encryptedMessage!, style: TextStyle(color: Colors.green),),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: (){
              decryptMessage();
            }, child: Text("Decrypt Message"),),
            if(decryptedMessage!=null) ...[
              SizedBox(height: 20,),
            Text("Decrypted Message", style: TextStyle(
              fontWeight: FontWeight.bold
            ),),
            SizedBox(height: 20,),
            Text(decryptedMessage!, style: TextStyle(color: Colors.blue),),

          ]]
        ],
      ),

    );
  }
}