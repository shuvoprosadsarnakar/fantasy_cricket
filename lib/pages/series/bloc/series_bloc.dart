import 'dart:async';
import 'package:fantasy_cricket/pages/series/bloc/series_event.dart';
import 'package:fantasy_cricket/pages/series/bloc/series_state.dart';
import 'package:fantasy_cricket/repositories/series_repo.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc/bloc.dart';

class SeriesBloc extends Bloc<SeriesEvent, SeriesState> {
  final int limit = 20;
  SeriesBloc() : super(SeriesInitial());

  @override
  Stream<Transition<SeriesEvent, SeriesState>> transformEvents(
    Stream<SeriesEvent> events,
    TransitionFunction<SeriesEvent, SeriesState> transitionFn,
  ) {
    return super.transformEvents(
      events.debounceTime(const Duration(milliseconds: 500)),
      transitionFn,
    );
  }

  @override
  Stream<SeriesState> mapEventToState(SeriesEvent event) async* {
    final currentState = state;
    if (event is SeriesFetched && !_hasReachedMax(currentState)) {
      try {
        if (currentState is SeriesInitial) {
          final series = await SeriesRepo.fetchSeries(0, limit);
          if (series.length < limit)
            yield SeriesSuccess(series: series, hasReachedMax: true);
          else
            yield SeriesSuccess(series: series, hasReachedMax: false);
          return;
        }
        if (currentState is SeriesSuccess) {
          final series = await SeriesRepo.fetchSeries(1, limit);
          if (series.length < limit)
            yield SeriesSuccess(
                series: currentState.series + series, hasReachedMax: true);
          else
            yield SeriesSuccess(
                series: currentState.series + series, hasReachedMax: false);
        }
      } catch (error) {
        print(error);
        yield SeriesFailure();
      }
    }
    if (event is SeriesSearched) {
      print("Series searched bloc");
      if (currentState is SeriesSuccess) {
        final series = await SeriesRepo.searchTeams(event.searchKeyWord, limit);
        if (series != null) {
          if (series.length < limit)
            yield SeriesSuccess(series: series, hasReachedMax: true);
          else
            yield SeriesSuccess(series: series, hasReachedMax: false);
        }
      }
    }
    if (event is SeriesSearchClosed) {
      final series = await SeriesRepo.fetchSeries(0, limit);
      if (series.length < limit)
        yield SeriesSuccess(series: series, hasReachedMax: true);
      else
        yield SeriesSuccess(series: series, hasReachedMax: false);
    }
    if (event is SeriesDelete) {
      SeriesRepo.deleteSeries(event.series);
    }
  }

  bool _hasReachedMax(SeriesState state) =>
      state is SeriesSuccess && state.hasReachedMax;
}
