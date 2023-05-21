import 'dart:io';
import 'package:fedodo_micro/SuSi/APIs/application_registration.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../Globals/auth.dart';
import '../Globals/global_settings.dart';
import '../Globals/preferences.dart';
import '../home.dart';
import 'APIs/login_manager.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SuSiView extends StatelessWidget {
  SuSiView({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final domainController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    
    if(kIsWeb){
      var url = Uri.base;
      GlobalSettings.domainName = url.authority.replaceAll("micro.", "");
      Preferences.prefs?.setString("DomainName", url.authority);

      login(context);
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: domainController,
              decoration: const InputDecoration(
                hintText: 'Domain',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  GlobalSettings.domainName = domainController.text;
                  Preferences.prefs?.setString("DomainName", domainController.text);

                  login(context);
                }
              },
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
  
  Future login(BuildContext context) async{
    String? clientId = Preferences.prefs?.getString("ClientId");
    String? clientSecret = Preferences.prefs?.getString("ClientSecret");

    ApplicationRegistration appRegis = ApplicationRegistration();
    while(clientId == null || clientSecret == null){
      await appRegis.registerApplication();

      clientId = Preferences.prefs?.getString("ClientId");
      clientSecret = Preferences.prefs?.getString("ClientSecret");
    }

    LoginManager login = LoginManager(!kIsWeb && Platform.isAndroid);
    GlobalSettings.accessToken = await login.login(clientId, clientSecret) ?? AuthGlobals.redirectUriWeb;

    Map<String, dynamic> decodedToken = JwtDecoder.decode(GlobalSettings.accessToken);
    GlobalSettings.userId = decodedToken["sub"];
    GlobalSettings.actorId = "https://${GlobalSettings.domainName}/actor/${GlobalSettings.userId}";

    Preferences.prefs?.setString("UserId", GlobalSettings.userId);
    Preferences.prefs?.setString("ActorId", GlobalSettings.actorId);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Home(),
      ),
    );
  }
}
