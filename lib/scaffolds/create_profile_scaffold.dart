import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prompts_game/interfaces/app_profile.dart';
import 'package:prompts_game/scaffolds/loading_scaffold.dart';

class CreateProfileScaffold extends StatefulWidget {
  const CreateProfileScaffold({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateProfileScaffoldState();
}

class _CreateProfileScaffoldState extends State<CreateProfileScaffold> {
  final User? _user = FirebaseAuth.instance.currentUser;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _age = TextEditingController();

  final _picker = ImagePicker();

  XFile? _imageFile;
  XFile? _imageFileCropped;

  Future<void> _pickImage(ImageSource source) async {
    XFile? selected = await _picker.pickImage(
      source: source,
      preferredCameraDevice: CameraDevice.front,
    );

    if (selected != null) {
      File? cropped = await ImageCropper.cropImage(
        sourcePath: selected.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        androidUiSettings: const AndroidUiSettings(
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          toolbarTitle: 'Crop It',
        ),
      );

      if (cropped != null) {
        setState(() {
          _imageFileCropped = XFile(cropped.path);
          _imageFile = selected;
        });
      } else {
        setState(() {
          _imageFile = selected;
        });
      }
    }
  }

  Future<void> _cropImage() async {
    if (_imageFile != null) {
      File? cropped = await ImageCropper.cropImage(
        sourcePath: _imageFile!.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        androidUiSettings: const AndroidUiSettings(
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          toolbarTitle: 'Crop It',
        ),
      );
      if (cropped != null) {
        setState(() {
          _imageFileCropped = XFile(cropped.path);
        });
      }
    }
  }

  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  void initState() {
    super.initState();
    _firstName.text = _getFirstWord(_user?.displayName) ?? '';
  }

  // get only first word of string
  String? _getFirstWord(String? string) {
    if (string == null) {
      return null;
    }
    final List<String> words = string.split(' ');
    return words[0];
  }

  String? _isOlderThan18Validator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your age';
    } else if (int.tryParse(value) == null) {
      return 'Please enter a valid age';
    } else if (int.parse(value) < 18) {
      return 'You must be older than 18';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (_isUploading) {
      return const LoadingScaffold();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: ListView(
          children: [
            const SizedBox(height: 40),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: _firstName,
                    validator: (String? value) {
                      if (value != null && value.split(' ').length > 1) {
                        return 'Please enter only one name';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                    ),
                    keyboardType: TextInputType.text,
                  ),
                  TextFormField(
                    controller: _age,
                    validator: _isOlderThan18Validator,
                    decoration: const InputDecoration(
                      labelText: 'Age',
                    ),
                    keyboardType: TextInputType.number,
                    textCapitalization: TextCapitalization.words,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            if (_imageFile != null) Image.file(File(_imageFileCropped!.path)),
            if (_imageFile == null)
              Image.network(
                'https://thesocialstudies.co/wp-content/uploads/2021/06/placeholder-1-1.jpg',
              ),
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
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (_imageFileCropped != null) {
                    _saveProfile();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please provide with a picture')),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  final FirebaseStorage _storage = FirebaseStorage.instance;

  bool _isUploading = false;

  Future<void> _saveProfile() async {
    if (_imageFileCropped != null && _user != null) {
      AppProfile profile = AppProfile(
        firstName: _firstName.text,
        age: _age.text,
        imagePath: 'profiles/${_user!.uid}/${DateTime.now()}.jpg',
        email: _user!.email!,
      );

      setState(() {
        _isUploading = true;
      });

      UploadTask _uploadTask = _storage
          .ref()
          .child(profile.imagePath)
          .putFile(File(_imageFileCropped!.path));

      _uploadTask.whenComplete(() {
        AppProfile.firestoreRef.add(profile);
      });
    }
  }
}
