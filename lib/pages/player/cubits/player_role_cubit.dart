import 'package:bloc/bloc.dart';

class PlayerRoleCubit extends Cubit<String> {
  PlayerRoleCubit() : super(null);

  void emitState(String state) => emit(state);
}
