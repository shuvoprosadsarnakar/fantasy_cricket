abstract class NumberSuffixFinder {
  static String getNumberSuffix(int number) {
    switch(number % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
       return 'rd';
      default:
        return 'th';
    }
  }
}
