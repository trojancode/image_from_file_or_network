# image_from_file_or_network

A flutter package used to display images from url

## Example

This project is a flutter package that providers a widget called `ImageOrNetwork`. This widget requires a url and ext. 
It downloads image from the url and save it in a unique name and display. It automatically display the image when the same url is used any where in the app, widget reloads, or app restarted.

`Examle`

```dart
  import 'package:image_from_file_or_network/image_from_file_or_network.dart';

  ImageOrNetWork(
    fit: BoxFit.cover,//@required
    url: url, // url is a string type @required.
    ext:'.png', //not required and default is png
    height: 183, //@required
    width:  127, //@required
  );
```

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
