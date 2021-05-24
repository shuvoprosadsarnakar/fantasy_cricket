import 'package:fantasy_cricket/models/series.dart';
import 'package:fantasy_cricket/models/team.dart';
import 'package:fantasy_cricket/pages/series/bloc/series_bloc.dart';
import 'package:fantasy_cricket/pages/series/bloc/series_event.dart';
import 'package:fantasy_cricket/pages/series/bloc/series_state.dart';
import 'package:fantasy_cricket/pages/series/cubits/series_add_edit_cubit.dart';
import 'package:fantasy_cricket/pages/series/series_add_edit.dart';
import 'package:fantasy_cricket/pages/team/cubits/team_add_edit_cubit.dart';
import 'package:fantasy_cricket/pages/team/team_add_edit.dart';
import 'package:fantasy_cricket/resources/colours/color_pallate.dart';
import 'package:fantasy_cricket/resources/strings/image_urls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SeriesList extends StatefulWidget {
  @override
  _SeriesListState createState() => _SeriesListState();
}

class _SeriesListState extends State<SeriesList> {
  final _scrollController = ScrollController();

  final _scrollThreshold = 200.0;

  TextEditingController _controller;

  SeriesBloc _seriesBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _controller = TextEditingController();
    _seriesBloc = BlocProvider.of<SeriesBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
        title: Text('Series List'),
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
                  _seriesBloc.add(SeriesSearched(value));
                else
                  _seriesBloc.add(SeriesSearchClosed());
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<SeriesBloc, SeriesState>(
              // ignore: missing_return
              builder: (context, state) {
                if (state is SeriesInitial) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is SeriesFailure) {
                  return Center(
                    child: Text('failed to fetch series'),
                  );
                } else if (state is SeriesSuccess) {
                  if (state.series.isEmpty) {
                    return Center(
                      child: Text('no series'),
                    );
                  }
                  return GridView.builder(
                      controller: _scrollController,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemCount: state.series.length,
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
                builder: (context) =>  SeriesAddEdit(SeriesAddEditCubit(Series()),false)),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  Widget gridCard(SeriesSuccess state, int index, BuildContext context) {
    Series s = state.series[index];
    return InkResponse(
      enableFeedback: true,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SeriesAddEdit(SeriesAddEditCubit(s),false)),
        );
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(4, 4, 4, 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                  fit: BoxFit.fitHeight,
                  image: NetworkImage(
                    state.series[index].photo ?? defaultTeamAvatar,
                  ),
                ),
              ),
            ),
            Text(
              state.series[index].name ?? "",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
              textAlign: TextAlign.center,
            ),
            // Text(
            //   "Players: " + state.teams[index].playersNames.length.toString(),
            //   style: Theme.of(context).textTheme.bodyText1,
            // ),
          ],
        ),
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
      _seriesBloc.add(SeriesFetched());
    }
  }
}
