import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/watchlist_bloc.dart';
import '../bloc/watchlist_event.dart';
import '../bloc/watchlist_state.dart';
import '../models/stock.dart';

class EditWatchlistScreen extends StatefulWidget {
  final int watchlistIndex;

  const EditWatchlistScreen({super.key, required this.watchlistIndex});

  @override
  State<EditWatchlistScreen> createState() => _EditWatchlistScreenState();
}

class _EditWatchlistScreenState extends State<EditWatchlistScreen> {
  late List<Stock> _stocks;
  late TextEditingController _nameController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final state = context.read<WatchlistBloc>().state;
    if (state is WatchlistReady) {
      final watchlist = state.watchlists[widget.watchlistIndex];
      _stocks = List<Stock>.from(watchlist.stocks);
      _nameController = TextEditingController(text: watchlist.name);
    } else {
      _stocks = [];
      _nameController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveWatchlist() {
    context.read<WatchlistBloc>().add(
      WatchlistSaved(
        watchlistIndex: widget.watchlistIndex,
        name: _nameController.text,
        stocks: _stocks,
      ),
    );
    Navigator.of(context).pop();
  }

  void _deleteStock(int index) {
    setState(() {
      _stocks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF1A1A2E)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Edit ${_nameController.text}',
          style: TextStyle(
            color: Color(0xFF1A1A2E),
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Divider(height: 1, color: Color(0xFFEEEEEE)),
          Padding(
            padding: EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      enabled: _isEditing,
                      style: TextStyle(
                          fontSize: 14, color: Color(0xFF1A1A2E)),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        isDense: true,
                      ),
                      onSubmitted: (_) {
                        setState(() => _isEditing = false);
                      },
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isEditing ? Icons.check : Icons.edit,
                      size: 18,
                      color: Color(0xFF888888),
                    ),
                    onPressed: () {
                      setState(() => _isEditing = !_isEditing);
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ReorderableListView.builder(
              buildDefaultDragHandles: false,
              itemCount: _stocks.length,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex--;
                  final item = _stocks.removeAt(oldIndex);
                  _stocks.insert(newIndex, item);
                });
              },
              itemBuilder: (context, index) {
                final stock = _stocks[index];
                return _EditStockTile(
                  key: ValueKey('${stock.symbol}_$index'),
                  stock: stock,
                  index: index,
                  onDelete: () => _deleteStock(index),
                );
              },
            ),
          ),
      Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xFFEEEEEE)),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFDDDDDD)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'Edit other watchlists',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: _saveWatchlist,
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF262729),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      'Save Watchlist',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )))
        ],
      ),
    );
  }
}

class _EditStockTile extends StatelessWidget {
  final Stock stock;
  final int index;
  final VoidCallback onDelete;

  const _EditStockTile({
    super.key,
    required this.stock,
    required this.index,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFEEEEEE), width: 0.8),
        ),
      ),
      child: Row(
        children: [
          ReorderableDragStartListener(
            index: index,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 18,
                    height: 1.5,
                    color: Color(0xFF999999),
                    margin: EdgeInsets.symmetric(vertical: 1.5),
                  ),
                  Container(
                    width: 18,
                    height: 1.5,
                    color: Color(0xFF999999),
                    margin: EdgeInsets.symmetric(vertical: 1.5),
                  ),
                  Container(
                    width: 18,
                    height: 1.5,
                    color: Color(0xFF999999),
                    margin: EdgeInsets.symmetric(vertical: 1.5),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Text(
              stock.symbol,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF888888),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Color(0xFF1A1A2E),
              size: 20,
            ),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}