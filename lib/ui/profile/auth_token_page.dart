import 'package:flutter/material.dart';
import 'package:flutter_movies_app/common_widgets/common_widgets.dart';
import 'package:flutter_movies_app/config/config.dart';
import 'package:flutter_movies_app/constants/strings.dart';

class AuthTokenEdit extends StatelessWidget {
  const AuthTokenEdit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    controller.text = preferences.getAuthToken();

    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.appName),
        actions: [
          TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  preferences.saveAuthToken(controller.text);
                } else {
                  preferences.saveAuthToken('');
                }
                Navigator.pop(context);
              },
              child: const Text(Strings.settingActionDone))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: PrimaryTextField(
          label: "Auth Token",
          prefixIcon: Icons.key,
          inputType: TextInputType.multiline,
          controller: controller,
        ),
      ),
    );
  }
}
