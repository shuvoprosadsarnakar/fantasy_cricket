import 'package:equatable/equatable.dart';
import 'package:fantasy_cricket/models/team.dart';

abstract class TeamState extends Equatable {
  const TeamState();

  @override
  List<Object> get props => [];
}

class TeamInitial extends TeamState {}

class TeamFailure extends TeamState {}

class TeamSuccess extends TeamState {
  final List<Team> teams;
  final bool hasReachedMax;

  const TeamSuccess({
    this.teams,
    this.hasReachedMax,
  });

  TeamSuccess copyWith({
    List<Team> teams,
    bool hasReachedMax,
  }) {
    return TeamSuccess(
      teams: teams ?? this.teams,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [teams, hasReachedMax,];

  @override
  String toString() =>
      'TeamSuccess { Teams: ${teams.length}, hasReachedMax: $hasReachedMax ,';
}
