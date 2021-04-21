import 'package:bloc/bloc.dart';
import 'package:fantasy_cricket/models/chips_distribute.dart';
import 'package:fantasy_cricket/models/match_excerpt.dart';
import 'package:fantasy_cricket/models/series.dart';
import 'package:fantasy_cricket/models/times.dart';
import 'package:fantasy_cricket/utils/series_util.dart';
import 'package:flutter/material.dart';

class SeriesAddEditCubit extends Cubit<AddEditStatus> {
  SeriesAddEditCubit() : super(null);

  // this variable's properites will be set by [setSeries] function
  final Series series = Series();
  
  // this variable is used to save and validate the first form
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // this function sets [series] variable properties on the basis of admin is 
  // creating or editing series 
  void setSeries(Series series) {
    if(series != null) {
      this.series.name = series.name;
      this.series.chipsDistributes = series.chipsDistributes;
      this.series.times = series.times;
      this.series.matchExcerpts = series.matchExcerpts;
    } else {
      this.series.chipsDistributes = [ChipsDistribute()];
      this.series.times = Times();
      this.series.matchExcerpts = [MatchExcerpt(teamIds: [null, null])];
    }
  }

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