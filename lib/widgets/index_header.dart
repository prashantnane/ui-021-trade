import 'package:flutter/material.dart';

class IndexHeader extends StatelessWidget {
  const IndexHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: _IndexCard(
              title: 'SENSEX 18TH SEP 8...',
              exchange: 'BSE',
              price: '1,225.55',
              change: '144.50 (13.3...',
              isPositive: true,
            ),
          ),
          Container(width: 1, height: 40, color: Color(0xFFEEEEEE)),
          Expanded(
            child: _IndexCard(
              title: 'NIFTY BANK',
              exchange: '',
              price: '54,170.15',
              change: '-16.75 (-0.03...',
              isPositive: false,
              showArrow: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _IndexCard extends StatelessWidget {
  final String title;
  final String exchange;
  final String price;
  final String change;
  final bool isPositive;
  final bool showArrow;

  const _IndexCard({
    required this.title,
    required this.exchange,
    required this.price,
    required this.change,
    required this.isPositive,
    this.showArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    final changeColor =
    isPositive ? Color(0xFF1A9E6A) : Color(0xFFE8453C);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  exchange.isNotEmpty ? '$title  $exchange' : title,
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF555555),
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (showArrow)
                Icon(Icons.arrow_forward_ios,
                    size: 12, color: Color(0xFF888888)),
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Text(
                price,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  change,
                  style: TextStyle(fontSize: 11, color: changeColor),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}