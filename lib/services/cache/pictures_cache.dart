class PicturesCache {
  factory PicturesCache() => _instance;
  static final PicturesCache _instance = PicturesCache._internal();

  PicturesCache._internal();

  final Map<String, List<String>> _pictures = {};

  bool has(String profileId) {
    return _pictures[profileId] != null;
  }

  void set(String profileId, List<String> pictures) {
    if (!has(profileId)) {
      print('setting pictures $profileId');
      _pictures[profileId] = pictures;
    }
  }

  List<String> get(String profileId) {
    return _pictures[profileId]!;
  }
}
