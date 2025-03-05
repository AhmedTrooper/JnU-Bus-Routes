
import 'package:flutter/material.dart';
import 'package:jnu_bus_routes/utils/shared_preferences_helper.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:go_router/go_router.dart';

class BusList extends StatefulWidget {
  List<Map<String, dynamic>> busNames = [];
  BusList({super.key, required this.busNames});
  @override
  State<StatefulWidget> createState() {
    return _BusListState();
  }
}

class _BusListState extends State<BusList> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: widget.busNames.length,
            (context, index) {
          final busName = widget.busNames[index];
          return FadeTransition(
            opacity: _animation,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Card(
                elevation: 6,
                shadowColor: Colors.black.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        busName['bus_name'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,

                        ),
                      ),
                      const SizedBox(height: 10),
                      ShadButton.outline(
                        onPressed: () {
                          SharedPreferencesHelper.setBusName(busName['bus_name']);
                          ShadToaster.of(context).show(
                            ShadToast(
                              title: Text('Selected ${busName['bus_name']}'),
                              description: Text('${busName['bus_name']} has been selected as your bus'),
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
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () => context.push("/bus/${busName['bus_name']}/1"),
                            style: ElevatedButton.styleFrom(
                              elevation: 2, // Add subtle shadow
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10), // Rounded corners
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            child: const Text("See Up Time Route"),
                          ),

                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () => context.push("/bus/${busName['bus_name']}/0"),
                            style: ElevatedButton.styleFrom(
                              elevation: 2, // Add subtle shadow
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10), // Rounded corners
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            child: const Text("See Down Time Route"),
                          ),

                        ],
                      ),
                      const SizedBox(height: 10),
                      ShadButton.outline(
                        height: 50,
                        width: 120,
                        child: Text(busName['up_time']),
                      ),
                      const SizedBox(height: 10),
                      ShadButton.outline(
                        height: 50,
                        width: 120,
                        child: Text(busName['down_time']),
                      ),
                      const SizedBox(height: 10),
                      ShadButton.outline(
                        height: 50,
                        width: 300,
                        child: Text("Last stop: ${busName['last_stoppage']}"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
