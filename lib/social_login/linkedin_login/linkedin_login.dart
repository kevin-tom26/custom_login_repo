part of custom_login;

enum Scopes { openid, profile, email }

typedef SignInCallback = void Function({
  LinkedInProfile? userDetail,
  String? linkedInAccessToken,
  String? linkedInAuthorizationCode,
});

class LinkedInSignIn extends StatefulWidget {
  final BuildContext ctxt;
  final Size screenSize;
  final String clientID;
  final String clientSecret;
  final String redirectUri;
  final List<Scopes> scopes;
  final SignInCallback onSignInCallback;
  final bool isRegistration;
  final bool Function(String)? checkUserExists;
  final void Function(String? error)? onSignInError;
  final Color loadingIndicatorColor;

  final ButtonType buttonType;
  final String buttonText;
  final double? widthMultiplier;
  final double? heightMultiplier;
  final double? iconImageScale;
  final Color? backgroundColor;
  final TextStyle? textStyle;
  final Decoration? decoration;
  final EdgeInsets? padding;
  final double? iconSize;
  final Color? iconColor;
  final Color? disabledIconColor;
  final bool autofocus;
  final BoxConstraints? iconConstraints;
  final ButtonStyle? iconStyle;
  final bool? isIconSelected;
  final Widget? selectedIcon;
  final Widget? icon;
  final AlignmentGeometry? iconAlignment;
  final TextAlign? buttonTextAlignment;

  const LinkedInSignIn({
    super.key,
    required this.ctxt,
    required this.screenSize,
    required this.clientID,
    required this.clientSecret,
    required this.redirectUri,
    required this.onSignInCallback,
    required this.scopes,
    required this.isRegistration,
    required this.loadingIndicatorColor,
    this.checkUserExists,
    this.onSignInError,
    ////
    required this.buttonType,
    required this.buttonText,
    this.widthMultiplier,
    this.heightMultiplier,
    this.iconImageScale,
    this.backgroundColor,
    this.textStyle,
    this.decoration,
    this.padding,
    this.iconSize,
    this.iconColor,
    this.disabledIconColor,
    required this.autofocus,
    this.iconConstraints,
    this.iconStyle,
    this.isIconSelected,
    this.selectedIcon,
    this.icon,
    this.iconAlignment,
    this.buttonTextAlignment,
  });

  @override
  State<LinkedInSignIn> createState() => _LinkedInSignInState();
}

class _LinkedInSignInState extends State<LinkedInSignIn> {
  final appLinks = AppLinks();
  final Dio _dio = Dio();

  late String state;
  late String scope;

  @override
  void initState() {
    super.initState();
    listenForAuthRedirect(); // Start listening for the auth redirect
  }

  @override
  Widget build(BuildContext context) {
    return (widget.buttonType == ButtonType.icon
        ? IconButton(
            onPressed: () {
              signInWithLinkedIn();
            },
            icon: widget.icon ??
                Container(
                  //padding: padding,
                  decoration: widget.decoration ??
                      BoxDecoration(
                          color: widget.backgroundColor ??
                              Colors.grey.withOpacity(0.5),
                          shape: BoxShape.circle),
                  child: Image.asset(
                    'packages/custom_login/assets/images/application/login/linkedin.png',
                    scale: widget.iconImageScale ?? 1.3,
                  ),
                ),
            iconSize: widget.iconSize,
            color: widget.iconColor,
            disabledColor: widget.disabledIconColor,
            autofocus: widget.autofocus,
            constraints: widget.iconConstraints,
            style: widget.iconStyle,
            isSelected: widget.isIconSelected,
            selectedIcon: widget.selectedIcon,
          )
        : Container(
            //margin: EdgeInsets.symmetric(horizontal: widthMultiplier ?? 0),
            width: widget.screenSize.width * (widget.widthMultiplier ?? 1),
            height:
                widget.screenSize.height * (widget.heightMultiplier ?? 0.06),
            padding: widget.padding,
            decoration: widget.decoration ??
                BoxDecoration(
                    color:
                        widget.backgroundColor ?? Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(28)),
            child: GestureDetector(
              onTap: () {
                signInWithLinkedIn();
              },
              child: Row(
                children: [
                  Container(
                    width: (widget.screenSize.width *
                            (widget.widthMultiplier ?? 1)) *
                        0.25,
                    alignment: widget.iconAlignment,
                    child: Image.asset(
                      'packages/custom_login/assets/images/application/login/linkedin_c.png',
                      scale: widget.iconImageScale ?? 1.8,
                    ),
                  ),
                  Expanded(
                    child: Text(widget.buttonText,
                        textAlign: widget.buttonTextAlignment,
                        style: widget.textStyle ??
                            const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                overflow: TextOverflow.ellipsis)),
                  )
                ],
              ),
            )));
    // ElevatedButton(
    //   onPressed: () => signInWithLinkedIn(),
    //   child: Text('Sign in with LinkedIn'),
    // );
  }

  Future<void> signInWithLinkedIn() async {
    state = generateRandomString(16);
    scope = convertScopesToString(widget.scopes);

    final String authUrl = 'https://www.linkedin.com/oauth/v2/authorization'
        '?response_type=code'
        '&client_id=${widget.clientID}'
        '&redirect_uri=${widget.redirectUri}'
        '&state=$state'
        '&scope=$scope';

    try {
      final Uri uri = Uri.parse(authUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (onError) {
      if (widget.onSignInError != null) {
        widget.onSignInError!(onError.toString());
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(onError.toString()),
              duration: const Duration(seconds: 1)));
        }
      }
    }
  }

  // Call this in initState to start listening for the incoming link
  void listenForAuthRedirect() {
    appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        handleIncomingLink(uri);
      }
    });
  }

  // Function to handle the incoming link
  void handleIncomingLink(Uri uri) async {
    final String? returnedState = uri.queryParameters['state'];
    final String? code = uri.queryParameters['code'];

    if (returnedState == state && code != null) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: CircularProgressIndicator(
                color: widget.loadingIndicatorColor,
              ),
            );
          },
        );
      }
      try {
        final String token = await _fetchAccessToken(code);
        final LinkedInProfile profileData = await _fetchUserProfile(token);

        if (widget.isRegistration) {
          if (widget.checkUserExists == null) {
            throw ArgumentError(
                'checkUserExists function is required for Registration.');
          }
          if (widget.checkUserExists!(profileData.email)) {
            if (widget.onSignInError != null) {
              widget.onSignInError!("User already exists");
            } else {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("User already exists"),
                  duration: Duration(seconds: 2),
                ));
              }
            }
            if (mounted) {
              Navigator.maybePop(context);
            }
            return;
          }
        }

        widget.onSignInCallback(
          userDetail: profileData,
          linkedInAccessToken: token,
          linkedInAuthorizationCode: code,
        );

        if (mounted) {
          Navigator.maybePop(context);
        }
      } catch (error) {
        log("$error");
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.maybePop(context);
        });
        if (widget.onSignInError != null) {
          widget.onSignInError!('$error');
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('$error'),
              duration: const Duration(seconds: 2),
            ));
          }
        }
      }
    } else {
      // Handle invalid state or missing code (potential CSRF attack or error)
      if (widget.onSignInError != null) {
        widget.onSignInError!("Invalid state or missing authorization code.");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Invalid state or missing authorization code."),
            duration: Duration(seconds: 1)));
      }
    }
  }

  // Function to fetch the access token
  Future<String> _fetchAccessToken(String code) async {
    try {
      final Response response = await _dio.post(
        'https://www.linkedin.com/oauth/v2/accessToken',
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
        data: {
          'grant_type': 'authorization_code',
          'code': code,
          'redirect_uri': widget.redirectUri,
          'client_id': widget.clientID,
          'client_secret': widget.clientSecret,
        },
      );

      final Map<String, dynamic> responseBody = response.data;
      return responseBody['access_token'];
    } catch (e) {
      // if (widget.onSignInError != null) {
      //   widget.onSignInError!("Failed to fetch access token: $e");
      // } else {
      //   if (mounted) {
      //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //         content: Text("Failed to fetch access token: $e"),
      //         duration: const Duration(seconds: 1)));
      //   }
      // }
      throw Exception('Failed to fetch access token: $e');
    }
  }

  // Function to fetch the user's LinkedIn profile
  Future<LinkedInProfile> _fetchUserProfile(String accessToken) async {
    try {
      final Response profileResponse = await _dio.get(
        'https://api.linkedin.com/v2/userinfo',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      final LinkedInProfile profileData =
          LinkedInProfile.fromJson(profileResponse.data);

      final String firstName = profileData.name;
      final String lastName = profileData.familyName;
      final String email = profileData.email;

      log('First Name: $firstName');
      log('Last Name: $lastName');
      log('Email: $email');

      return profileData;
      // Handle the fetched profile data (store in state, navigate, etc.)
    } catch (e) {
      // if (widget.onSignInError != null) {
      //   widget.onSignInError!("Failed to fetch user profile: $e");
      // } else {
      //   if (mounted) {
      //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //         content: Text("Failed to fetch user profile: $e"),
      //         duration: const Duration(seconds: 1)));
      //   }
      // }
      throw Exception('Failed to fetch user profile: $e');
    }
  }

  static String convertScopesToString(List<Scopes> scopes) {
    // Define a map from enum to its string representation
    final Map<Scopes, String> scopeToString = {
      Scopes.openid: 'openid',
      Scopes.profile: 'profile',
      Scopes.email: 'email',
    };

    // Convert the list of enums to a list of strings
    final List<String> scopeStrings =
        scopes.map((scope) => scopeToString[scope]!).toList();

    // Join the list with '%20' and return the result
    return scopeStrings.join('%20');
  }

  // Function to generate a random string (for state parameter)
  static String generateRandomString(int length) {
    const characters =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = math.Random.secure();
    return List.generate(
            length, (index) => characters[random.nextInt(characters.length)])
        .join();
  }
}

class LinkedInProfile {
  String sub;
  String name;
  String givenName;
  String familyName;
  String picture;
  String email;
  bool emailVerified;

  LinkedInProfile({
    required this.sub,
    required this.name,
    required this.givenName,
    required this.familyName,
    required this.picture,
    required this.email,
    required this.emailVerified,
  });

  factory LinkedInProfile.fromJson(Map<String, dynamic> json) =>
      LinkedInProfile(
        sub: json["sub"],
        name: json["name"],
        givenName: json["given_name"],
        familyName: json["family_name"],
        picture: json["picture"],
        email: json["email"],
        emailVerified: json["email_verified"],
      );
}
