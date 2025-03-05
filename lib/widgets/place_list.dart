import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:go_router/go_router.dart';


class PlaceList extends StatefulWidget{
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
    return  SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
              final placeName = widget.placeNames[index];
              return placeName != "Jagannath University" ?  ListTile(
                title: ShadCard(
                  columnCrossAxisAlignment: CrossAxisAlignment.center,
                  rowMainAxisAlignment: MainAxisAlignment.center,
                  title: Text(placeName),
                  leading: const Icon(LucideIcons.map),
                  footer: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      ShadButton.outline(
                        onPressed: () {
                          context.push("/place/$placeName");
                        },
                        height: 50,
                        child: const Text('See Available Bus'),
                      ),
                    ],
                  ),
                ),
              ) :  const SizedBox(
                height: 0,
              );
        },
        childCount: widget.placeNames.length,
      ),
    );
  }
}


