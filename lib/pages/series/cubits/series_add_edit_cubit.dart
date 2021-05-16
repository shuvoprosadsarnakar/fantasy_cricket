import 'package:bloc/bloc.dart';
import 'package:fantasy_cricket/models/distribute.dart';
import 'package:fantasy_cricket/models/excerpt.dart';
import 'package:fantasy_cricket/models/series.dart';
import 'package:fantasy_cricket/models/times.dart';
import 'package:flutter/material.dart';

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


class SeriesAddEditCubit extends Cubit<AddEditStatus> {
  final Series series;

  SeriesAddEditCubit(this.series) : super(null) {
    if(series.id == null) {
      // these assignments are needed to build the [SeriesAddEdit] & 
      // [SeriesAddEdit2] screen
      series.chipsDistributes = [Distribute()];
      series.times = Times();
      series.matchExcerpts = [Excerpt(
        teamsIds: [null, null],
        teamsNames: [null, null],
        teamImages: [null, null],
      )];
    }
  }
  
  // this variable is used to save and validate the first form
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // adds a [ChipsDistribute] class object to [series] object's 
  // [chipsDistributes] list
  void addChipsDistribute() {
    series.chipsDistributes.add(Distribute());

    if(state == AddEditStatus.distributeAdded) {
      emit(null);
    } else {
      emit(AddEditStatus.distributeAdded);
    }
  }

  // removes a [ChipsDistribute] class object from [series] object's 
  // [chipsDistributes] list
  void removeChipsDistribute() {
    series.chipsDistributes.removeLast();

    if(state == AddEditStatus.distributeRemoved) {
      emit(null);
    } else {
      emit(AddEditStatus.distributeRemoved);
    }
  }

  bool validateSaveFirstForm() {
    if(formKey.currentState.validate()) {
      formKey.currentState.save();
      return true;
    } else {
      return false;
    }
  }
}