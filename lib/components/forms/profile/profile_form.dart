import 'package:flutter/material.dart';
import 'package:prompts_game/components/forms/pictures/picture_form_future_builder.dart';
import 'package:prompts_game/components/forms/profile/fields/profile_age_field.dart';
import 'package:prompts_game/components/forms/profile/fields/profile_first_name_field.dart';
import 'package:prompts_game/models/profile_model.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({
    Key? key,
    this.isCreate = false,
    required this.profile,
    required this.onProfileSubmit,
  }) : super(key: key);

  final bool isCreate;
  final AppProfile profile;
  final Function(AppProfile) onProfileSubmit;

  @override
  State<StatefulWidget> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _age = TextEditingController();

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

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      AppProfile profile = widget.isCreate
          ? AppProfile.create(
              userId: widget.profile.userId,
              firstName: _firstName.text,
              age: _age.text,
            )
          : AppProfile.edit(
              widget.profile,
              firstName: _firstName.text,
              age: _age.text,
            );
      widget.onProfileSubmit(profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 32),
            const PictureFormFutureBuilder(),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  ProfileFirstNameField(controller: _firstName),
                  const SizedBox(height: 16),
                  ProfileAgeField(controller: _age),
                  const SizedBox(height: 16),
                  TextButton(
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    onPressed: _onSubmit,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
