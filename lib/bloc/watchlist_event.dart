import 'package:equatable/equatable.dart';

import '../models/stock.dart';

abstract class WatchlistEvent extends Equatable {
  const WatchlistEvent();

  @override
  List<Object?> get props => [];
}

class WatchlistLoaded extends WatchlistEvent {
  const WatchlistLoaded();
}

class WatchlistTabChanged extends WatchlistEvent {
  final int tabIndex;
  const WatchlistTabChanged(this.tabIndex);

  @override
  List<Object?> get props => [tabIndex];
}

class WatchlistStockReordered extends WatchlistEvent {
  final int watchlistIndex;
  final int oldIndex;
  final int newIndex;

  const WatchlistStockReordered({
    required this.watchlistIndex,
    required this.oldIndex,
    required this.newIndex,
  });

  @override
  List<Object?> get props => [watchlistIndex, oldIndex, newIndex];
}

class WatchlistStockDeleted extends WatchlistEvent {
  final int watchlistIndex;
  final int stockIndex;

  const WatchlistStockDeleted({
    required this.watchlistIndex,
    required this.stockIndex,
  });

  @override
  List<Object?> get props => [watchlistIndex, stockIndex];
}

class WatchlistSaved extends WatchlistEvent {
  final int watchlistIndex;
  final String name;
  final List<Stock> stocks;

  const WatchlistSaved({
    required this.watchlistIndex,
    required this.name,
    required this.stocks,
  });

  @override
  List<Object?> get props => [watchlistIndex, name, stocks];
}

class WatchlistNameChanged extends WatchlistEvent {
  final int watchlistIndex;
  final String name;

  const WatchlistNameChanged({
    required this.watchlistIndex,
    required this.name,
  });

  @override
  List<Object?> get props => [watchlistIndex, name];
}