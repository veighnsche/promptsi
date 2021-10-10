import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prompts_game/components/forms/pictures/picture_field.dart';
import 'package:prompts_game/services/apis/firebase/auth_api.dart';
import 'package:prompts_game/services/apis/firebase/storage_api.dart';

class PictureForm extends StatefulWidget {
  const PictureForm({Key? key, required this.pictureRefs}) : super(key: key);

  final List<Reference> pictureRefs;

  @override
  State<PictureForm> createState() => _PictureFormState();
}

class _PictureFormState extends State<PictureForm> {
  static final _user = AuthApi.currentUser;

  static const int _rows = 2;
  static const int _columns = 3;

  late List<Reference> _pictureRefCache;

  @override
  void initState() {
    super.initState();
    _pictureRefCache = widget.pictureRefs;
  }

  void _onPictureSelected(XFile pictureFile) {
    StorageApi.uploadPicture(_user.uid, pictureFile).then((Reference ref) {
      setState(() {
        _pictureRefCache.add(ref);
      });
    });
  }

  Function() _onPictureRemoved(int idx) {
    return () {
      if (idx < 0 || idx >= _pictureRefCache.length) {
        return;
      }

      StorageApi.deletePicture(_pictureRefCache[idx]).whenComplete(() {
        setState(() {
          _pictureRefCache.removeAt(idx);
        });
      });
    };
  }

  Future<String>? _getPictureAt(int idx) {
    if (idx >= _pictureRefCache.length) {
      return null;
    }
    return _pictureRefCache[idx].getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      children: List.generate(_rows, (int rowIdx) {
        return TableRow(
          children: List.generate(_columns, (int columnIdx) {
            final idx = rowIdx * _columns + columnIdx;
            return PictureField(
              context: context,
              onFileSelected: _onPictureSelected,
              onFileRemoved: _onPictureRemoved(idx),
              pictureRef: _getPictureAt(idx),
            );
          }),
        );
      }),
    );
  }
}
