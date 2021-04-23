// this enum will be used by [SeriesAddEditCubit] and [SeriesAddEdit2Cubi] 
// cubits to rebuild ui
//
// loading: fetching all teams, adding and updating series to db and series 
// name checking
// 
// fetchError: failed to fetch all teams from database
// 
// updated: series updated into db
// 
// duplicate: series name already taken by one other series
// 
// failed: failed to add or update series
// 
// distributeAdded: [ChipsDistribute] added to series in the device, not in db
// 
// distributeRemoved: [ChipsDistribute] deleted from series in the device, not 
// in db
// 
// excerptAdded: [MatchExcerpt] added to series in the device, not in db
// 
// excerptRemoved: [MatchExcerpt] deleted from series in the device, not in db
//
enum AddEditStatus {
  distributeAdded,
  distributeRemoved,
  excerptAdded,
  excerptRemoved,
  loading,
  fetchError,
  duplicate,
  updated,
  failed,
}
