import 'dart:async';
import 'package:fantasy_cricket/repositories/player_repo.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:fantasy_cricket/pages/player/bloc/player_event.dart';
import 'package:fantasy_cricket/pages/player/bloc/player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {

  final int limit = 20;
  PlayerBloc() : super(PlayerInitial());

  @override
  Stream<Transition<PlayerEvent, PlayerState>> transformEvents(
    Stream<PlayerEvent> events,
    TransitionFunction<PlayerEvent, PlayerState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<PlayerState> mapEventToState(PlayerEvent event) async* {
    final currentState = state;
    if (event is PlayerFetched && !_hasReachedMax(currentState)) {
      try {
        if (currentState is PlayerInitial) {
          final players = await PlayerRepo.fetchPlayers(0, limit);
          if (players.length < limit)
            yield PlayerSuccess(players: players, hasReachedMax: true);
          else
            yield PlayerSuccess(players: players, hasReachedMax: false);
          return;
        }
        if (currentState is PlayerSuccess) {
          final players = await PlayerRepo.fetchPlayers(1, limit);
          if (players.length < limit)
            yield PlayerSuccess(
                players: currentState.players + players, hasReachedMax: true);
          else
            yield PlayerSuccess(
                players: currentState.players + players, hasReachedMax: false);
        }
      } catch (error) {
        print(error);
        yield PlayerFailure();
      }
    }
    if (event is PlayerSearched) {
      print("Player searched bloc");
      if (currentState is PlayerSuccess) {
        final players =
            await PlayerRepo.searchPlayers(event.searchKeyWord, limit);
        if (players != null) {
          if (players.length < limit)
            yield PlayerSuccess(players: players, hasReachedMax: true);
          else
            yield PlayerSuccess(players: players, hasReachedMax: false);
        }
      }
    }
    if (event is PlayerSearchClosed) {
       final players = await PlayerRepo.fetchPlayers(0, limit);
          if (players.length < limit)
            yield PlayerSuccess(players: players, hasReachedMax: true);
          else
            yield PlayerSuccess(players: players, hasReachedMax: false);
    }
    if (event is PlayerDelete) {
      PlayerRepo.deletePlayer(event.player);
    }
  }

  bool _hasReachedMax(PlayerState state) =>
      state is PlayerSuccess && state.hasReachedMax;
}