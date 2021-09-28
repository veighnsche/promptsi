class ProfileModel {
  ProfileModel({
    required this.firstName,
    required this.age,
    required this.imagePath,
    required this.userId,
  });

  final String firstName;
  final String age;
  final String imagePath;
  final String userId;

  ProfileModel.create({required this.userId, String? firstName})
      : firstName = firstName ?? '',
        age = '',
        imagePath = '';

  ProfileModel.fromJson(Map<String, dynamic> json)
      : firstName = json['firstName'] as String,
        age = json['age'] as String,
        imagePath = json['imagePath'] as String,
        userId = json['userId'] as String;

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'age': age,
        'imagePath': imagePath,
        'userId': userId,
      };
}
