
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
                elevation: 10,
                shadowColor: Colors.black.withOpacity(1),
                borderOnForeground: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side:  BorderSide(
                      color: Theme.of(context).brightness != Brightness.dark ? Colors.white : Colors.redAccent,                    width: 1
                  )
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        busName['bus_name'],
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () =>{
                SharedPreferencesHelper.setBusName(busName['bus_name']),
                ShadToaster.of(context).show(
                ShadToast(
                title: const Text('Selected'),
                description: Text('${busName['bus_name']} has been selected as your bus'),
                action: ShadButton.outline(
                child: const Text('Close'),
                onPressed: () => ShadToaster.of(context).hide(),
                ),
                ),
                )
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                elevation: 2, // Add subtle shadow
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10), // Rounded corners
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                fixedSize: const Size(200, 50)
                            ),
                            child: const Icon(Icons.add,color: Colors.white,size: 35,)
                          ),

                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () => context.push("/bus/${busName['bus_name']}/1"),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                              elevation: 2, // Add subtle shadow
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                // Rounded corners
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              fixedSize: const Size(200, 50)
                            ),
                            child: const Icon(Icons.arrow_circle_down,color: Colors.white,size: 35,)
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
                              backgroundColor: Colors.redAccent,
                              elevation: 2, // Add subtle shadow
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10), // Rounded corners
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                fixedSize: const Size(200, 50),
                            ),
                            child: const Icon(Icons.arrow_circle_up,color: Colors.white,size: 35,),

                          ),

                        ],
                      ),

                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: (){},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              elevation: 2, // Add subtle shadow
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10), // Rounded corners
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              fixedSize: const Size(200, 50),
                            ),
                            child:  Text("${busName['up_time']}-${busName['down_time']}",
                              style:  const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                              ),
                            ),

                          ),

                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // const Icon(Icons.location_on,color: Colors.redAccent,size: 35,),
                          ElevatedButton(
                            onPressed: (){},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 2, // Add subtle shadow
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10), // Rounded corners
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              // fixedSize: const Size(100, 100),
                            ),
                            child:  Column(
                              children: [
                                const Icon(Icons.location_on,color: Colors.redAccent,size: 35,),
                                Text("${busName['last_stoppage']}",
                                  style:  const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.redAccent,
                                  ),
                                ),
                              ],
                            )

                          ),

                        ],
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
