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
                  leading: const Icon(LucideIcons.map,color: Colors.redAccent,size: 35,),
                  footer: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 25,
                      ),
                      ElevatedButton(
                          onPressed: () => context.push("/place/$placeName"),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              elevation: 2, // Add subtle shadow
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10), // Rounded corners
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              fixedSize: const Size(200, 50)
                          ),
                          child: const Text('See Available Bus',
                            style:  TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),),
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


