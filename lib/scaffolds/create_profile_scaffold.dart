import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateProfileScaffold extends StatelessWidget {
  CreateProfileScaffold({Key? key}) : super(key: key);

  final User? _user = FirebaseAuth.instance.currentUser;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // get only first word of string
  String? _getFirstWord(String? string) {
    if (string == null) {
      return null;
    }
    final List<String> words = string.split(' ');
    return words[0];
  }

  @override
  Widget build(BuildContext context) {

    print(_user);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Profile'),
      ),
      body: Center(
        // form that asks for first name, age and picture
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: <Widget>[
                TextFormField(
                  initialValue: _getFirstWord(_user?.displayName),
                  validator: (String? value) {
                    // can only be one name
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
                  // is older than 18
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    } else if (int.tryParse(value) == null) {
                      return 'Please enter a valid age';
                    } else if (int.parse(value) < 18) {
                      return 'You must be older than 18';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Age',
                  ),
                  keyboardType: TextInputType.number,
                ),
                ElevatedButton(
                  child: const Text('Submit'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}
