
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          highlightColor: const Color(0xFFD0996F),
          canvasColor: const Color(0xFFFDF5EC),
          textTheme: TextTheme(
            headlineSmall: ThemeData.light()
                .textTheme
                .headlineSmall!
                .copyWith(color: const Color(0xFFBC764A)),
          ),
          iconTheme: IconThemeData(
            color: Colors.grey[600],
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFBC764A),
            centerTitle: false,
            foregroundColor: Colors.white,
            actionsIconTheme: IconThemeData(color: Colors.white),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateColor.resolveWith(
                  (states) => const Color(0xFFBC764A)),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: ButtonStyle(
              foregroundColor: MaterialStateColor.resolveWith(
                (states) => const Color(0xFFBC764A),
              ),
              side: MaterialStateBorderSide.resolveWith(
                  (states) => const BorderSide(color: Color(0xFFBC764A))),
            ),
          ), colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(background: const Color(0xFFFDF5EC))),
      home: const MyHomePage(title: 'Image Cropper Demo'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 700) {
      return _HomePage(
        key: const ValueKey('desktop'),
        title: title,
        displayStyle: PageDisplayStyle.desktop,
      );
    } else {
      return _HomePage(
        key: const ValueKey('mobile'),
        title: title,
        displayStyle: PageDisplayStyle.mobile,
      );
    }
  }
}

enum PageDisplayStyle {
  desktop,
  mobile,
}

class _HomePage extends StatefulWidget {
  final PageDisplayStyle displayStyle;
  final String title;

  const _HomePage({
    Key? key,
    required this.displayStyle,
    required this.title,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  String? _uploadedBlobUrl;
  String? _croppedBlobUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.displayStyle == PageDisplayStyle.mobile
          ? AppBar(title: Text(widget.title))
          : null,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.displayStyle == PageDisplayStyle.desktop)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Text(
                widget.title,
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(color: Theme.of(context).highlightColor),
              ),
            ),
          Expanded(child: _body()),
        ],
      ),
    );
  }

  Widget _body() {
    if (_croppedBlobUrl != null || _uploadedBlobUrl != null) {
      return _imageCard();
    } else {
      return _uploaderCard();
    }
  }

  Widget _imageCard() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
            elevation: 4.0,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: _image(),
            ),
          ),
          const SizedBox(height: 24.0),
          _menu(),
        ],
      ),
    );
  }

  Widget _image() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    if (_croppedBlobUrl != null) {
      return ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 0.8 * screenWidth,
            maxHeight: 0.7 * screenHeight,
          ),
          child: Image.network(_croppedBlobUrl!));
    } else if (_uploadedBlobUrl != null) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 0.8 * screenWidth,
          maxHeight: 0.7 * screenHeight,
        ),
        child: Image.network(_uploadedBlobUrl!),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _menu() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          onPressed: () {
            _clear();
          },
          backgroundColor: Colors.redAccent,
          tooltip: 'Delete',
          child: const Icon(Icons.delete),
        ),
        if (_croppedBlobUrl == null)
          Padding(
            padding: const EdgeInsets.only(left: 32.0),
            child: FloatingActionButton(
              onPressed: () {
                _cropImage();
              },
              backgroundColor: const Color(0xFFBC764A),
              tooltip: 'Crop',
              child: const Icon(Icons.crop),
            ),
          )
      ],
    );
  }

  Widget _uploaderCard() {
    return Center(
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: SizedBox(
          width: 380.0,
          height: 300.0,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DottedBorder(
                radius: const Radius.circular(12.0),
                borderType: BorderType.RRect,
                dashPattern: const [8, 4],
                color: Theme.of(context).highlightColor.withOpacity(0.4),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image,
                        color: Theme.of(context).highlightColor,
                        size: 80.0,
                      ),
                      const SizedBox(height: 24.0),
                      Text(
                        'Upload an image to start',
                        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                              color: Theme.of(context).highlightColor,
                            ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  _uploadImage();
                },
                child: const Text('Upload'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _cropImage() async {
    if (_uploadedBlobUrl != null) {
      WebUiSettings settings;
      if (widget.displayStyle == PageDisplayStyle.mobile) {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
        settings = WebUiSettings(
          context: context,
          presentStyle: CropperPresentStyle.page,
          boundary: CroppieBoundary(
            width: (screenWidth * 0.9).round(),
            height: (screenHeight * 0.8).round(),
          ),
          viewPort: const CroppieViewPort(
            width: 480,
            height: 480,
          ),
          enableExif: true,
          enableZoom: true,
          showZoomer: true,
        );
      } else {
        settings = WebUiSettings(
          context: context,
          presentStyle: CropperPresentStyle.dialog,
          boundary: const CroppieBoundary(
            width: 520,
            height: 520,
          ),
          viewPort: const CroppieViewPort(
            width: 480,
            height: 480,
          ),
          enableExif: true,
          enableZoom: true,
          showZoomer: true,
        );
      }
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _uploadedBlobUrl!,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [settings],
      );
      if (croppedFile != null) {
        setState(() {
          _croppedBlobUrl = croppedFile.path;
        });
      }
    }
  }

  Future<void> _uploadImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final blobUrl = pickedFile.path;
      debugPrint('picked blob: $blobUrl');
      setState(() {
        _uploadedBlobUrl = blobUrl;
      });
    }
  }

  void _clear() {
    setState(() {
      _uploadedBlobUrl = null;
      _croppedBlobUrl = null;
    });
  }
}
