import 'package:fantasy_cricket/pages/team/bloc/team_bloc.dart';
import 'package:fantasy_cricket/resources/colours/color_pallate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fantasy_cricket/pages/team/bloc/team_event.dart';
import 'package:fantasy_cricket/pages/team/bloc/team_state.dart';

import 'bloc/team_bloc.dart';

class TeamList extends StatefulWidget {
  @override
  _TeamListState createState() => _TeamListState();
}

class _TeamListState extends State<TeamList> {
  final _scrollController = ScrollController();

  final _scrollThreshold = 200.0;

  TextEditingController _controller;

  TeamBloc _teamBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _controller = TextEditingController();
    _teamBloc = BlocProvider.of<TeamBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text('Team List'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {},
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
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<TeamBloc, TeamState>(
              // ignore: missing_return
              builder: (context, state) {
                if(state is TeamSuccess){
                return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                        itemCount: state.teams.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: EdgeInsets.fromLTRB(4, 4, 4, 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: ColorPallate.mercury,
                        ),
                        child: Center(
                          child: Text(state.teams[index].name,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                      );
                    });
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
      _teamBloc.add(TeamFetched());
    }
  }
}
