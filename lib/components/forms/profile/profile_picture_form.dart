import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePictureForm extends StatefulWidget {
  const ProfilePictureForm({
    Key? key,
    required this.onFileSelected,
    required this.fileUrl,
  }) : super(key: key);

  final String fileUrl;
  final Function(XFile file) onFileSelected;

  @override
  State<StatefulWidget> createState() => _ProfilePictureFormState();
}

class _ProfilePictureFormState extends State<ProfilePictureForm> {
  final _picker = ImagePicker();

  XFile? _imageFile;
  XFile? _imageFileCropped;

  set imageFile(XFile? file) {
    if (file != null) {
      setState(() {
        _imageFile = file;
      });
      _cropImage();
    }
  }

  set imageFileCropped(File? file) {
    if (file != null) {
      XFile xFile = XFile(file.path);
      setState(() {
        _imageFileCropped = xFile;
      });
      widget.onFileSelected(xFile);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    imageFile = await _picker.pickImage(
      source: source,
      preferredCameraDevice: CameraDevice.front,
    );
  }

  Future<void> _cropImage() async {
    if (_imageFile != null) {
      imageFileCropped = await ImageCropper.cropImage(
        sourcePath: _imageFile!.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        androidUiSettings: const AndroidUiSettings(
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          toolbarTitle: 'Crop It',
        ),
      );
    }
  }

  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_imageFileCropped == null)
          Image.network(
            // todo: link the fileURL here,
            'https://thesocialstudies.co/wp-content/uploads/2021/06/placeholder-1-1.jpg',
          ),
        if (_imageFileCropped != null) Image.file(File(_imageFileCropped!.path)),
        Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.photo_library),
              onPressed: () => _pickImage(ImageSource.gallery),
            ),
            IconButton(
              icon: const Icon(Icons.photo_camera),
              onPressed: () => _pickImage(ImageSource.camera),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _clear,
            ),
            if (_imageFile != null)
              IconButton(
                icon: const Icon(Icons.crop),
                onPressed: _cropImage,
              ),
          ],
        ),
      ],
    );
  }
}
