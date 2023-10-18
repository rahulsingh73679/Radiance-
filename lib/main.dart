
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:radiance/helper/helper_function.dart';
import 'package:radiance/pages/auth/login_page.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:radiance/shared/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:io';

import 'package:webview_flutter/webview_flutter.dart';
// flutter build apk --build-name=1.0.3 --build-number=3
  
//  flutter pub get
//  flutter pub run flutter_launcher_icons:main

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: Constants.apiKey,
            appId: Constants.appId,
            messagingSenderId: Constants.messagingSenderId,
            projectId: Constants.projectId));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    getUserLoggedInStatus();
  }

  getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInStatus().then((value) {
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Constants().primaryColor,
          scaffoldBackgroundColor: Colors.white),
      debugShowCheckedModeBanner: false,
      home: _isSignedIn ?  SplashScreen() :  SplashScreen1(),
    );
  }
}


//  flutter build apk --build-name=0.0.1 --build-number=1

class WebViewExample extends StatefulWidget {
  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}
class _WebViewExampleState extends State<WebViewExample> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  bool _isLoading = true;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Radiance"),
        titleSpacing: 00.0,
        centerTitle: true,
        toolbarHeight: 60.2,
        toolbarOpacity: 0.8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
        ),
        elevation: 0.00,
        backgroundColor: Color.fromARGB(255, 11, 167, 192),
      ), //AppBar
      body: Stack(
        children: [
          Offstage(
            offstage: _isLoading || _isError,
            child: WebView(
              initialUrl: "https://r1pns.github.io/RiteshPrakash/",
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              onPageStarted: (String url) {
                setState(() {
                  _isLoading = true;
                  _isError = false;
                });
                print('Page started loading: $url');
              },
              onPageFinished: (String url) {
                setState(() {
                  _isLoading = false;
                });
                print('Page finished loading: $url');
              },
              navigationDelegate: (NavigationRequest request) {
                if (request.url.startsWith(
                    "https://drive.google.com/file/d/1XBTiLnI7yg6BJssQYjicaT-sXSuTv5KY/view?usp=drivesdk")) {
                  print('blocking navigation to $request}');
                  return NavigationDecision.prevent;
                }
                print('allowing navigation to $request');
                return NavigationDecision.navigate;
              },
              gestureNavigationEnabled: true,
            ),
          ),
          Offstage(
            offstage:   !_isError,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/no.jpg',
                    width: 150,
                    height: 150,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No internet connection',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Offstage(
            offstage: !_isLoading,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}


// splashscreen trial 

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Timer(Duration(seconds: 5),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> WebViewExample()));
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    height = height / 100;
    width = width / 100;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: height * 50,
                  width: MediaQuery.of(context).size.width - 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      image: new DecorationImage(
                          image: AssetImage("assets/splash.gif"),fit: BoxFit.cover)
                  ),
                ),
                SizedBox(height: height * 5,),
                AnimatedTextKit(
                  animatedTexts: [
                    WavyAnimatedText(
                        "Radiance",textStyle: GoogleFonts.paytoneOne(color: Color(0xff0C7277),fontSize: height * 4,fontWeight: FontWeight.w200)
                    ),
                  ],
                  isRepeatingAnimation: true,
                ),
              ],
            )
        ),
      ),
    );
  }
}



// first splashscreen which will appear before login screeen 

class SplashScreen1 extends StatefulWidget {
  @override
  _SplashScreen1State createState() => _SplashScreen1State();
}
class _SplashScreen1State extends State<SplashScreen1> {

  @override
  void initState() {
    Timer(Duration(seconds: 6),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginPage()));
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    height = height / 100;
    width = width / 100;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: height * 50,
                  width: MediaQuery.of(context).size.width - 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      image: new DecorationImage(
                          image: AssetImage("assets/splash.gif"),fit: BoxFit.cover)
                  ),
                ),
                SizedBox(height: height * 5,),
                AnimatedTextKit(
                  animatedTexts: [
                    WavyAnimatedText(
                        "Radiance",textStyle: GoogleFonts.paytoneOne(color: Color(0xff0C7277),fontSize: height * 4,fontWeight: FontWeight.w200)
                    ),
                  ],
                  isRepeatingAnimation: true,
                ),
              ],
            )
        ),
      ),
    );
  }
}
