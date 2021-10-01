class AppProfile {
  AppProfile({
    this.uid,
    required this.userId,
    required this.firstName,
    required this.age,
  });

  final String? uid;
  final String userId;
  final String firstName;
  final String age;

  AppProfile.create({required this.userId, String? firstName, this.uid})
      : firstName = firstName ?? '',
        age = '';

  AppProfile.fromJson(Map<String, dynamic> json)
      : uid = json['uid'] as String,
        userId = json['userId'] as String,
        firstName = json['firstName'] as String,
        age = json['age'] as String;

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'userId': userId,
        'firstName': firstName,
        'age': age,
      };
}
