import 'package:equatable/equatable.dart';
import 'package:fantasy_cricket/models/team.dart';

abstract class TeamEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class TeamFetched extends TeamEvent {}

class TeamSearchClosed extends TeamEvent {}

class TeamSearched extends TeamEvent {
  final String searchKeyWord;

  TeamSearched(this.searchKeyWord);

  @override
  List<Object> get props => [searchKeyWord];
}

class TeamDelete extends TeamEvent {
  final Team team;

  TeamDelete(this.team);

  @override
  List<Object> get props => [team];
}
