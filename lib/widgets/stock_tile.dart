import 'package:flutter/material.dart';
import '../models/stock.dart';

class StockTile extends StatelessWidget {
  final Stock stock;
  final VoidCallback onTap;

  const StockTile({
    super.key,
    required this.stock,
    required this.onTap,
  });

  String _formatPrice(double price) {
    final parts = price.toStringAsFixed(2).split('.');
    final intPart = parts[0];
    final decPart = parts[1];

    if (intPart.length <= 3) return '$intPart.$decPart';

    final thousands = intPart.substring(intPart.length - 3);
    final rest = intPart.substring(0, intPart.length - 3);
    final restFormatted = rest.replaceAllMapped(
      RegExp(r'(\d{1,2})(?=(\d{2})+$)'),
          (m) => '${m[1]},',
    );

    return '$restFormatted,$thousands.$decPart';
  }

  String _formatChange(double change, double changePercent) {
    final sign = change >= 0 ? '' : '-';
    final changeStr = change.abs().toStringAsFixed(2);
    final percentStr = changePercent.abs().toStringAsFixed(2);
    return '$sign$changeStr ($sign$percentStr%)';
  }

  @override
  Widget build(BuildContext context) {
    final color = stock.isPositive ? Color(0xFF1A9E6A) : Color(0xFFE8453C);

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Color(0xFFEEEEEE), width: 0.8),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stock.symbol,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${stock.exchange} | ${stock.type}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF9E9E9E),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatPrice(stock.price),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  _formatChange(stock.change, stock.changePercent),
                  style: TextStyle(
                    fontSize: 11,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}