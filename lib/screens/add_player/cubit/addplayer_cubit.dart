import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fantasy_cricket/model/player_nr.dart';
import 'package:fantasy_cricket/services/database/player_repository.dart';

part 'addplayer_state.dart';

class AddplayersCubit extends Cubit<AddplayerState> {
  final FsPlayerRepository _playerRepository;
  AddplayersCubit(this._playerRepository) : super(AddplayerInitial());

  Future<void> addPlayer(Playernr player) async {
    try {
      emit(AddplayerLoading());
      await _playerRepository.addPlayer(player);
      emit(AddplayerAdded());
    } on NetworkException {
      emit(AddplayerError("Network error"));
    }
  }
}
