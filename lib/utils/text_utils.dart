abstract class TextUtils {
  static String minifyText(String text, int chars, {String overflow = "..."}) {
    if (text.length <= chars) {
      return text;
    }
    return text.substring(0, chars + 1) + overflow.toString();
  }
}
