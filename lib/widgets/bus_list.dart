import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: widget.busNames.length,
        (context, index) {
          final busName = widget.busNames[index];
          return FadeTransition(
            opacity: _animation,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Card(
                elevation: 10,
                shadowColor: Colors.black.withOpacity(1),
                borderOnForeground: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(
                        color: Theme.of(context).brightness != Brightness.dark
                            ? Colors.white
                            : Colors.grey[800]!,
                        width: 1)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          busName['bus_name'],
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).brightness != Brightness.dark
                                    ? Color(stColor)
                                    : Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              onPressed: () => {
                                    SharedPreferencesHelper.setBusName(
                                        busName['bus_name']),
                                    ShadToaster.of(context).show(
                                      ShadToast(
                                        title: const Text('Selected'),
                                        border: Border(
                                          bottom: BorderSide(
                                              width: 2,
                                              color: Theme.of(context)
                                                          .brightness !=
                                                      Brightness.dark
                                                  ? Colors.transparent
                                                  : Colors.grey[800]!,
                                              style: BorderStyle.solid),
                                          top: BorderSide(
                                              color: Theme.of(context)
                                                          .brightness !=
                                                      Brightness.dark
                                                  ? Colors.transparent
                                                  : Colors.grey[800]!,
                                              style: BorderStyle.solid),
                                          right: BorderSide(
                                              color: Theme.of(context)
                                                          .brightness !=
                                                      Brightness.dark
                                                  ? Colors.transparent
                                                  : Colors.grey[800]!,
                                              style: BorderStyle.solid),
                                          left: BorderSide(
                                              color: Theme.of(context)
                                                          .brightness !=
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
                                  },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(stColor),
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  fixedSize: const Size(200, 50)),
                              child: const Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 35,
                              )),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () =>
                                context.push("/bus/${busName['bus_name']}/1"),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(stColor),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                fixedSize: const Size(200, 50)),
                            child: const Icon(
                              Icons.arrow_circle_down,
                              color: Colors.white,
                              size: 35,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () =>
                                context.push("/bus/${busName['bus_name']}/0"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(stColor),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              fixedSize: const Size(200, 50),
                            ),
                            child: const Icon(
                              Icons.arrow_circle_up,
                              color: Colors.white,
                              size: 35,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(stColor),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              fixedSize: const Size(200, 50),
                            ),
                            child: Text(
                              "${busName['up_time']}-${busName['down_time']}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).brightness !=
                                      Brightness.dark
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                    color: Theme.of(context).brightness !=
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.grey[800]!,
                                  )),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Color(stColor),
                                  size: 35,
                                ),
                                Text(
                                  "${busName['last_stoppage']}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).brightness !=
                                              Brightness.dark
                                          ? Color(stColor)
                                          : Colors.white),
                                ),
                              ],
                            ),
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
