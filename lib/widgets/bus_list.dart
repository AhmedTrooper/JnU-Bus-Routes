import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jnu_bus_routes/database/database_helper.dart';
import 'package:jnu_bus_routes/providers/bus_provider.dart';
import 'package:jnu_bus_routes/providers/route_provider.dart';
import 'package:jnu_bus_routes/providers/theme_provider.dart';
import 'package:jnu_bus_routes/utils/shared_preferences_helper.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class BusList extends ConsumerStatefulWidget {
  List<Map<String, dynamic>> busNames = [];

  BusList({super.key, required this.busNames});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _BusListState();
  }
}

class _BusListState extends ConsumerState<BusList>
    with SingleTickerProviderStateMixin {
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
    final bgColor = ref.watch(backgroundColor);
    int stColor = bgColor.value;
    // final busNameFromProvider = ref.watch(busNameProvider);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: widget.busNames.length,
        (context, index) {
          final busName = widget.busNames[index];
          return FadeTransition(
            opacity: _animation,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Card(
                color: Color(stColor),
                elevation: 20,
                shadowColor: Colors.black.withOpacity(1),
                borderOnForeground: true,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: 30,
                              ),
                              Text(
                                "${busName['last_stoppage']}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                    color: Theme.of(context).brightness !=
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.white),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(
                              LucideIcons.bookmarkPlus,
                              color: Colors.white,
                              size: 30,
                            ),
                            onPressed: () async => {
                              SharedPreferencesHelper.setBusName(
                                  busName['bus_name']),
                              ref.read(busNameProvider.notifier).state =
                                  busName['bus_name'],
                              ref.read(routeListProvider.notifier).state =
                                  await DatabaseHelper().getBusInfo(
                                      busName: busName['bus_name'], busType: 1),
                              if (context.mounted)
                                {
                                  ShadToaster.of(context).show(
                                    ShadToast(
                                      title: const Text('Selected'),
                                      border: Border(
                                        bottom: BorderSide(
                                            width: 2,
                                            color:
                                                Theme.of(context).brightness !=
                                                        Brightness.dark
                                                    ? Colors.transparent
                                                    : Colors.grey[800]!,
                                            style: BorderStyle.solid),
                                        top: BorderSide(
                                            color:
                                                Theme.of(context).brightness !=
                                                        Brightness.dark
                                                    ? Colors.transparent
                                                    : Colors.grey[800]!,
                                            style: BorderStyle.solid),
                                        right: BorderSide(
                                            color:
                                                Theme.of(context).brightness !=
                                                        Brightness.dark
                                                    ? Colors.transparent
                                                    : Colors.grey[800]!,
                                            style: BorderStyle.solid),
                                        left: BorderSide(
                                            color:
                                                Theme.of(context).brightness !=
                                                        Brightness.dark
                                                    ? Colors.transparent
                                                    : Colors.grey[800]!,
                                            style: BorderStyle.solid),
                                      ),
                                      description: Text(
                                          '${busName['bus_name']} has been selected as your bus'),
                                      action: ShadButton.outline(
                                        child: const Text('Close'),
                                        onPressed: () =>
                                            ShadToaster.of(context).hide(),
                                      ),
                                    ),
                                  )
                                }
                            },
                            color: Color(stColor),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(stColor),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              fixedSize: const Size(50, 50),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      //Bus name section....

                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "🚎 ${busName['bus_name']}",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).brightness != Brightness.dark
                                    ? Colors.white
                                    : Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                onPressed: () => context
                                    .push("/bus/${busName['bus_name']}/1"),
                                icon: const Icon(
                                  Icons.arrow_upward_outlined,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                              IconButton(
                                onPressed: () => context
                                    .push("/bus/${busName['bus_name']}/0"),
                                icon: const Icon(
                                  Icons.arrow_downward_outlined,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${busName['up_time']}-${busName['down_time']}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      )
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
