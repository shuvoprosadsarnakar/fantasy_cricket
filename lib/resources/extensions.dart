extension ParseNumbers on String {
  String incrementLastChar() {
    String s = this;
    s = s.toLowerCase();
    String a = s.substring(s.length - 1);
    int lastChar = a.codeUnits[0];
    lastChar++;
    return (String.fromCharCode(lastChar));
  }
}
