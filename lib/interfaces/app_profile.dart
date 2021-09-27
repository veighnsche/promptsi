import 'package:cloud_firestore/cloud_firestore.dart';

class AppProfile {
  AppProfile({
    required this.firstName,
    required this.age,
    required this.imagePath,
    required this.email,
  });

  final String firstName;
  final String age;
  final String imagePath;
  final String email;

  static CollectionReference firestoreRef = FirebaseFirestore.instance
      .collection('profiles')
      .withConverter<AppProfile>(
        fromFirestore: (snapshot, _) => AppProfile.fromJson(snapshot.data()!),
        toFirestore: (AppProfile profile, _) => profile.toJson(),
      );

  AppProfile.fromJson(Map<String, dynamic> json)
      : firstName = json['firstName'] as String,
        age = json['age'] as String,
        imagePath = json['imagePath'] as String,
        email = json['email'] as String;

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'age': age,
        'imagePath': imagePath,
        'email': email,
      };
}
