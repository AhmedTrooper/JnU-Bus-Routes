import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class AboutTab extends StatefulWidget{
  const AboutTab({super.key});
  @override
  State<StatefulWidget> createState() {
    return _AboutTabState();
  }
}

class _AboutTabState extends State<AboutTab>{
  @override
  Widget build(BuildContext context) {
    return  const CustomScrollView(
      slivers: [
         SliverAppBar(
          title: Text("Developer Information",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold
          ),
          ),
        ),
         SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: ShadCard(
              leading: Icon(Icons.person,color: Colors.redAccent,size: 30,),
              title: Text("Md. Ramjan Miah"),
              description: Text("Me ? Learning....."),
              footer: Row(
                children: [
                  Icon(LucideIcons.github,size: 30,),
                  ShadButton.ghost(
                    child: Text("AhmedTrooper",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: ShadCard(
              leading: Icon(Icons.person,color: Colors.redAccent,size: 30,),
              title: Text("Old JnU Bus Developer"),
              description: Text("Bus data collector, contactless...."),
              footer: Row(
                children: [
                  Icon(LucideIcons.github,size: 30,),
                  ShadButton.ghost(
                    child: Text("Not Found",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),


      ],
    );
  }
}