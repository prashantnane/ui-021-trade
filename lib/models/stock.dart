import 'package:equatable/equatable.dart';

class Stock extends Equatable {
  final String symbol;
  final String exchange;
  final String type;
  final double price;
  final double change;
  final double changePercent;

  const Stock({
    required this.symbol,
    required this.exchange,
    required this.type,
    required this.price,
    required this.change,
    required this.changePercent,
  });

  bool get isPositive => change >= 0;

  Stock copyWith({
    String? symbol,
    String? exchange,
    String? type,
    double? price,
    double? change,
    double? changePercent,
  }) {
    return Stock(
      symbol: symbol ?? this.symbol,
      exchange: exchange ?? this.exchange,
      type: type ?? this.type,
      price: price ?? this.price,
      change: change ?? this.change,
      changePercent: changePercent ?? this.changePercent,
    );
  }

  @override
  List<Object?> get props =>
      [symbol, exchange, type, price, change, changePercent];
}

class Watchlist extends Equatable {
  final String name;
  final List<Stock> stocks;

  const Watchlist({required this.name, required this.stocks});

  Watchlist copyWith({String? name, List<Stock>? stocks}) {
    return Watchlist(
      name: name ?? this.name,
      stocks: stocks ?? this.stocks,
    );
  }

  @override
  List<Object?> get props => [name, stocks];
}