class AppProfile {
  AppProfile({
    required this.userId,
    required this.firstName,
    required this.age,
  });

  final String userId;
  final String firstName;
  final String age; // todo: remove age
  // todo: gender
  // todo: looking for gender

  AppProfile.create({required this.userId, String? firstName, String? age})
      : firstName = firstName ?? '',
        age = age ?? '';

  AppProfile.edit(AppProfile profile, {String? firstName, String? age})
      : userId = profile.firstName,
        firstName = firstName ?? profile.firstName,
        age = age ?? profile.age;

  AppProfile.fromJson(Map<String, dynamic> json)
      : userId = json['userId'] as String,
        firstName = json['firstName'] as String,
        age = json['age'] as String;

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'firstName': firstName,
        'age': age,
      };
}
