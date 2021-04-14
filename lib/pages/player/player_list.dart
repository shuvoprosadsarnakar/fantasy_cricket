import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fantasy_cricket/models/player.dart';
import 'package:fantasy_cricket/pages/player/bloc/player_bloc.dart';
import 'package:fantasy_cricket/pages/player/bloc/player_state.dart';
import 'package:fantasy_cricket/pages/player/bloc/player_event.dart';
import 'package:fantasy_cricket/resources/colours/color_pallate.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerList extends StatefulWidget {
  @override
  _PlayerListState createState() => _PlayerListState();
}

class _PlayerListState extends State<PlayerList> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  PlayerBloc _playerBloc;


  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _playerBloc = BlocProvider.of<PlayerBloc>(context);

  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PlayerBloc, PlayerState>(
        builder: (context, state) {
          if (state is PlayerInitial) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is PlayerFailure) {
            return Center(
              child: Text('failed to fetch posts'),
            );
          } else if (state is PlayerSuccess) {
            if (state.players.isEmpty) {
              return Center(
                child: Text('no posts'),
              );
            }
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return index >= state.players.length
                    ? BottomLoader()
                    : PostWidget(post: state.players[index]);
              },
              itemCount: state.hasReachedMax
                  ? state.players.length
                  : state.players.length + 1,
              controller: _scrollController,
            );
          }
        },
      ),
    );
  }

  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _playerBloc.add(PlayerFetched());
    }
  }
}

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: 33,
          height: 33,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
          ),
        ),
      ),
    );
  }
}

class PostWidget extends StatelessWidget {
  final Player post;

  const PostWidget({Key key, @required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        '${post.id}',
        style: TextStyle(fontSize: 10.0),
      ),
      title: Text(post.name),
      isThreeLine: true,
      subtitle: Text(post.role),
      dense: true,
    );
  }
}
