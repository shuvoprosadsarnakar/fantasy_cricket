import 'package:equatable/equatable.dart';
import 'package:fantasy_cricket/models/player.dart';

abstract class PlayerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PlayerFetched extends PlayerEvent {}

class PlayerDelete extends PlayerEvent {
  final Player player;

  PlayerDelete(this.player);
  
  @override
  List<Object> get props => [player];
}
