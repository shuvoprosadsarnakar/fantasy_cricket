import 'package:bloc/bloc.dart';
import 'package:fantasy_cricket/models/chips_distribute.dart';
import 'package:fantasy_cricket/models/match_excerpt.dart';
import 'package:fantasy_cricket/models/series.dart';
import 'package:fantasy_cricket/models/times.dart';
import 'package:fantasy_cricket/utils/series_util.dart';
import 'package:flutter/material.dart';

class SeriesAddEditCubit extends Cubit<AddEditStatus> {
  final Series series;
  
  SeriesAddEditCubit(this.series) : super(null) {
    if(series.id == null) {
      // these assignments are needed to build the [SeriesAddEdit] & 
      // [SeriesAddEdit2] screen
      series.chipsDistributes = [ChipsDistribute()];
      series.times = Times();
      series.matchExcerpts = [MatchExcerpt(teamIds: [null, null])];
    }
  }
  
  // this variable is used to save and validate the first form
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // adds a [ChipsDistribute] class object to [series] object's 
  // [chipsDistributes] list
  void addChipsDistribute() {
    series.chipsDistributes.add(ChipsDistribute());

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

  void validateSaveFirstForm() {
    if(formKey.currentState.validate()) {
      formKey.currentState.save();
      emit(null);
    } else {
      emit(AddEditStatus.notValid);
    }
  }
}