import 'package:flutter/material.dart';
import 'package:jnu_bus_routes/utils/shared_preferences_helper.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../database/database_helper.dart';
import 'package:go_router/go_router.dart';

class PlaceDetailsScreen extends StatefulWidget {
  final String placeName;
  final int upOrDown = 1 ;

  const PlaceDetailsScreen({
    super.key,
    required this.placeName,
  });

  @override
  _PlaceDetailsScreenState createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  late Future<List<String>> _busNames;

  @override
  void initState() {
    super.initState();
    _loadBusNames();
  }

  Future<void> _loadBusNames() async {
    final dbHelper = DatabaseHelper();
    _busNames = dbHelper.getBusNamesForPlace(widget.placeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.placeName}'s bus list"),
        backgroundColor: Colors.redAccent,
      ),
      body: FutureBuilder<List<String>>(
        future: _busNames,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No place names found.'));
          } else {
            final busNames = snapshot.data!;
            return ListView.builder(
              itemCount: busNames.length,
              itemBuilder: (context, index) {
                final busName = busNames[index];
                return ListTile(
                  title:  ShadCard(
                    title: Text(busName),
leading: const Icon(LucideIcons.bus,size: 35,color: Colors.redAccent,),
                    footer: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                onPressed: () => context.push("/bus/$busName/1"),
                                style: ElevatedButton.styleFrom(
                                  // Text color
                                  elevation: 0, // Remove shadow
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        8), // Optional: Rounded corners
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                onPressed: () => context.push("/bus/$busName/0"),
                                style: ElevatedButton.styleFrom(
                                  // Text color
                                  elevation: 0, // Remove shadow
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        8), // Optional: Rounded corners
                                    side: BorderSide.none, // Remove border
                                  ),
                                ),
                                child: const Text("Down Time")),
                            const Icon(
                              LucideIcons.arrowRight,
                              color: Colors.redAccent,
                              size: 35,
                            )
                          ],
                        ),
                        ShadButton.outline(
                          onPressed: () {
                            SharedPreferencesHelper.setBusName(busName);
                            ShadToaster.of(context).show(
                              ShadToast(
                                title: Text('Selected $busName'),
                                description: Text(
                                    '$busName has been selected as your bus'),
                                action: ShadButton.outline(
                                  child: const Text('Undo'),
                                  onPressed: () => ShadToaster.of(context).hide(),
                                ),
                              ),
                            );
                          },
                          height: 50,
                          child: const Text('Select as your bus'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}