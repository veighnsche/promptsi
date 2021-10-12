import 'package:flutter/material.dart';
import 'package:prompts_game/components/forms/pictures/picture_form_future_builder.dart';
import 'package:prompts_game/components/forms/profile/fields/profile_age_field.dart';
import 'package:prompts_game/components/forms/profile/fields/profile_first_name_field.dart';
import 'package:prompts_game/components/forms/profile/fields/profile_gender.dart';
import 'package:prompts_game/components/forms/profile/fields/profile_interested_in.dart';
import 'package:prompts_game/components/widgets/divider_text.dart';
import 'package:prompts_game/models/documents/app_profile/app_profile.dart';

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

  late AppGenders _gender;
  late List<AppGenders> _interestedIn;

  @override
  void initState() {
    super.initState();
    if (widget.profile.firstName != '') {
      _firstName.text = widget.profile.firstName;
    }
    if (widget.profile.age != '') {
      _age.text = widget.profile.age;
    }
    _gender = widget.profile.gender;
    _interestedIn = widget.profile.interestedIn;
  }

  void _setGender(AppGenders? gender) {
    if (gender != null) {
      setState(() {
        _gender = gender;
      });
    }
  }

  void _setInterestedIn(AppGenders interestedIn, bool? includeGender) {
    if (includeGender != null) {
      setState(() {
        if (includeGender) {
          _interestedIn.add(interestedIn);
        } else {
          _interestedIn.remove(interestedIn);
        }
      });
    }
  }

  bool _validate() {
    if (_formKey.currentState!.validate()) {
      if (_gender == AppGenders.undefined) {
        return false;
      }

      if (_interestedIn.isEmpty) {
        return false;
      }
      return true;
    }
    return false;
  }

  void _onSubmit() {
    if (_validate()) {
      widget.onProfileSubmit(
        widget.isCreate
            ? AppProfile.create(
                firstName: _firstName.text,
                age: _age.text,
                gender: _gender,
                interestedIn: _interestedIn,
              )
            : AppProfile.edit(
                widget.profile,
                firstName: _firstName.text,
                age: _age.text,
                gender: _gender,
                interestedIn: _interestedIn,
              ),
      );
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
                  const DividerText('I am'),
                  const SizedBox(height: 16),
                  ProfileGender(
                    gender: _gender,
                    onGenderChange: _setGender,
                  ),
                  const SizedBox(height: 16),
                  const DividerText('interested in'),
                  const SizedBox(height: 16),
                  ProfileInterestedIn(
                    interestedIn: _interestedIn,
                    onInterestedInChange: _setInterestedIn,
                  ),
                  const SizedBox(height: 16),
                  ProfileFirstNameField(controller: _firstName),
                  const SizedBox(height: 16),
                  ProfileAgeField(controller: _age),
                  const SizedBox(height: 32),
                  TextButton(
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    onPressed: _onSubmit,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
