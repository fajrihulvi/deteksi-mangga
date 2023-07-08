// @dart=2.9
import 'dart:typed_data';

import 'package:image/image.dart' as img;
// ignore: unnecessary_import
import 'package:flutter/rendering.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

main() {
  runApp(MaterialApp(home: ColorDetect()));
}

class ColorDetect extends StatefulWidget {
  //static const routeName = '/';

  @override
  _ColorDetectState createState() => _ColorDetectState();
}

class _ColorDetectState extends State<ColorDetect> {
  final coverData = 'http://berita-sulsel.com/wp-content/uploads/2018/07/Manfaat-Sarang-Burung-Walet.jpg';
  img.Image photo;

  void setImageBytes(imageBytes) {
    List<int> values = imageBytes.buffer.asUint8List();
    photo = null;
    photo = img.decodeImage(values);
  }

  // image lib uses uses KML color format, convert #AABBGGRR to regular #AARRGGBB
  int abgrToArgb(int argbColor) {
    int r = (argbColor >> 16) & 0xFF;
    int b = argbColor & 0xFF;
    return (argbColor & 0xFF00FF00) | (b << 16) | r;
  }

  Future<Color> _getColor() async {
    Uint8List data;

    try {
      data = (await NetworkAssetBundle(Uri.parse(coverData)).load(coverData))
          .buffer
          .asUint8List();
    } catch (ex) {
      print(ex.toString());
    }

    setImageBytes(data);

    double px = 1.0;
    double py = 0.0;

    int pixel32 = photo.getPixelSafe(px.toInt(), py.toInt());
    int hex = abgrToArgb(pixel32);
    print("Value of int: $hex ");
    
    Color myColor = Color(hex);
    print ('red: ${myColor.red} green: ${myColor.green} blue: ${myColor.blue}');
    return Color(hex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(coverData),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: FutureBuilder(
                future: _getColor(),
                builder: (_, AsyncSnapshot<Color> data) {
                  if (data.connectionState == ConnectionState.done) {
                    return Container(
                      color: data.data,
                    );
                  }
                  return CircularProgressIndicator();
                }),
          ),
          Spacer(),
        ],
      ),
    );
  }
}
