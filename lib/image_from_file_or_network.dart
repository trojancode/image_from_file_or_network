library image_from_file_or_network;

import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ImageOrNetWork extends StatefulWidget {
  ImageOrNetWork({
    this.fit,
    this.width,
    this.height,
    this.ext = '.png',
    this.url,
  });

  final BoxFit fit;
  final double width, height;
  final String ext;
  final String url;

  @override
  _ImageOrNetWorkState createState() => _ImageOrNetWorkState();
}

class _ImageOrNetWorkState extends State<ImageOrNetWork> {
  generateFileName(String data) {
    return hex.encode(crypto.md5.convert(Utf8Encoder().convert(data)).bytes) +
        widget.ext;
  }

  File img;

  Future<File> fileFromDocsDir(String filename) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    String pathName = p.join(appDocDir.path, filename);
    return File(pathName);
  }

  Future<String> downloadFile({
    String url,
    String fileName,
    String fileExtension,
    Function(int, int) onReceiveProgress,
  }) async {
    String _url = url;
    Dio dio = Dio();
    final appDocumnetDirectory = await getApplicationDocumentsDirectory();
    final String _filepath =
        '${appDocumnetDirectory.path}/$fileName$fileExtension';

    try {
      Response response = await dio.get(
        _url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) => status < 500,
        ),
        onReceiveProgress: onReceiveProgress,
      );

      if (response.statusCode < 200 && response.statusCode > 226)
        throw HttpException("Server Error");

      File file = File(_filepath);
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      return _filepath;
    } catch (e) {
      throw e;
    }
  }

  getImage() async {
    String imgPath = generateFileName(widget.url);
    File imageFile = await fileFromDocsDir(imgPath + widget.ext);
    if (await imageFile.exists()) {
      print(imageFile.path + "  Exist");
      if (!mounted) return;
      setState(() {
        img = imageFile;
      });
    } else {
      print(imageFile.path + " Not Exist");
      await downloadFile(
        url: widget.url,
        fileName: imgPath,
        fileExtension: widget.ext,
        onReceiveProgress: (cur, tot) {
          print(cur);
          print(tot);
        },
      );
      if (!mounted) return;

      setState(() {
        img = imageFile;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getImage();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      child: img != null
          ? Image.file(
              img,
              height: widget.height,
              width: widget.width,
              fit: widget.fit,
            )
          : Container(),
    );
  }
}
