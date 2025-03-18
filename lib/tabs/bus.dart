import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jnu_bus_routes/database/database_helper.dart';
import 'package:jnu_bus_routes/widgets/bus_list.dart';

class BusTab extends ConsumerStatefulWidget {
  const BusTab({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _BusTabState();
  }
}

class _BusTabState extends ConsumerState<BusTab> {
  List<Map<String, dynamic>> _busNames = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBusNames();
  }

  Future<void> _loadBusNames() async {
    try {
      final dbHelper = DatabaseHelper();
      final busNames = await dbHelper.getBusInfo();
      setState(() {
        _busNames = busNames;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          surfaceTintColor: Theme.of(context).brightness != Brightness.dark
              ? Colors.transparent
              : Colors.transparent,
          scrolledUnderElevation: 0.0,
          toolbarHeight: 50,
          title: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Text(
              "Buses",
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness != Brightness.dark
                      ? Colors.black
                      : Colors.white),
            ),
          ),
          backgroundColor: Theme.of(context).brightness != Brightness.dark
              ? Colors.white
              : Colors.black12,
          pinned: true,
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 20,
          ),
        ),
        BusList(busNames: _busNames),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 50,
          ),
        )
      ],
    );
  }
}
