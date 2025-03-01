import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../database/database_helper.dart';

class BusTab extends StatefulWidget {
  const BusTab({super.key});
  @override
  State<StatefulWidget> createState() {
    return _BusTabState();
  }
}

class _BusTabState extends State<BusTab>{


  List<String> _busNames = [];
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
      print('Error loading bus names: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
      itemCount: _busNames.length,
      itemBuilder: (context, index) {
        final busName = _busNames[index];
        return ListTile(
          title: ShadCard(
            title: Text(busName),
            footer: Column(
              children: [
                Row(
                  children: [
                    ElevatedButton(onPressed: ()=>context.push("/bus/$busName/1"),
                        style: ElevatedButton.styleFrom(// Text color
                          elevation: 0, // Remove shadow
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // Optional: Rounded corners
                            side: BorderSide.none, // Remove border
                          ),
                        ),
                        child: const Text("Up Time")),
                    const Icon(
                      LucideIcons.arrowRight,
                      color: Colors.redAccent,
                      size: 35,
                    )
                  ],
                ),
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: ()=>context.push("/bus/$busName/0"),
        style: ElevatedButton.styleFrom(// Text color
        elevation: 0, // Remove shadow
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Optional: Rounded corners
        side: BorderSide.none, // Remove border
        ),
        ), child: const Text("Down Time")),                    const Icon(
                      LucideIcons.arrowRight,
                      color: Colors.redAccent,
                      size: 35,
                    )
                  ],
                ),

              ],
            )
          ),
          onTap: () {
            context.push("/bus/$busName");
          },
        );
      },
    );
  }
}