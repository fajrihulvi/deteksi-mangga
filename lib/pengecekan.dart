import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:flutter/services.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:image/image.dart' as img;
// ignore: import_of_legacy_library_into_null_safe
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class Pengecekan extends StatefulWidget {
  const Pengecekan({ Key? key}) : super(key: key);
  
  @override
  _PengecekanState createState() => _PengecekanState();
}

enum AppState {
  free,
  picked,
  cropped,
}


class _PengecekanState extends State<Pengecekan> {

  File? ambil;
  bool tampilFoto = false;
  img.Image? photo;

  late AppState state;

  @override
  void initState() {
    super.initState();
    state = AppState.free;
  }

  Future<Null> _cropImage() async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: ambil!.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Potong Gambar',
            toolbarColor: Colors.amber,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Potong Gambar',
        ));
    if (croppedFile != null) {
      ambil = croppedFile;
      setState(() {
        state = AppState.cropped;
      });
    }
  }

  Future _getImage() async {
    // ignore: deprecated_member_use
    var image  = await ImagePicker.pickImage(source: ImageSource.camera);
    tampilFoto = true;
    
    // ignore: unnecessary_null_comparison
    if(image != null){
      setState(() {
        ambil = image;
        state = AppState.picked;
      });
    }
    tampilFoto = false;
  }

  void setImageBytes(imageBytes) {
    List<int> values = imageBytes.buffer.asUint8List();
    photo = null;
    photo = img.decodeImage(values);
  }

  int abgrToArgb(int argbColor) {
    int r = (argbColor >> 16) & 0xFF;
    int b = argbColor & 0xFF;
    return (argbColor & 0xFF00FF00) | (b << 16) | r;
  }

  Future<void> _prosesImage() async {

    Uint8List? data;

    try {
      data = await ambil!.readAsBytes();
    } catch (ex) {
      print(ex.toString());
    }

    setImageBytes(data);

    double px = 1.0;
    double py = 0.0;

    int pixel32 = photo!.getPixelSafe(px.toInt(), py.toInt());
    int hex = abgrToArgb(pixel32);

    Color myColor = Color(hex);
    int red = myColor.red.toInt();
    int green = myColor.green.toInt();
    int blue = myColor.blue.toInt();

    var keterangan = 'RGB : ${myColor.red} ; ${myColor.green} ; ${myColor.blue}';

    var total = red + green + blue;

    if(total >= 314 && total <= 498) {
      showAlertDialog(context, "Kluster 1", keterangan);
    } else if(total >= 501 && total <= 598){ 
      showAlertDialog(context, "Kluster 2", keterangan);
    } else if(total >= 601 && total <= 765) {
      showAlertDialog(context, "Kluster 3", keterangan);
    } else {
      showAlertDialog(context, "Harap Foto Ulang Kembali.", keterangan);
    }
  }

  showAlertDialog(BuildContext context, text, keterangan) {

  Widget continueButton = TextButton(
    child: Text("OK"),
    onPressed:  () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Hasil Pengecekan", style: TextStyle(color: Colors.amber),),
    scrollable: true,
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(keterangan),
        Text(text),
      ],
    ),
    actions: [
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Widget _buildButtonIcon() {
    if (state == AppState.free)
      return Icon(Icons.add);
    else if (state == AppState.picked)
      return Icon(Icons.crop);
    else if (state == AppState.cropped)
      return Icon(Icons.clear);
    else
      return Container();
  }

   void _clearImage() {
    ambil = null;
    setState(() {
      state = AppState.free;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: Text("Pengecekan"),
        backgroundColor: Colors.amber,
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.all(20.0),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3,
                // ignore: unnecessary_null_comparison
                child: ambil == null 
                ? (tampilFoto == true) 
                  ? CircularProgressIndicator(color: Colors.amber) 
                  : Image.asset("assets/images/notfound.png")
                : Image.file(ambil!, width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height / 3,)
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 2,
                height: 50.0,
                // ignore: deprecated_member_use
                child: (ambil != null) ? RaisedButton(
                    color: Colors.amber,
                    elevation: 3,
                    onPressed: () => {
                      _prosesImage()
                    },
                    child: Text(
                      "Pengecekan",
                      style: TextStyle(color: Colors.white),
                    ),
                  ) : Text(""),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 3,
        backgroundColor: Colors.amber,
        tooltip: 'Ambil Gambar',
        onPressed: () async {
          if (state == AppState.free)
            _getImage();
          else if (state == AppState.picked)
            _cropImage();
          else if (state == AppState.cropped) 
          _clearImage();
        },
        child: _buildButtonIcon(),
      ),
    );
  }
}