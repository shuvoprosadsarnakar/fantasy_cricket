// all player roles
final List<String> playerRoles = <String>[
  'Batsman',
  'Wicket Keeper',
  'All Rounder',
  'Bowler',
];

// this enum will be used by PlayerAddEditCubit() cubit to rebuild ui
// 
// loading: adding and updating player to db, name checking
// 
// added: player added to db
// 
// updated: player update into db
// 
// duplicate: name already taken by one other player
// 
// failed: failed to add or update player
// 
// notValid: player name is null or, '', or ' ',
// 
enum AddEditStatus {loading, added, updated, duplicate, failed, notValid}
