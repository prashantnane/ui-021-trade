import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/watchlist_bloc.dart';
import '../bloc/watchlist_event.dart';
import '../bloc/watchlist_state.dart';
import '../widgets/index_header.dart';
import '../widgets/stock_tile.dart';
import 'edit_watchlist_screen.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistBloc, WatchlistState>(
      builder: (context, state) {
        if (state is WatchlistLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is WatchlistReady) {
          return _WatchlistView(state: state);
        }

        return const Scaffold(
          body: Center(child: Text('Something went wrong')),
        );
      },
    );
  }
}

class _WatchlistView extends StatelessWidget {
  final WatchlistReady state;

  const _WatchlistView({required this.state});

  @override
  Widget build(BuildContext context) {
    final watchlist = state.currentWatchlist;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const IndexHeader(),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  style: TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'Search for instruments',
                    hintStyle:
                    TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
                    prefixIcon:
                    Icon(Icons.search, color: Color(0xFFAAAAAA), size: 20),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFFEEEEEE), width: 1),
                ),
              ),
              child: Row(
                children: List.generate(state.watchlists.length, (i) {
                  final isSelected = i == state.selectedTabIndex;
                  return GestureDetector(
                    onTap: () => context
                        .read<WatchlistBloc>()
                        .add(WatchlistTabChanged(i)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: isSelected
                                ? Color(0xFF1A1A2E)
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        state.watchlists[i].name,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isSelected
                              ? Color(0xFF1A1A2E)
                              : Color(0xFF9E9E9E),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Padding(
              padding:
              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                children: [
                  Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.tune, size: 16, color: Color(0xFF555555)),
                        SizedBox(width: 4),
                        Text(
                          'Sort by',
                          style: TextStyle(
                              fontSize: 13, color: Color(0xFF555555)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: watchlist.stocks.length,
                itemBuilder: (context, index) {
                  final stock = watchlist.stocks[index];
                  return StockTile(
                    stock: stock,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<WatchlistBloc>(),
                            child: EditWatchlistScreen(
                              watchlistIndex: state.selectedTabIndex,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF2B2C2F),
        unselectedItemColor: const Color(0xFFC1C0C0),
        selectedLabelStyle:
        TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
        unselectedLabelStyle: TextStyle(fontSize: 10),
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border, size: 22),
            activeIcon: Icon(Icons.bookmark_border, size: 22),
            label: 'Watchlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined, size: 22),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bolt_outlined, size: 22),
            label: 'GTT+',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business_center_outlined, size: 22),
            label: 'Portfolio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined, size: 22),
            label: 'Funds',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: 22),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}