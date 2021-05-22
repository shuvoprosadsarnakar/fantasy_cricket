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
    String url = 'https://www.cricbuzz.com/live-cricket-scorecard/36092/ned-vs-sco-2nd-odi-scotland-tour-of-netherlands-2021';
    
    if(await canLaunch(url)) {
      await launch(
        url,
        forceWebView: true,
        enableJavaScript: true,
      );
    } else {
      emit(CubitState.launchFailed);
    }
  }
}
