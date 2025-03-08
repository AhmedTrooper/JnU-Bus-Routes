import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class PlaceList extends StatefulWidget {
  List<String> placeNames = [];

  PlaceList({super.key, required this.placeNames});

  @override
  State<StatefulWidget> createState() {
    return _PlaceListState();
  }
}

class _PlaceListState extends State<PlaceList> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final placeName = widget.placeNames[index];

          return placeName != "Jagannath University"
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: Theme.of(context).brightness != Brightness.dark
                            ? Colors.white
                            : Colors.grey[800]!,
                        width: 1,
                      ),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            LucideIcons.map,
                            color: Colors.blueAccent,
                            size: 35,
                          ),
                          const SizedBox(width: 8),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              placeName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              softWrap: false,
                              overflow: TextOverflow.visible,
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => context.push("/place/$placeName"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              fixedSize: const Size(200, 50),
                            ),
                            child: const Text(
                              'Available Bus',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox(height: 0);
        },
        childCount: widget.placeNames.length,
      ),
    );
  }
}
