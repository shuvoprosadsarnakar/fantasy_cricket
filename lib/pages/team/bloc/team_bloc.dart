import 'dart:async';
import 'package:fantasy_cricket/repositories/team_repo.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:fantasy_cricket/pages/team/bloc/team_event.dart';
import 'package:fantasy_cricket/pages/team/bloc/team_state.dart';

class TeamBloc extends Bloc<TeamEvent, TeamState> {

  final int limit = 20;
  TeamBloc() : super(TeamInitial());

  @override
  Stream<Transition<TeamEvent, TeamState>> transformEvents(
    Stream<TeamEvent> events,
    TransitionFunction<TeamEvent, TeamState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<TeamState> mapEventToState(TeamEvent event) async* {
    final currentState = state;
    if (event is TeamFetched && !_hasReachedMax(currentState)) {
      try {
        if (currentState is TeamInitial) {
          final teams = await TeamRepo.fetchTeams(0, limit);
          if (teams.length < limit)
            yield TeamSuccess(teams: teams, hasReachedMax: true);
          else
            yield TeamSuccess(teams: teams, hasReachedMax: false);
          return;
        }
        if (currentState is TeamSuccess) {
          final teams = await TeamRepo.fetchTeams(1, limit);
          if (teams.length < limit)
            yield TeamSuccess(
                teams: currentState.teams + teams, hasReachedMax: true);
          else
            yield TeamSuccess(
                teams: currentState.teams + teams, hasReachedMax: false);
        }
      } catch (error) {
        print(error);
        yield TeamFailure();
      }
    }
    if (event is TeamSearched) {
      print("Team searched bloc");
      if (currentState is TeamSuccess) {
        final teams =
            await TeamRepo.searchTeams(event.searchKeyWord, limit);
        if (teams != null) {
          if (teams.length < limit)
            yield TeamSuccess(teams: teams, hasReachedMax: true);
          else
            yield TeamSuccess(teams: teams, hasReachedMax: false);
        }
      }
    }
    if (event is TeamSearchClosed) {
       final teams = await TeamRepo.fetchTeams(0, limit);
          if (teams.length < limit)
            yield TeamSuccess(teams: teams, hasReachedMax: true);
          else
            yield TeamSuccess(teams: teams, hasReachedMax: false);
    }
    if (event is TeamDelete) {
      TeamRepo.deleteTeam(event.team);
    }
  }

  bool _hasReachedMax(TeamState state) =>
      state is TeamSuccess && state.hasReachedMax;
}