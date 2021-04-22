import 'package:fantasy_cricket/models/match_excerpt.dart';
import 'package:fantasy_cricket/models/series.dart';
import 'package:fantasy_cricket/models/team.dart';
import 'package:fantasy_cricket/pages/series/cubits/series_add_edit_cubit.dart';
import 'package:fantasy_cricket/pages/series/series_add_edit.dart';
import 'package:fantasy_cricket/repositories/series_repo.dart';
import 'package:fantasy_cricket/repositories/team_repo.dart';
import 'package:fantasy_cricket/utils/series_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SeriesAddEdit2Cubit extends Cubit<AddEditStatus> {
  // this variable is used to save and validate the second form
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  // this contains the refernece of object series that is already built in the 
  // first form/screen
  final Series series;

  // When admin comes to [SeriesAddEdit2] screen all teams will be fetched from
  // db and all team objects will added to [allTeams] variable. This variable 
  // will be used to create dropdown list for team dropdown fields.
  final List<Team> allTeams = [];
  
  SeriesAddEdit2Cubit(this.series) : super(null) {
    emit(AddEditStatus.loading);
    
    TeamRepo
      .fetchAllTeams(allTeams)
      .catchError((onError) => emit(AddEditStatus.fetchError))
      .then((value) => emit(null));
  }

  void addMatchExcerpt() {
    series.matchExcerpts.add(MatchExcerpt(teamIds: [null, null]));

    if(state == AddEditStatus.excerptAdded) {
      emit(null);
    } else {
      emit(AddEditStatus.excerptAdded);
    }
  }

  void removeMatchExcerpt() {
    series.matchExcerpts.removeLast();

    if(state == AddEditStatus.excerptRemoved) {
      emit(null);
    } else {
      emit(AddEditStatus.excerptRemoved);
    }
  }

  Future<void> addUpdateSeriesInfo(BuildContext context) async {
    if(formKey.currentState.validate()) {
      formKey.currentState.save();
      emit(AddEditStatus.loading);

      try {
        if(await SeriesRepo.checkSeriesName(series)) {
          if(series.id == null) {
            await SeriesRepo.addSeries(series);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (BuildContext context) {
                return SeriesAddEdit(SeriesAddEditCubit(Series()));
              }),
              ModalRoute.withName('/'),
            );
            emit(AddEditStatus.added);
          } else {
            await SeriesRepo.updateSeries(series);
            emit(AddEditStatus.updated);
          }
        } else {
          Navigator.pop(context);
          emit(AddEditStatus.duplicate);
        }
      } catch(error) {
        emit(AddEditStatus.failed);
      }
    } else {
      emit(AddEditStatus.notValid);
    }
  }
}