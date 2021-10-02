import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prompts_game/components/forms/pictures/picture_field.dart';
import 'package:prompts_game/services/apis/auth_api.dart';
import 'package:prompts_game/services/apis/storage_api.dart';

class PictureForm extends StatefulWidget {
  const PictureForm({Key? key, required this.pictures}) : super(key: key);

  final List<String> pictures;

  @override
  State<PictureForm> createState() => _PictureFormState();
}

class _PictureFormState extends State<PictureForm> {
  static final _user = AuthApi.currentUser;

  static const int _rows = 2;
  static const int _columns = 3;

  late List<String> _pictureCache;

  @override
  void initState() {
    super.initState();
    _pictureCache = widget.pictures;
  }

  void _onPictureSelected(XFile pictureFile) {
    StorageApi.uploadPicture(_user.uid, pictureFile).then((String picture) {
      setState(() {
        _pictureCache.add(picture);
      });
    });
  }

  Function() _onPictureRemoved(int idx) {
    return () {
      if (idx < 0 || idx >= _pictureCache.length) {
        return;
      }

      StorageApi.deletePicture(_user.uid, _pictureCache[idx]).whenComplete(() {
        setState(() {
          _pictureCache.removeAt(idx);
        });
      });
    };
  }

  String? _getPictureAt(int idx) {
    if (idx >= _pictureCache.length) {
      return null;
    }
    return _pictureCache[idx];
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      children: List.generate(_rows, (int rowIdx) {
        return TableRow(
          children: List.generate(_columns, (int columnIdx) {
            final idx = rowIdx * _columns + columnIdx;
            return PictureField(
              onFileSelected: _onPictureSelected,
              onFileRemoved: _onPictureRemoved(idx),
              imageFile: _getPictureAt(idx),
            );
          }),
        );
      }),
    );
  }
}
