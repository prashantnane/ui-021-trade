import 'package:equatable/equatable.dart';

import '../models/stock.dart';

abstract class WatchlistState extends Equatable {
  const WatchlistState();

  @override
  List<Object?> get props => [];
}

class WatchlistInitial extends WatchlistState {
  const WatchlistInitial();
}

class WatchlistLoading extends WatchlistState {
  const WatchlistLoading();
}

class WatchlistReady extends WatchlistState {
  final List<Watchlist> watchlists;
  final int selectedTabIndex;

  const WatchlistReady({
    required this.watchlists,
    this.selectedTabIndex = 0,
  });

  Watchlist get currentWatchlist => watchlists[selectedTabIndex];

  WatchlistReady copyWith({
    List<Watchlist>? watchlists,
    int? selectedTabIndex,
  }) {
    return WatchlistReady(
      watchlists: watchlists ?? this.watchlists,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
    );
  }

  @override
  List<Object?> get props => [watchlists, selectedTabIndex];
}

class WatchlistError extends WatchlistState {
  final String message;
  const WatchlistError(this.message);

  @override
  List<Object?> get props => [message];
}