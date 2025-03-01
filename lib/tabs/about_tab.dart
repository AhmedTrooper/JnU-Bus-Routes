import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri _url = Uri.parse('https://github.com/AhmedTrooper');

class AboutTab extends StatefulWidget {
  const AboutTab({super.key});
  @override
  State<StatefulWidget> createState() {
    return _AboutTab();
  }
}

class _AboutTab extends State<AboutTab> {
  TextEditingController userName = TextEditingController.fromValue(
      const TextEditingValue(text: "Md. Alp Arslan"));

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              ShadCard(
                title: const Text("Md. Ramjan Miah"),
                leading: const Icon(LucideIcons.user),
                footer: Row(
                  children: [
                    const Icon(
                      LucideIcons.github,
                      color: Colors.redAccent,
                    ),
                    ElevatedButton(
                      onPressed: _launchUrl,
                      style: ElevatedButton.styleFrom(
                        // Text color
                        elevation: 0, // Remove shadow
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8), // Optional: Rounded corners
                          side: BorderSide.none, // Remove border
                        ),
                      ),
                      child: const Text(
                        "AhmedTrooper",
                        style: TextStyle(
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.normal,
                            color: Colors.redAccent),
                      ),
                    )
                  ],
                  
                ),
                child: const Text("New Bus app developed for newer android version and IOS devices using flutter using old database....."),
              ),
              const SizedBox(height: 20),
              ShadCard(
                title: const Text("Old Jnu Bus App Developer"),
                leading: const Icon(LucideIcons.user),
                footer: Row(
                  children: [
                    const Icon(
                      LucideIcons.github,
                      color: Colors.redAccent,
                    ),
                    ElevatedButton(
                      onPressed: _launchUrl,
                      style: ElevatedButton.styleFrom(
                        // Text color
                        elevation: 0, // Remove shadow
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8), // Optional: Rounded corners
                          side: BorderSide.none, // Remove border
                        ),
                      ),
                      child: const Text(
                        "No Contact",
                        style: TextStyle(
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.normal,
                            color: Colors.redAccent),
                      ),
                    )
                  ],
                ),
                child: const Text(
                    "Old Jnu Bus developer,who is contactless,mainly collector of all buses data!"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _launchUrl() async {
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}
