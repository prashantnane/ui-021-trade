import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/watchlist_state.dart';
import '../screens/watchlist_screen.dart';
import '../models/stock.dart';
import 'watchlist_event.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  WatchlistBloc() : super(const WatchlistInitial()) {
    on<WatchlistLoaded>(_onLoaded);
    on<WatchlistTabChanged>(_onTabChanged);
    on<WatchlistStockReordered>(_onStockReordered);
    on<WatchlistStockDeleted>(_onStockDeleted);
    on<WatchlistSaved>(_onSaved);
    on<WatchlistNameChanged>(_onNameChanged);
  }

  void _onLoaded(WatchlistLoaded event, Emitter<WatchlistState> emit) {
    emit(const WatchlistLoading());

    final watchlists = [
      Watchlist(
        name: 'Watchlist 1',
        stocks: [
          const Stock(
            symbol: 'RELIANCE',
            exchange: 'NSE',
            type: 'EQ',
            price: 1374.10,
            change: -4.40,
            changePercent: -0.32,
          ),
          const Stock(
            symbol: 'HDFCBANK',
            exchange: 'NSE',
            type: 'EQ',
            price: 966.85,
            change: 0.85,
            changePercent: 0.09,
          ),
          const Stock(
            symbol: 'ASIANPAINT',
            exchange: 'NSE',
            type: 'EQ',
            price: 2537.40,
            change: 6.60,
            changePercent: 0.26,
          ),
          const Stock(
            symbol: 'NIFTY IT',
            exchange: 'NSE',
            type: 'IDX',
            price: 35187.30,
            change: 876.86,
            changePercent: 2.56,
          ),
          const Stock(
            symbol: 'RELIANCE SEP 1880 CE',
            exchange: 'NSE',
            type: 'Monthly',
            price: 0.00,
            change: 0.00,
            changePercent: 0.00,
          ),
          const Stock(
            symbol: 'RELIANCE SEP 1370 PE',
            exchange: 'NSE',
            type: 'Monthly',
            price: 19.20,
            change: 1.00,
            changePercent: 5.49,
          ),
          const Stock(
            symbol: 'MRF',
            exchange: 'NSE',
            type: 'EQ',
            price: 147625.00,
            change: 550.00,
            changePercent: 0.37,
          ),
          const Stock(
            symbol: 'MRF',
            exchange: 'NSE',
            type: 'EQ',
            price: 147439.45,
            change: -180.00,
            changePercent: -0.12,
          ),
        ],
      ),
      Watchlist(
        name: 'Watchlist 5',
        stocks: [
          const Stock(
            symbol: 'TCS',
            exchange: 'NSE',
            type: 'EQ',
            price: 3456.75,
            change: 23.50,
            changePercent: 0.68,
          ),
          const Stock(
            symbol: 'INFOSYS',
            exchange: 'NSE',
            type: 'EQ',
            price: 1678.30,
            change: -12.20,
            changePercent: -0.72,
          ),
        ],
      ),
      Watchlist(
        name: 'Watchlist 6',
        stocks: [
          const Stock(
            symbol: 'TATAMOTORS',
            exchange: 'NSE',
            type: 'EQ',
            price: 945.60,
            change: 15.30,
            changePercent: 1.65,
          ),
        ],
      ),
    ];

    emit(WatchlistReady(watchlists: watchlists));
  }

  void _onTabChanged(WatchlistTabChanged event, Emitter<WatchlistState> emit) {
    if (state is WatchlistReady) {
      emit((state as WatchlistReady).copyWith(selectedTabIndex: event.tabIndex));
    }
  }

  void _onStockReordered(
      WatchlistStockReordered event, Emitter<WatchlistState> emit) {
    if (state is WatchlistReady) {
      final current = state as WatchlistReady;
      final watchlists = List<Watchlist>.from(current.watchlists);
      final stocks = List<Stock>.from(watchlists[event.watchlistIndex].stocks);

      int newIndex = event.newIndex;
      if (newIndex > event.oldIndex) newIndex--;

      final item = stocks.removeAt(event.oldIndex);
      stocks.insert(newIndex, item);

      watchlists[event.watchlistIndex] =
          watchlists[event.watchlistIndex].copyWith(stocks: stocks);

      emit(current.copyWith(watchlists: watchlists));
    }
  }

  void _onStockDeleted(
      WatchlistStockDeleted event, Emitter<WatchlistState> emit) {
    if (state is WatchlistReady) {
      final current = state as WatchlistReady;
      final watchlists = List<Watchlist>.from(current.watchlists);
      final stocks = List<Stock>.from(watchlists[event.watchlistIndex].stocks);

      stocks.removeAt(event.stockIndex);

      watchlists[event.watchlistIndex] =
          watchlists[event.watchlistIndex].copyWith(stocks: stocks);

      emit(current.copyWith(watchlists: watchlists));
    }
  }

  void _onSaved(WatchlistSaved event, Emitter<WatchlistState> emit) {
    if (state is WatchlistReady) {
      final current = state as WatchlistReady;
      final watchlists = List<Watchlist>.from(current.watchlists);

      watchlists[event.watchlistIndex] = Watchlist(
        name: event.name,
        stocks: event.stocks,
      );

      emit(current.copyWith(watchlists: watchlists));
    }
  }

  void _onNameChanged(
      WatchlistNameChanged event, Emitter<WatchlistState> emit) {
    if (state is WatchlistReady) {
      final current = state as WatchlistReady;
      final watchlists = List<Watchlist>.from(current.watchlists);

      watchlists[event.watchlistIndex] =
          watchlists[event.watchlistIndex].copyWith(name: event.name);

      emit(current.copyWith(watchlists: watchlists));
    }
  }
}