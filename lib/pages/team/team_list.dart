import 'package:fantasy_cricket/models/team.dart';
import 'package:fantasy_cricket/pages/team/bloc/team_bloc.dart';
import 'package:fantasy_cricket/pages/team/cubits/team_add_edit_cubit.dart';
import 'package:fantasy_cricket/pages/team/team_add_edit.dart';
import 'package:fantasy_cricket/resources/colours/color_pallate.dart';
import 'package:fantasy_cricket/resources/strings/image_urls.dart';
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
              },
              onChanged: (value) {
                print(value);
                if (value.length > 0)
                  _teamBloc.add(TeamSearched(value));
                else
                  _teamBloc.add(TeamSearchClosed());
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<TeamBloc, TeamState>(
              // ignore: missing_return
              builder: (context, state) {
                if (state is TeamInitial) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is TeamFailure) {
                  return Center(
                    child: Text('failed to fetch Teams'),
                  );
                } else if (state is TeamSuccess) {
                  if (state.teams.isEmpty) {
                    return Center(
                      child: Text('no teams'),
                    );
                  }
                  return GridView.builder(
                      controller: _scrollController,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemCount: state.teams.length,
                      itemBuilder: (BuildContext context, int index) {
                        return gridCard(state, index, context);
                      });
                }
              },
            ),
          ),
        ],
      ),
            floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TeamAddEdit(TeamAddEditCubit(Team()))),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  Container gridCard(TeamSuccess state, int index, BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(4, 4, 4, 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: ColorPallate.mercury,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fitHeight,
                image: NetworkImage(
                  state.teams[index].photo ?? defaultTeamAvatar,
                ),
              ),
            ),
          ),
          Text(
            state.teams[index].name,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          // Text(
          //   "Players: " + state.teams[index].playersNames.length.toString(),
          //   style: Theme.of(context).textTheme.bodyText1,
          // ),
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
