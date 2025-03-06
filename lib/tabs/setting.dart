import 'package:flutter/material.dart';
import 'package:jnu_bus_routes/utils/shared_preferences_helper.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SettingTab extends StatefulWidget{
  const SettingTab({super.key});
  @override
  State<StatefulWidget> createState() {
    return _SettingTabState();
  }
}

class _SettingTabState extends State<SettingTab>{

  final formKey = GlobalKey<ShadFormState>();
  final _userNameController = TextEditingController();


  @override
  void initState()  {
    super.initState();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
      SliverToBoxAdapter(
        child: Padding(
            padding: const EdgeInsets.all(15.0),
          child:  Card(
          elevation: 10,
          shadowColor: Colors.black.withOpacity(1),
          borderOnForeground: true,
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side:  BorderSide(
          color: Theme.of(context).brightness != Brightness.dark ? Colors.white : Colors.redAccent,                    width: 1
          )
          ),
          child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ShadForm(
            key: formKey,
            child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 350),
                child: Column(
                  children: [
                    ShadInputFormField(
                      cursorColor: Colors.redAccent,
                      controller: _userNameController,
                      autofocus: false,
                      id: 'username',
                      label: const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(LucideIcons.user,color: Colors.redAccent,),
                          Text('Username', style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                            fontSize: 20,
                          ),
                          ),
                        ],
                      ),
                      placeholder: const Text('Enter your username'),
                      description: const Text(
                          "This is your name for homepage",
                      ),

                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.saveAndValidate()) {
                          if (_userNameController.text.isNotEmpty) {
                            SharedPreferencesHelper.setUserName(
                                _userNameController.text);
                            _userNameController.text = "";
                          }
                        } else {

                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        elevation: 2, // Add subtle shadow
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Rounded corners
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        fixedSize: const Size(120, 60),
                      ),
                      child: const Text("Submit",
                        style:  TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),
                      ),

                    ),
                  ],
                )
            )
            )
    ],
    ),
    ),
    ),
    ),
    )
        ]
    );
  }
}





/*


ShadForm(
              key: formKey,
              child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 350),
                  child: Column(
                    children: [
                      ShadInputFormField(
                        controller: _userNameController,
                        autofocus: false,
                        id: 'username',
                        label: const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(LucideIcons.user),
                            Text('Username', style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 20,
                            ),
                            ),
                          ],
                        ),
                        placeholder: const Text('Enter your username'),
                        description: const Text(
                            "This is your name for homepage"),

                      ),
                      const SizedBox(height: 16),
                      ShadButton.outline(
                        padding: const EdgeInsets.all(5),
                        height: 60,
                        width: 120,
                        child: const Text("Submit",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        onPressed: () async {
                          if (formKey.currentState!.saveAndValidate()) {
                            if (_userNameController.text.isNotEmpty) {
                              SharedPreferencesHelper.setUserName(
                                  _userNameController.text);
                              _userNameController.text = "";
                            }
                          } else {

                          }
                        },
                      ),
                    ],
                  )
              )

 */