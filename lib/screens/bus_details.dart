import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class BusDetailsScreen extends StatefulWidget {
   String busName = "Init";
   BusDetailsScreen({super.key, required this.busName});
  @override
  State<StatefulWidget> createState() {
    return _BusDetailsScreen(busName: this.busName);
  }
}

class _BusDetailsScreen extends State<BusDetailsScreen>{
  String? busName;
  _BusDetailsScreen({required this.busName});
  @override
  Widget build(BuildContext context) {
   return  ShadApp.material(
     home: Scaffold(
       appBar: AppBar(

         leading: ElevatedButton(
             onPressed: ()=> context.pop(),
             style: ElevatedButton.styleFrom(
               backgroundColor: Colors.transparent,
               elevation: 0, // Remove shadow
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(8), // Optional: Rounded corners
                 side: BorderSide.none, // Remove border
               ),
             ),
             child: const Icon(LucideIcons.arrowLeft,color: Colors.white,)),
         backgroundColor: Colors.redAccent,
       ),
       body: Column(
         children: [
           Text(busName!),
         ],
       ),

     ),
   );
  }
}

