import 'package:bloc/bloc.dart';

class PlayerRoleCubit extends Cubit<String> {
  PlayerRoleCubit() : super(null);

  final List<String> playerRoles = <String>[
    'Batsman',
    'Wicket Keeper',
    'All Rounder',
    'Bowler',  
  ];

  void emitState(String state) => emit(state);
}
