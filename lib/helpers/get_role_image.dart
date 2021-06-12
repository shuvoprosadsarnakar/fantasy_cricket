import 'package:fantasy_cricket/resources/player_roles.dart';

String getRoleImage(String playerRole) {
  String roleImage = 'lib/resources/images/';

  switch(playerRole) {
    case BATSMAN: roleImage += 'bat.png'; break;
    case BOWLER: roleImage += 'ball.png'; break;
    case ALL_ROUNDER: roleImage += 'bat-and-ball.png'; break;
    case WICKET_KEEPER: roleImage += 'wicket-keeper.png'; break;
  }

  return roleImage;
}
