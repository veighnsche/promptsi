import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prompts_game/components/forms/profile/profile_age_field.dart';
import 'package:prompts_game/components/forms/profile/profile_image_form.dart';
import 'package:prompts_game/components/forms/profile/profile_name_field.dart';
import 'package:prompts_game/models/profile_model.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({
    Key? key,
    required this.profile,
    required this.onProfileSubmit,
  }) : super(key: key);

  final ProfileModel profile;
  final Function(ProfileModel profile, XFile? profilePicture) onProfileSubmit;

  @override
  State<StatefulWidget> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _firstName = TextEditingController();
  final _age = TextEditingController();

  XFile? _profilePicture;

  void _setProfilePicture(XFile file) {
    setState(() {
      _profilePicture = file;
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ProfileNameField(controller: _firstName),
              ProfileAgeField(controller: _age),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ProfileImageForm(
          fileUrl: widget.profile.imagePath,
          onFileSelected: _setProfilePicture,
        ),
        ElevatedButton(
          child: const Text('Save'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              if (_profilePicture != null) {
                ProfileModel profile = ProfileModel(
                  firstName: _firstName.text,
                  age: _age.text,
                  imagePath:
                      'profiles/${widget.profile.userId}/${DateTime.now()}.jpg',
                  userId: widget.profile.userId,
                );
                widget.onProfileSubmit(profile, _profilePicture);
              } else if (widget.profile.imagePath != '') {
                ProfileModel profile = ProfileModel(
                  firstName: _firstName.text,
                  age: _age.text,
                  imagePath: widget.profile.imagePath,
                  userId: widget.profile.userId,
                );
                widget.onProfileSubmit(profile, null);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please provide with a picture'),
                  ),
                );
              }
            }
          },
        ),
      ],
    );
  }
}
