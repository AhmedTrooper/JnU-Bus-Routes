import 'package:flutter/material.dart';
import 'package:jnu_bus_routes/utils/shared_preferences_helper.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SettingTab extends StatefulWidget {
  const SettingTab({super.key});
  @override
  State<StatefulWidget> createState() {
    return _SettingTab();
  }
}

class _SettingTab extends State<SettingTab>{

  final formKey = GlobalKey<ShadFormState>();
  final _userNameController = TextEditingController();
  @override
  void initState()  {
    super.initState();
  }




    @override
    void dispose() {
      // Dispose the controller when it's no longer needed
      _userNameController.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ShadForm(
                key: formKey,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 350),
                  child: Column(
                    children: [
                      ShadInputFormField(
                        controller: _userNameController,
                        autofocus: true,
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
                      ShadButton(
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
                              SharedPreferencesHelper.setUserNameStatus(
                                  _userNameController.text);
                            }
                          } else {

                          }
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }
  }


