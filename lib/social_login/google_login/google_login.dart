part of custom_login;

typedef GoogleSignInCallback = void Function(
    {UserCredential? authResult,
    String? googleAccessToken,
    String? googleIDToken,
    String? firebaseToken});

mixin GoogleSignInMixin {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  signInWithGoogle(
      {bool isRegistration = false,
      bool Function(String)? checkUserExists,
      void Function(String? error)? onSignInError,
      Color loadingIndicatorColor = Colors.green,
      required BuildContext context,
      required GoogleSignInCallback onSignInCallback}) async {
    try {
      await _googleSignIn.signOut(); // Ensure no previous session
      final GoogleSignInAccount? googleUser =
          await _googleSignIn.signIn().catchError((onError) {
        if (onSignInError != null) {
          onSignInError(onError.toString());
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(onError.toString()),
              duration: const Duration(seconds: 1)));
        }
      });
      if (googleUser != null) {
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
            _googleSignIn.disconnect();
            // if (context.mounted) {
            //   Navigator.maybePop(context);
            // }
            throw ArgumentError(
                'checkUserExists function is required for Registration.');
          }
          if (checkUserExists(googleUser.email)) {
            if (onSignInError != null) {
              onSignInError("User already exists");
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("User already exists"),
                    duration: Duration(seconds: 2)));
              }
            }
            _googleSignIn.disconnect();
            if (context.mounted) {
              Navigator.maybePop(context);
            }
            return;
          }
        }
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        UserCredential authResult =
            await _auth.signInWithCredential(credential);
        User? user = authResult.user;

        if (user != null) {
          String? firebaseToken = await user.getIdToken();
          log('Firebase token: $firebaseToken');

          onSignInCallback(
            authResult: authResult,
            googleAccessToken: googleSignInAuthentication.accessToken,
            googleIDToken: googleSignInAuthentication.idToken,
            firebaseToken: firebaseToken,
          );

          // googleSignInResponse = await _processAuthenticationAPI(
          //   idLocalToken: firebaseToken ?? "",
          // );

          log("gmail id: ${googleUser.email}");
          log('Signed in user is : ${googleUser.displayName}');

          if (context.mounted) {
            Navigator.maybePop(context);
          }

          //return authResult;
          //googleSignInResponse;
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
          _googleSignIn.disconnect();
          return;
        }
      } else {
        if (onSignInError != null) {
          onSignInError("Google Sign in failed");
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Google Sign in failed"),
                duration: Duration(seconds: 2)));
          }
        }
        // googleSignInResponse =
        //     RestResponse(apiSuccess: false, message: "Google Sign in failed");
      }
    } catch (error) {
      log('Error during Google sign-in: $error');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.maybePop(context);
      });
      if (onSignInError != null) {
        onSignInError('Error during Google sign-in: $error');
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Error during Google sign-in: $error'),
              duration: const Duration(seconds: 2, microseconds: 500)));
        }
      }
      // googleSignInResponse =
      //     RestResponse(apiSuccess: false, message: error.toString());
      //return googleSignInResponse;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
