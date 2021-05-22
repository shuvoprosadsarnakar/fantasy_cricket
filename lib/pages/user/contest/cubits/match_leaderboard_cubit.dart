import 'package:fantasy_cricket/models/contest.dart';
import 'package:fantasy_cricket/models/excerpt.dart';
import 'package:fantasy_cricket/models/user.dart';
import 'package:fantasy_cricket/repositories/contest_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

enum CubitState {
  loading,
  fetchError,
  launchFailed,
}

class MatchLeaderBoardCubit extends Cubit<CubitState> {
  Contest contest;
  final Excerpt excerpt;
  final User user;
  
  MatchLeaderBoardCubit(this.excerpt, this.user) : super(null) {
    emit(CubitState.loading);
    ContestRepo.getContestById(excerpt.id)
      .catchError((error) {
        emit(CubitState.fetchError);
      })
      .then((Contest contest) {
        this.contest = contest;
        emit(null);
      });
  }

  Future<void> launchFullScoreUrl() async {
    emit(CubitState.loading);
    if(await canLaunch(contest.fullScoreUrl)) {
      await launch(
        contest.fullScoreUrl,
        forceWebView: true,
        enableJavaScript: true,
      );
    } else {
      emit(CubitState.launchFailed);
    }
  }
}
