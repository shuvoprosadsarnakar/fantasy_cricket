import 'package:equatable/equatable.dart';

abstract class PlayerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PlayerFetched extends PlayerEvent {}