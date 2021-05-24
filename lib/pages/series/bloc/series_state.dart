import 'package:equatable/equatable.dart';
import 'package:fantasy_cricket/models/series.dart';
import 'package:fantasy_cricket/models/team.dart';

abstract class SeriesState extends Equatable {
  const SeriesState();

  @override
  List<Object> get props => [];
}

class SeriesInitial extends SeriesState {}

class SeriesFailure extends SeriesState {}

class SeriesSuccess extends SeriesState {
  final List<Series> series;
  final bool hasReachedMax;

  const SeriesSuccess({
    this.series,
    this.hasReachedMax,
  });

  SeriesSuccess copyWith({
    List<Series> series,
    bool hasReachedMax,
  }) {
    return SeriesSuccess(
      series: series ?? this.series,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [series, hasReachedMax,];

  @override
  String toString() =>
      'SeriesSuccess { Teams: ${series.length}, hasReachedMax: $hasReachedMax ,';
}
