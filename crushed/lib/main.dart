import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


void main()=>runApp(new MyApp());

class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    return new MaterialApp(
        home: new LoginPage(),
        theme: new ThemeData(
            primarySwatch: Colors.blue
        )
    );
  }

}

_makePostRequest(String data) async {  // set up POST request arguments
  String url = 'http://10.88.255.130:5000/';
  Map<String, String> headers = {"Content-type": "application/json"};
  String json = '{"imageb64": ${data}}';  // make POST request
  Response response = await post(url, headers: headers, body: json);  // check the status code for the result
  int statusCode = response.statusCode;  // this API passes back the id of the new item added to the body
  String body = response.body;
  print('\nAPI RESPONSE:$body');


  // var server=await HttpServer.bind(InternetAddress.loopbackIPv4,8080);
  //print('Listening :${server.port}');
  //await for (HttpRequest request in server)
  // {
  //  request.response.write('Hello');
  // await request.response.close();
  // }

}
class PickImageDemo extends StatefulWidget {
  PickImageDemo() : super();

  final String title = "Waste Classify:";

  @override
  _PickImageDemoState createState() => _PickImageDemoState();
}

class _PickImageDemoState extends State<PickImageDemo> {
  Future<File> imageFile;


  pickImageFromGallery(ImageSource source) {
    setState(() async {
      File pickedImage = await ImagePicker.pickImage(
          source: source
      );
      List<int> test = pickedImage.readAsBytesSync();
      imageFile = ImagePicker.pickImage(source: source);

      String test2 = base64Encode(test);
      print('ok:${test2}:ok');
      _makePostRequest(test2);



    });


  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: imageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return Image.file(
            snapshot.data,
            width: 300,
            height: 300,
          );
        } else if (snapshot.error != null) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            showImage(),
            RaisedButton(
              child: Text("Select Image from Gallery"),
              onPressed: () {
                pickImageFromGallery(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }
}


class LoginPage extends StatefulWidget
{
  @override
  State createState()=>new LoginPageState();
}

class LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin
{
  AnimationController _iconAnimationController;
  Animation<double> _iconAnimation;

  @override
  void initState()
  {
    super.initState();
    _iconAnimationController =new AnimationController
      (vsync: this, duration: new Duration(milliseconds: 300));
    _iconAnimation = new CurvedAnimation(parent: _iconAnimationController, curve: Curves.easeOut);
    _iconAnimation.addListener(()=>this.setState(() {}));
    _iconAnimationController.forward();
  }

  @override
  Widget build(BuildContext context)
  {
    return new Scaffold
      (
      backgroundColor: Colors.greenAccent,
      body: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          new Image(
            image: new AssetImage("assets/image1.jpg"),
            fit: BoxFit.cover,
            color: Colors.black87,
            colorBlendMode: BlendMode.darken,
          ),

          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new FlutterLogo(
                size: _iconAnimation.value *100.0,
              ),
              new Form(
                child: new Theme(
                  data: new ThemeData(
                    brightness: Brightness.dark,
                    primarySwatch: Colors.teal,
                    inputDecorationTheme: new InputDecorationTheme(
                      labelStyle: new TextStyle(
                          color: Colors.teal,fontSize: 20.0
                      ),
                    ),
                  ),
                  child: new Container(
                    padding: const EdgeInsets.all(40.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new TextFormField(
                          decoration: new InputDecoration(
                            labelText: "Enter Email:",
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        new TextFormField(
                          decoration: new InputDecoration(
                            labelText: "Enter Password",
                          ),
                          keyboardType: TextInputType.text,
                          obscureText: true,
                        ),
                        new Padding(padding: EdgeInsets.only(top:20.0)),
                        new MaterialButton(
                          color: Colors.teal,
                          textColor: Colors.white,
                          child: new Text("LogIn"),
                          onPressed: () {
                            //Use`Navigator` widget to push the second screen to out stack of screens
                            Navigator.of(context)
                                .push(MaterialPageRoute<Null>(builder: (BuildContext context) {
                              return new PickImageDemo();
                            }));
                          },
                          splashColor: Colors.limeAccent,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}