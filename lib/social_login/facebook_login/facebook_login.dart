part of custom_login;

typedef FacebookSignInCallback = void Function({
  UserCredential? authResult,
  String? facebookAccessToken,
  String? firebaseToken,
});

mixin FacebookSignInMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AccessToken? accessToken;

  signInWithFacebook({
    bool isRegistration = false,
    bool Function(String)? checkUserExists,
    void Function(String? error)? onSignInError,
    Color loadingIndicatorColor = Colors.blue,
    required BuildContext context,
    required FacebookSignInCallback onSignInCallback,
  }) async {
    try {
      final AccessToken? fbAccessToken =
          await FacebookAuth.instance.accessToken;

      if (fbAccessToken != null) {
        await FacebookAuth.instance.logOut();
      }

      /// Log out from previous session

      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        accessToken = result.accessToken!;
      } else {
        if (onSignInError != null) {
          onSignInError("Status: ${result.status}, Error: ${result.message}");
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                    Text("Status: ${result.status}, Error: ${result.message}"),
                duration: const Duration(seconds: 1)));
          }
        }
        return;
      }

      if (accessToken != null) {
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

        if (isRegistration) {
          if (checkUserExists == null) {
            FacebookAuth.instance.logOut();
            throw ArgumentError(
                'checkUserExists function is required for Registration.');
          }
          final userData = await FacebookAuth.instance.getUserData();
          if (checkUserExists(userData['email'])) {
            if (onSignInError != null) {
              onSignInError("User already exists");
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("User already exists"),
                    duration: Duration(seconds: 2)));
              }
            }
            FacebookAuth.instance.logOut();
            if (context.mounted) {
              Navigator.maybePop(context);
            }
            return;
          }
        }

        final OAuthCredential credential =
            FacebookAuthProvider.credential(accessToken!.tokenString);

        UserCredential authResult =
            await _auth.signInWithCredential(credential);
        User? user = authResult.user;

        if (user != null) {
          String? firebaseToken = await user.getIdToken();
          log('Firebase token: $firebaseToken');

          onSignInCallback(
            authResult: authResult,
            facebookAccessToken: accessToken!.tokenString,
            firebaseToken: firebaseToken,
          );

          log("Facebook id: ${user.email}");
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
          FacebookAuth.instance.logOut();
          return;
        }
      } else {
        if (onSignInError != null) {
          onSignInError("Facebook Sign in failed");
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Facebook Sign in failed"),
                duration: Duration(seconds: 2)));
          }
        }
      }
    } catch (error) {
      log('Error during Facebook sign-in: $error');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.maybePop(context);
      });
      if (onSignInError != null) {
        onSignInError('Error during Facebook sign-in: $error');
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Error during Facebook sign-in: $error'),
              duration: const Duration(seconds: 2, microseconds: 500)));
        }
      }
    }
  }

  Future<void> signOut() async {
    await FacebookAuth.instance.logOut();
  }
}
