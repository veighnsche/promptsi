class StringUtils {
  static String? getFirstWord(String? string) {
    if (string == null) {
      return null;
    }
    final List<String> words = string.split(' ');
    return words[0];
  }

  static String getPictureFileNameFromUrl(String picture) {
    final List<String> parts = picture.split('/');
    return parts[parts.length - 1];
  }
}
