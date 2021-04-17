// this enum will be used by TeamAddEditCubit() cubit to rebuild ui
//
// loading: fetching all players, adding and updating team to db, name checking
// 
// fetchError: failed to fetch all players from database
// 
// added: team added to db
// 
// updated: team update into db
// 
// duplicate: name already taken by one other team
// 
// failed: failed to add or update team
// 
// playerAdded: player added to team in the device, not in db
// 
// playerDelete: player deleted from team in the device, not in db
// 
// searched: players searching finished
// 
// validationError: team name is null or, '', or ' ',
// 
enum AddEditStatus {loading, fetchError, added, updated, duplicate, failed, 
  playerAdded, playerDeleted, searched, validationError}
