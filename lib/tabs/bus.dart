import 'package:flutter/material.dart';
import 'package:jnu_bus_routes/database/database_helper.dart';
import 'package:jnu_bus_routes/widgets/bus_list.dart';

class BusTab extends StatefulWidget {
  const BusTab({super.key});

  @override
  State<StatefulWidget> createState() {
    return _BusTabState();
  }
}

class _BusTabState extends State<BusTab> {
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
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 50,
          ),
        ),
        BusList(busNames: _busNames)
      ],
    );
  }
}
