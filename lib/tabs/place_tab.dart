import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jnu_bus_routes/widgets/place_list.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../database/database_helper.dart';

class PlaceTab extends StatefulWidget {
  const PlaceTab({super.key});
  @override
  State<StatefulWidget> createState() {
    return _PlaceTabState();
  }
}

class _PlaceTabState extends State<PlaceTab> {
  List<String> _placeNames = [];
  List<String> _filteredPlaceNames = [];
  bool _isLoading = true;
  final _placeKeywords = TextEditingController();
  String searchedKeywords = "";
  @override
  void initState() {
    super.initState();
    _loadBusNames();
  }

  Future<void> _loadBusNames() async {
    try {
      final dbHelper = DatabaseHelper();
      final placeNames = await dbHelper.getPlaceList();
      setState(() {
        _placeNames = placeNames;
        _filteredPlaceNames = _placeNames;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView(
      children: [
       Container(
         padding: const EdgeInsets.all(20),
         child: Column(
           children: [
             ShadInputFormField(
               controller: _placeKeywords,
               autofocus: true,
               id: 'username',
               label: const Row(
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: [
                   Icon(LucideIcons.map),
                   Text('Search by Keywords', style: TextStyle(
                     fontWeight: FontWeight.normal,
                     fontSize: 20,
                   ),
                   ),
                 ],
               ),
               placeholder: const Text('Enter Place name'),
               description:  Text(
                   "You searched ${searchedKeywords == "" ? "for nothing" : searchedKeywords}"),
               onChanged: (value){
setState(() {
  searchedKeywords = value;
  _filteredPlaceNames = _placeNames.where((x)=>x.contains(searchedKeywords)).toList().length > 0 ? _placeNames.where((x)=>x.contains(searchedKeywords)).toList() : [];
});
               },

             ),
           ],
         ),
       ),
        Container(
          height: 1000,
          padding: const EdgeInsets.all(20),
          width: double.infinity,
            child: _filteredPlaceNames.isNotEmpty ? PlaceList(placeNames: _filteredPlaceNames) : const Text("No places found"),
        )
      ],
    );
  }
}
