import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

final LocalAuthentication auth = LocalAuthentication();

Future<bool> authenticateUser(BuildContext context) async {
  try {
    bool didAuthenticate = await auth.authenticate(
      localizedReason: 'Authenticate to access this feature',
      options: AuthenticationOptions(stickyAuth: true),
    );

    return didAuthenticate;
  } catch (e) {
    print("Authentication Error: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Authentication failed!")),
    );
    return false;
  }
}
