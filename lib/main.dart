// @dart=2.9
import 'package:flutter/material.dart';
import 'pengecekan.dart';
import 'package:splashscreen/splashscreen.dart';

main() async {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 5,
      navigateAfterSeconds: new HomeScreen(),
      title: new Text(
        "Mango'S",
        style: new TextStyle(
            fontWeight: FontWeight.bold, fontSize: 30.0, color: Colors.amber),
      ),
      backgroundColor: Colors.white,
      loaderColor: Colors.amber,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Image.asset(
                  "assets/images/walet.png",
                  width: 100.0,
                  height: 100.0,
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.3,
                child: Text(
                  "Pendeteksi Kualitas Buah Mangga.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.amber,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              Container(
                child: SizedBox(
                  width: 200.0,
                  height: 50.0,
                  // ignore: deprecated_member_use
                  child: RaisedButton(
                    color: Colors.amber,
                    elevation: 3,
                    onPressed: () => _pengecekanscreen(context),
                    child: Text(
                      "Mulai Pengecekan",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _pengecekanscreen(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Pengecekan()));
  }
}
