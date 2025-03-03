import 'package:flutter/material.dart';
import 'package:jnu_bus_routes/utils/shared_preferences_helper.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:go_router/go_router.dart';


class BusList extends StatefulWidget{
  List<Map<String, dynamic>> busNames = [];
  BusList({super.key, required this.busNames});
  @override
  State<StatefulWidget> createState() {
    return _BusListState();
  }
}

class _BusListState extends State<BusList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1200,
      padding: const EdgeInsets.all(20),

      width: double.infinity,
      child: ListView.builder(
        itemCount: widget.busNames.length,
        itemBuilder: (context, index) {
          final busName = widget.busNames[index];
          return ListTile(
            title: ShadCard(
              title: Text(busName['bus_name']),
              width: double.infinity,
              columnCrossAxisAlignment: CrossAxisAlignment.center,
              rowMainAxisAlignment: MainAxisAlignment.center,
              footer: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () => context.push("/bus/${busName['bus_name']}/1"),
                          style: ElevatedButton.styleFrom(
                            elevation: 0, // Remove shadow
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  8), // Optional: Rounded corners
                              side: BorderSide.none, // Remove border
                            ),
                          ),
                          child: const Text("Up Time Route")),
                      const Icon(
                        LucideIcons.arrowRight,
                        color: Colors.redAccent,
                        size: 35,
                      )
                    ],
                  ),
                  ShadButton.outline(
                    onPressed: () {
                      SharedPreferencesHelper.setBusName(busName['bus_name']);
                      ShadToaster.of(context).show(
                        ShadToast(
                          title: Text('Selected ${busName['bus_name']}'),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () => context.push("/bus/${busName['bus_name']}/0"),
                          style: ElevatedButton.styleFrom(
                            // Text color
                            elevation: 0, // Remove shadow
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  8), // Optional: Rounded corners
                              side: BorderSide.none, // Remove border
                            ),
                          ),
                          child: const Text("Down Time Route")),
                      const Icon(
                        LucideIcons.arrowRight,
                        color: Colors.redAccent,
                        size: 35,
                      )
                    ],
                  ),

                  ShadButton.outline(
                    height: 50,
                    width: 120,
                    child: Text(busName['up_time'])
                    ,
                  ),
                  ShadButton.outline(
                      height: 50,
                      width: 120,
                      child: Text(busName['down_time'])
                  ),

                  ShadButton.outline(
                      height: 50,
                      width: 300,
                      child: Text("Last stop: ${busName['last_stoppage']}")
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}