import 'package:equatable/equatable.dart';
import 'package:fantasy_cricket/models/team.dart';

abstract class SeriesState extends Equatable {
  const SeriesState();

  @override
  List<Object> get props => [];
}

class SeriesInitial extends SeriesState {}

class SeriesFailure extends SeriesState {}

class SeriesSuccess extends SeriesState {
  final List<Team> series;
  final bool hasReachedMax;

  const SeriesSuccess({
    this.series,
    this.hasReachedMax,
  });

  SeriesSuccess copyWith({
    List<Team> teams,
    bool hasReachedMax,
  }) {
    return SeriesSuccess(
      series: teams ?? this.series,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [series, hasReachedMax,];

  @override
  String toString() =>
      'SeriesSuccess { Teams: ${series.length}, hasReachedMax: $hasReachedMax ,';
}
