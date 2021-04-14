import 'package:equatable/equatable.dart';
import 'package:fantasy_cricket/models/player.dart';


abstract class PlayerState extends Equatable {
  const PlayerState();

  @override
  List<Object> get props => [];
}

class PlayerInitial extends PlayerState {}

class PlayerFailure extends PlayerState {}

class PlayerSuccess extends PlayerState {
  final List<Player> players;
  final bool hasReachedMax;

  const PlayerSuccess({
    this.players,
    this.hasReachedMax,
  });

  PlayerSuccess copyWith({
    List<Player> players,
    bool hasReachedMax,
  }) {
    return PlayerSuccess(
      players: players ?? this.players,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [players, hasReachedMax];

  @override
  String toString() =>
      'PlayerSuccess { Players: ${players.length}, hasReachedMax: $hasReachedMax }';
}
