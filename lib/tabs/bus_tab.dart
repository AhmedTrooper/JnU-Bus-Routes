import 'package:flutter/material.dart';
import 'package:jnu_bus_routes/widgets/bus_list.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../database/database_helper.dart';

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
      final busNames = await dbHelper.getBusList();
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
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView(
      children: [
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShadButton.outline(
             height: 50,
              width: 120,
              backgroundColor: Colors.transparent,
              child: const Text("Bus List",style: TextStyle(
                fontSize: 20
              ),),
              onPressed: () {},
            ),

          ],
        ),
        BusList(busNames: _busNames),

      ],
    );
  }
}
