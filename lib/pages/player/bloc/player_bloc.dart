import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_cricket/models/player.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';
import 'package:fantasy_cricket/pages/player/bloc/player_event.dart';
import 'package:fantasy_cricket/pages/player/bloc/player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final CollectionReference playerCollection =
      Firestore.instance.collection('player');
  Future<List<DocumentSnapshot>> documentList;
  DocumentSnapshot lastDocument;
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
          final players = await _fetchPlayers(null, 10);
          if (players.length < 10)
            yield PlayerSuccess(players: players, hasReachedMax: true);
          else
            yield PlayerSuccess(players: players, hasReachedMax: false);
          return;
        }
        if (currentState is PlayerSuccess) {
          final players = await _fetchPlayers(1, 10);
          if (players.length < 10)
            yield PlayerSuccess(
                players: currentState.players + players, hasReachedMax: true);
          else
            yield PlayerSuccess(
                players: currentState.players + players, hasReachedMax: false);
          // yield players.isEmpty
          //     ? currentState.copyWith(hasReachedMax: true)
          //     : PlayerSuccess(
          //         players: currentState.players + players,
          //         hasReachedMax: false,
          //       );
        }
      } catch (error) {
        print(error);
        yield PlayerFailure();
      }
    }
  }

  bool _hasReachedMax(PlayerState state) =>
      state is PlayerSuccess && state.hasReachedMax;

  Future<List<Player>> _fetchPlayers(int startIndex, int limit) async {
    if (startIndex == null) {
      QuerySnapshot documentList =
          await playerCollection.orderBy("name").limit(limit).getDocuments();
      lastDocument = documentList.documents.last;

      return documentList.documents
          .map((doc) => Player.fromMap(doc.data, doc.documentID))
          .toList();
    } else {
      QuerySnapshot documentList = await playerCollection
          .orderBy("name")
          .limit(limit)
          .startAfterDocument(lastDocument)
          .getDocuments();
      lastDocument = documentList.documents.last;
      return documentList.documents
          .map((doc) => Player.fromMap(doc.data, doc.documentID))
          .toList();
    }
  }
  // Future<List<Player>> _fetchPlayers(int startIndex, int limit) async {
  //   if (startIndex == null) {

  //     return (await playerCollection
  //             .orderBy("name")
  //             .limit(limit)
  //             .getDocuments())
  //         .documents
  //         .map((doc) => Player.fromSnapshot(doc, doc.documentID))
  //         .toList();
  //   } else {
  //     return (await playerCollection
  //             .orderBy("name")
  //             .limit(limit)
  //             //.startAfterDocument()
  //             .getDocuments())
  //         .documents
  //         .map((doc) => Player.fromSnapshot(doc, doc.documentID))
  //         .toList();
  //   }
  // }
}
