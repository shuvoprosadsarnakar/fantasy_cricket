import 'package:fantasy_cricket/models/distribute.dart';

int getTotalChips(List<Distribute> distributes) {
  int totalChips = 0;
  
  distributes.forEach((Distribute distribute) {
    totalChips += distribute.chips * (distribute.to - distribute.from + 1);
  });

  return totalChips;
}
