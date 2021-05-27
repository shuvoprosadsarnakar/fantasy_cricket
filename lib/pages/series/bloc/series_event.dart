import 'package:equatable/equatable.dart';
import 'package:fantasy_cricket/models/series.dart';

abstract class SeriesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SeriesFetched extends SeriesEvent {}

class SeriesSearchClosed extends SeriesEvent {}

class SeriesSearched extends SeriesEvent {
  final String searchKeyWord;

  SeriesSearched(this.searchKeyWord);

  @override
  List<Object> get props => [searchKeyWord];
}

class SeriesDelete extends SeriesEvent {
  final Series series;

  SeriesDelete(this.series);

  @override
  List<Object> get props => [series];
}
