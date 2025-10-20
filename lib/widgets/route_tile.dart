import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jnu_bus_routes/providers/place_provider.dart';
import 'package:jnu_bus_routes/providers/theme_provider.dart';

class BusTile extends ConsumerWidget {
  String routeName;

  BusTile({super.key, required this.routeName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bgColor = ref.watch(backgroundColorProvider);
    int stColor = bgColor.value;
    final destination = ref.watch(destinationProvider);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: destination == routeName
            ? (routeName.toString() == "Jagannath University" ||
                    routeName.toString() == destination)
                ? Color(stColor)
                : Colors.black12
            : routeName.toString() == "Jagannath University"
                ? Color(stColor)
                : Colors.black12,
      ),
      child: ListTile(
        hoverColor: Colors.greenAccent,
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            routeName.toString(),
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: routeName.toString() == "Jagannath University" ||
                        routeName.toString() == destination
                    ? Colors.white
                    : Theme.of(context).brightness != Brightness.dark
                        ? Colors.black
                        : Colors.white,
                fontFamily: GoogleFonts.poppins().fontFamily),
          ),
        ),
        leading: destination != null
            ? (routeName.toString() == "Jagannath University" ||
                    routeName.toString() == destination)
                ? Icon(
                    routeName.toString() == "Jagannath University"
                        ? Icons.school
                        : routeName.toString() == destination
                            ? Icons.location_on
                            : Icons.arrow_circle_down,
                    color: Colors.white,
                    size: 35,
                  )
                : Icon(
                    Icons.arrow_circle_down,
                    color: Theme.of(context).brightness != Brightness.dark
                        ? Colors.black54
                        : Colors.white70,
                    size: 35,
                  )
            : routeName.toString() == "Jagannath University"
                ? const Icon(
                    Icons.school,
                    color: Colors.white,
                    size: 35,
                  )
                : Icon(
                    Icons.arrow_circle_down,
                    color: Theme.of(context).brightness != Brightness.dark
                        ? Colors.black54
                        : Colors.white70,
                    size: 35,
                  ),
      ),
    );
  }
}
