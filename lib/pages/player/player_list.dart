import 'package:fantasy_cricket/models/player.dart';
import 'package:fantasy_cricket/pages/player/bloc/player_bloc.dart';
import 'package:fantasy_cricket/pages/player/bloc/player_state.dart';
import 'package:fantasy_cricket/pages/player/bloc/player_event.dart';
import 'package:fantasy_cricket/pages/player/cubits/player_add_edit_cubit.dart';
import 'package:fantasy_cricket/pages/player/player_add_edit.dart';
import 'package:fantasy_cricket/resources/colours/color_pallate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerList extends StatefulWidget {
  @override
  _PlayerListState createState() => _PlayerListState();
}

class _PlayerListState extends State<PlayerList> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  TextEditingController _controller;
  PlayerBloc _playerBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _controller = TextEditingController();
    _playerBloc = BlocProvider.of<PlayerBloc>(context);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  _playerBloc.add(PlayerSearchClosed());
                },
              )),
              onSubmitted: (value) {
                print(value);
                // if(value.length>0)
                // _playerBloc.add(PlayerSearched(value));
                // else
                // _playerBloc.add(PlayerSearchClosed());
              },
              onChanged: (value) {
                print(value);
                if (value.length > 0)
                  _playerBloc.add(PlayerSearched(value));
                else
                  _playerBloc.add(PlayerSearchClosed());
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<PlayerBloc, PlayerState>(
              // ignore: missing_return
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
                          : PostWidget(player: state.players[index]);
                    },
                    itemCount: state.hasReachedMax
                        ? state.players.length
                        : state.players.length + 1,
                    controller: _scrollController,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
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
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }
}

class PostWidget extends StatelessWidget {
  final Player player;
  final String defaultPhoto =
      "https://cdn.iconscout.com/icon/free/png-512/football-player-1426973-1208513.png";
  const PostWidget({Key key, @required this.player}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: UniqueKey(),
      child: ListTile(
          leading: CircleAvatar(
            backgroundColor: ColorPallate.mercury,
            backgroundImage: NetworkImage(player.photo ?? defaultPhoto),
          ),
          title: Text(player.name ?? ""),
          subtitle: Text(player.role ?? ""),
          dense: true,
          trailing: IconButton(
            icon: Icon(Icons.edit),
            color: ColorPallate.pomegranate,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => 
                      PlayerAddEdit(PlayerAddEditCubit(player))),
              );
            },
          )),
      background: Container(
        color: Colors.red,
        padding: EdgeInsets.only(right: 10),
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (dismissDirection) {
        BlocProvider.of<PlayerBloc>(context).add(PlayerDelete(player));
        print("Player deleted");
      },
    );
  }
}
