import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prompts_game/components/forms/profile/fields/profile_age_field.dart';
import 'package:prompts_game/components/forms/profile/profile_picture_form.dart';
import 'package:prompts_game/components/forms/profile/fields/profile_name_field.dart';
import 'package:prompts_game/models/profile_model.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({
    Key? key,
    required this.profile,
    required this.onProfileSubmit,
  }) : super(key: key);

  final AppProfile profile;
  final Function(AppProfile profile, XFile? profilePicture) onProfileSubmit;

  @override
  State<StatefulWidget> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _age = TextEditingController();

  XFile? _profilePicture;

  @override
  void initState() {
    super.initState();
    if (widget.profile.firstName != '') {
      _firstName.text = widget.profile.firstName;
    }
    if (widget.profile.age != '') {
      _age.text = widget.profile.age;
    }
  }

  void _setProfilePicture(XFile file) {
    setState(() {
      _profilePicture = file;
    });
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      if (_profilePicture != null) {
        AppProfile profile = AppProfile(
          userId: widget.profile.userId,
          firstName: _firstName.text,
          age: _age.text,
        );
        widget.onProfileSubmit(profile, _profilePicture);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please provide with a picture'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          ProfileNameField(controller: _firstName),
          ProfileAgeField(controller: _age),
          const SizedBox(height: 10),
          ProfilePictureForm(
            onFileSelected: _setProfilePicture,
          ),
          ElevatedButton(
            child: const Text('Save'),
            onPressed: _onSubmit,
          ),
        ],
      ),
    );
  }
}
