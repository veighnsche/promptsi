class StringUtils {
  static String? getFirstWord(String? string) {
    if (string == null) {
      return null;
    }
    final List<String> words = string.split(' ');
    return words[0];
  }
}
