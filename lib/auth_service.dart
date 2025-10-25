import 'dart:io';  // Required for platform check
import 'package:local_auth/local_auth.dart';

final LocalAuthentication auth = LocalAuthentication();

Future<void> authenticate() async {
  try {
    bool isAvailable = await auth.canCheckBiometrics;
    bool isDeviceSupported = await auth.isDeviceSupported();

    if (isAvailable || isDeviceSupported) {
      bool didAuthenticate;

      if (Platform.isWindows) {
        // Windows does NOT support biometricOnly
        didAuthenticate = await auth.authenticate(
          localizedReason: 'Please authenticate',
          options: AuthenticationOptions(stickyAuth: true),
        );
      } else {
        // Use biometricOnly for other platforms
        didAuthenticate = await auth.authenticate(
          localizedReason: 'Please authenticate',
          options: AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,  // ✅ Only enabled for non-Windows platforms
          ),
        );
      }

      if (didAuthenticate) {
        print("✅ Authentication successful");
      } else {
        print("❌ Authentication failed");
      }
    } else {
      print("⚠️ Device does not support authentication");
    }
  } catch (e) {
    print("⚠️ Error: $e");
  }
}
