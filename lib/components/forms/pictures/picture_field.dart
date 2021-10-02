import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prompts_game/components/bodies/loading_body.dart';

class PictureField extends StatefulWidget {
  const PictureField({
    Key? key,
    required this.onFileSelected,
    required this.onFileRemoved,
    this.imageUrl,
  }) : super(key: key);

  final Function(XFile file) onFileSelected;
  final Function() onFileRemoved;
  final Future<String>? imageUrl;

  @override
  State<StatefulWidget> createState() => _PictureFieldState();
}

class _PictureFieldState extends State<PictureField> {
  final _picker = ImagePicker();

  set imageFileUnCropped(XFile? file) {
    if (file != null) {
      _cropImage(file);
    }
  }

  set imageFile(File? file) {
    if (file != null) {
      XFile xFile = XFile(file.path);
      widget.onFileSelected(xFile);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    imageFileUnCropped = await _picker.pickImage(
      source: source,
      preferredCameraDevice: CameraDevice.front,
    );
  }

  Future<void> _cropImage(XFile imageFileUnCropped) async {
    imageFile = await ImageCropper.cropImage(
      sourcePath: imageFileUnCropped.path,
      maxHeight: 400,
      maxWidth: 400,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      androidUiSettings: const AndroidUiSettings(
        toolbarColor: Colors.blue,
        toolbarWidgetColor: Colors.white,
        toolbarTitle: 'Crop your picture',
      ),
    );
  }

  void _chooseSource() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 100,
          child: Column(
            children: [
              TextButton.icon(
                icon: const FaIcon(Icons.photo_library),
                label: const Text('Choose from gallery'),
                onPressed: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
              TextButton.icon(
                icon: const FaIcon(FontAwesomeIcons.camera),
                label: const Text('Take a picture'),
                onPressed: () {
                  _pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: widget.imageUrl == null
            ? [
                CachedNetworkImage(
                  // todo: save asset to app
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  imageUrl:
                      'https://thesocialstudies.co/wp-content/uploads/2021/06/placeholder-1-1.jpg',
                ),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.plusCircle),
                  onPressed: _chooseSource,
                ),
              ]
            : [
                _PictureRef(widget: widget),
                IconButton(
                  icon: const FaIcon(FontAwesomeIcons.timesCircle),
                  onPressed: widget.onFileRemoved,
                ),
              ],
      ),
    );
  }
}

class _PictureRef extends StatelessWidget {
  const _PictureRef({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final PictureField widget;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.imageUrl!,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return CachedNetworkImage(
            imageUrl: snapshot.data!,
            progressIndicatorBuilder: (context, url, downloadProgress) {
              return CircularProgressIndicator(
                value: downloadProgress.progress,
              );
            },
          );
        }

        return const LoadingBody();
      },
    );
  }
}
