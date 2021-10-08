/// @Deprecated
class AppProfileFeedIds {
  AppProfileFeedIds(Map<String, dynamic> json)
      : profileId = json['profileId'],
        promptId = json['promptId'];

  final String profileId;
  final List<String> promptId;
}
