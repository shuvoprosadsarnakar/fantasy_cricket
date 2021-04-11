part of 'addplayer_cubit.dart';

abstract class AddplayerState extends Equatable {
  const AddplayerState();

  @override
  List<Object> get props => [AddplayerState];
}

class AddplayerInitial extends AddplayerState {
  const AddplayerInitial();
}

class AddplayerLoading extends AddplayerState {
  const AddplayerLoading();
}

class AddplayerAdded extends AddplayerState {
  const AddplayerAdded();
}

class AddplayerError extends AddplayerState {
  final String message;
  const AddplayerError(this.message);
}
