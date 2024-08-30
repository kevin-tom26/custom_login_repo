part of custom_login;

typedef AppleSignInCallback = void Function(
    {UserCredential? authResult,
    String? appleIDToken,
    String? appleAuthorizationCode,
    String? firebaseToken});

mixin AppleSignInMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signInWithApple({
    required BuildContext context,
    required AppleSignInCallback onSignInCallback,
    required String clientID,
    required String redirectURL,
    bool isRegistration = false,
    bool Function(String)? checkUserExists,
    void Function(String? error)? onSignInError,
    Color loadingIndicatorColor = Colors.green,
  }) async {
    try {
      AuthorizationCredentialAppleID appleIDCredential;

      final rawNonce = generateNonce();

      final nonce = sha256ofString(rawNonce);

      if (Platform.isIOS) {
        // Trigger the Apple sign-in flow on iOS
        appleIDCredential = await SignInWithApple.getAppleIDCredential(scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName
        ], nonce: nonce);
      } else if (Platform.isAndroid) {
        // Trigger the Apple sign-in flow on Android
        appleIDCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName
          ],
          webAuthenticationOptions: WebAuthenticationOptions(
            clientId: clientID, // Replace with your client ID
            redirectUri: Uri.parse(redirectURL),
          ),
        );
      } else {
        throw UnsupportedError('Unsupported platform');
      }

      // Extract the email from the Apple ID credential
      final email = appleIDCredential.email;

      if (isRegistration) {
        // Check if the user already exists
        if (checkUserExists != null && email != null) {
          bool userExists = checkUserExists(email);

          if (userExists) {
            if (onSignInError != null) {
              onSignInError("User already exists. Please login instead.");
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("User already exists. Please login instead."),
                    duration: Duration(seconds: 2)));
              }
            }
            return;
          }
        }
      }

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(
                color: loadingIndicatorColor,
              ),
            );
          },
        );
      }

      // Create a new credential
      final AuthCredential credential = OAuthProvider('apple.com').credential(
        idToken: appleIDCredential.identityToken,
        rawNonce: Platform.isIOS ? rawNonce : null,
        accessToken:
            Platform.isIOS ? null : appleIDCredential.authorizationCode,
      );

      UserCredential authResult = await _auth.signInWithCredential(credential);
      User? user = authResult.user;

      if (user != null) {
        String? firebaseToken = await user.getIdToken();
        log('Firebase token: $firebaseToken');

        onSignInCallback(
          authResult: authResult,
          appleIDToken: appleIDCredential.identityToken,
          appleAuthorizationCode: appleIDCredential.authorizationCode,
          firebaseToken: firebaseToken,
        );

        log("Apple ID: ${user.email}");
        log('Signed in user is : ${user.displayName}');

        if (context.mounted) {
          Navigator.maybePop(context);
        }
      } else {
        if (onSignInError != null) {
          onSignInError("User is 'null' !!");
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("User is 'null' !!"),
                duration: Duration(seconds: 2)));
          }
        }
        if (context.mounted) {
          Navigator.maybePop(context);
        }
        return;
      }
    } catch (error) {
      log('Error during Apple sign-in: $error');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.maybePop(context);
      });
      if (onSignInError != null) {
        onSignInError('Error during Apple sign-in: $error');
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Error during Apple sign-in: $error'),
              duration: const Duration(seconds: 2)));
        }
      }
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

String generateNonce([int length = 32]) {
  const charset =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = math.Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)])
      .join();
}

String sha256ofString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}
