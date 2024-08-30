part of custom_login;

enum ButtonType {
  icon,
  button,
}

class CustomLogin
    with GoogleSignInMixin, AppleSignInMixin, FacebookSignInMixin {
  // Controllers and Validators Map
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, String? Function(String?)?> _validators = {};
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? errorMessage;
  bool isMobileNumberEmpty = false;
  bool isMobileOptional = false;

  Timer? _timer;
  int _remainingTime = 0;

  // Starts the timer with the given duration
  void startTimer(Duration duration, void Function(void Function()) setState) {
    _remainingTime = duration.inSeconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  //Check timer ended
  bool checkTimerEnded() {
    return _remainingTime == 0;
  }

  // Cancels the timer if needed
  void cancelTimer() {
    _timer?.cancel();
  }

  // Register email field
  Widget email({
    Key? key,
    required BuildContext context,
    Widget? customChild,
    TextEditingController? controller,
    double? width,
    double? height,
    String? hintText,
    InputDecoration? decoration,
    TextStyle? inputTextStyle,
    EdgeInsetsGeometry? contentPadding,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    void Function()? onTap,
    void Function(PointerDownEvent)? onTapOutside,
    void Function()? onEditingComplete,
    void Function(String)? onFieldSubmitted,
    void Function(String?)? onSaved,
    List<TextInputFormatter>? inputFormatters,
    double cursorWidth = 2.0,
    double? cursorHeight,
    Radius? cursorRadius,
    Color? cursorColor,
    Brightness? keyboardAppearance,
  }) {
    _controllers['email'] = controller ?? TextEditingController();
    _validators['email'] = validator ?? _defaultEmailValidator;

    final TextStyle effectiveTextStyle =
        inputTextStyle ?? Theme.of(context).textTheme.bodyLarge!;
    final double fontSize = effectiveTextStyle.fontSize ?? 16;

    return customChild ??
        SizedBox(
          height: height,
          width: width,
          child: TextFormField(
            key: key,
            controller: _controllers['email'],
            keyboardType: TextInputType.emailAddress,
            validator: _validators['email'],
            style: effectiveTextStyle,
            decoration: decoration ??
                InputDecoration(
                    hintText: hintText ?? 'Email',
                    contentPadding: height != null
                        ? EdgeInsets.symmetric(
                            vertical: (height - fontSize - 3) / 2,
                            horizontal: 15.0,
                          )
                        : contentPadding,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20))),
            textAlignVertical: TextAlignVertical.center,
            onChanged: onChanged,
            onTap: onTap,
            onTapOutside: onTapOutside,
            onEditingComplete: onEditingComplete,
            onFieldSubmitted: onFieldSubmitted,
            onSaved: onSaved,
            inputFormatters: inputFormatters,
            cursorWidth: cursorWidth,
            cursorHeight: cursorHeight,
            cursorRadius: cursorRadius,
            cursorColor: cursorColor,
            keyboardAppearance: keyboardAppearance,
          ),
        );
  }

  // Register password field
  Widget password({
    Key? key,
    required BuildContext context,
    Widget? customChild,
    TextEditingController? controller,
    double? width,
    double? height,
    String? hintText,
    String? Function(String?)? validator,
    InputDecoration? decoration,
    TextStyle? inputTextStyle,
    EdgeInsetsGeometry? contentPadding,
    bool obscureText = true,
    String obscuringCharacter = '●',
    Widget? obscureVisibilityOFFicon,
    Widget? obscureVisibilityONicon,
    Color? obscureVisibilityIconColor,
    double? obscureVisibilityIconSize,
    void Function(String)? onChanged,
    void Function()? onTap,
    void Function(PointerDownEvent)? onTapOutside,
    void Function()? onEditingComplete,
    void Function(String)? onFieldSubmitted,
    void Function(String?)? onSaved,
    List<TextInputFormatter>? inputFormatters,
    double cursorWidth = 2.0,
    double? cursorHeight,
    Radius? cursorRadius,
    Color? cursorColor,
    Brightness? keyboardAppearance,
  }) {
    _controllers['password'] = controller ?? TextEditingController();
    _validators['password'] = validator ?? _defaultPasswordValidator;

    final TextStyle effectiveTextStyle =
        inputTextStyle ?? Theme.of(context).textTheme.bodyLarge!;
    final double fontSize = effectiveTextStyle.fontSize ?? 16;

    return customChild ??
        SizedBox(
          height: height,
          width: width,
          child: StatefulBuilder(builder: ((context, setState) {
            return TextFormField(
              key: key,
              controller: _controllers['password'],
              obscureText: obscureText,
              obscuringCharacter: obscuringCharacter,
              validator: _validators['password'],
              style: effectiveTextStyle,
              decoration: decoration?.copyWith(
                      hintText: hintText ?? 'Password',
                      contentPadding: height != null
                          ? EdgeInsets.symmetric(
                              vertical: (height - fontSize - 3) / 2,
                              horizontal: 15.0,
                            )
                          : contentPadding,
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                        child: obscureText
                            ? obscureVisibilityOFFicon ??
                                Icon(
                                  Icons.visibility_off,
                                  color: obscureVisibilityIconColor,
                                  size: obscureVisibilityIconSize,
                                )
                            : obscureVisibilityONicon ??
                                Icon(
                                  Icons.visibility,
                                  color: obscureVisibilityIconColor,
                                  size: obscureVisibilityIconSize,
                                ),
                      )) ??
                  InputDecoration(
                      hintText: hintText ?? 'Password',
                      contentPadding: height != null
                          ? EdgeInsets.symmetric(
                              vertical: (height - fontSize - 3) / 2,
                              horizontal: 15.0,
                            )
                          : contentPadding,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                        child: obscureText
                            ? obscureVisibilityOFFicon ??
                                Icon(
                                  Icons.visibility_off,
                                  color: obscureVisibilityIconColor,
                                  size: obscureVisibilityIconSize,
                                )
                            : obscureVisibilityONicon ??
                                Icon(
                                  Icons.visibility,
                                  color: obscureVisibilityIconColor,
                                  size: obscureVisibilityIconSize,
                                ),
                      )),
              textAlignVertical: TextAlignVertical.center,
              onChanged: onChanged,
              onTap: onTap,
              onTapOutside: onTapOutside,
              onEditingComplete: onEditingComplete,
              onFieldSubmitted: onFieldSubmitted,
              onSaved: onSaved,
              inputFormatters: inputFormatters,
              cursorWidth: cursorWidth,
              cursorHeight: cursorHeight,
              cursorRadius: cursorRadius,
              cursorColor: cursorColor,
              keyboardAppearance: keyboardAppearance,
            );
          })),
        );
  }

  // Register re-enter password field
  Widget reEnterPassword({
    Key? key,
    required BuildContext context,
    Widget? customChild,
    TextEditingController? controller,
    double? width,
    double? height,
    String? hintText,
    String? Function(String?)? validator,
    InputDecoration? decoration,
    TextStyle? inputTextStyle,
    EdgeInsetsGeometry? contentPadding,
    bool obscureText = true,
    String obscuringCharacter = '•',
    Widget? obscureVisibilityOFFicon,
    Widget? obscureVisibilityONicon,
    Color? obscureVisibilityIconColor,
    double? obscureVisibilityIconSize,
    void Function(String)? onChanged,
    void Function()? onTap,
    void Function(PointerDownEvent)? onTapOutside,
    void Function()? onEditingComplete,
    void Function(String)? onFieldSubmitted,
    void Function(String?)? onSaved,
    List<TextInputFormatter>? inputFormatters,
    double cursorWidth = 2.0,
    double? cursorHeight,
    Radius? cursorRadius,
    Color? cursorColor,
    Brightness? keyboardAppearance,
  }) {
    _controllers['reEnterPassword'] = controller ?? TextEditingController();
    _validators['reEnterPassword'] = validator ?? _defaultPasswordValidator;

    final TextStyle effectiveTextStyle =
        inputTextStyle ?? Theme.of(context).textTheme.bodyLarge!;
    final double fontSize = effectiveTextStyle.fontSize ?? 16;

    return customChild ??
        SizedBox(
          child: StatefulBuilder(builder: ((context, setState) {
            return TextFormField(
              key: key,
              controller: _controllers['reEnterPassword'],
              obscureText: obscureText,
              obscuringCharacter: obscuringCharacter,
              validator: _validators['reEnterPassword'],
              style: effectiveTextStyle,
              decoration: decoration?.copyWith(
                      hintText: hintText ?? 'Re-enter Password',
                      contentPadding: height != null
                          ? EdgeInsets.symmetric(
                              vertical: (height - fontSize - 3) / 2,
                              horizontal: 15.0,
                            )
                          : contentPadding,
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                        child: obscureText
                            ? obscureVisibilityOFFicon ??
                                Icon(
                                  Icons.visibility_off,
                                  color: obscureVisibilityIconColor,
                                  size: obscureVisibilityIconSize,
                                )
                            : obscureVisibilityONicon ??
                                Icon(
                                  Icons.visibility,
                                  color: obscureVisibilityIconColor,
                                  size: obscureVisibilityIconSize,
                                ),
                      )) ??
                  InputDecoration(
                      hintText: hintText ?? 'Re-enter Password',
                      contentPadding: height != null
                          ? EdgeInsets.symmetric(
                              vertical: (height - fontSize - 3) / 2,
                              horizontal: 15.0,
                            )
                          : contentPadding,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                        child: obscureText
                            ? obscureVisibilityOFFicon ??
                                Icon(
                                  Icons.visibility_off,
                                  color: obscureVisibilityIconColor,
                                  size: obscureVisibilityIconSize,
                                )
                            : obscureVisibilityONicon ??
                                Icon(
                                  Icons.visibility,
                                  color: obscureVisibilityIconColor,
                                  size: obscureVisibilityIconSize,
                                ),
                      )),
              textAlignVertical: TextAlignVertical.center,
              onChanged: onChanged,
              onTap: onTap,
              onTapOutside: onTapOutside,
              onEditingComplete: onEditingComplete,
              onFieldSubmitted: onFieldSubmitted,
              onSaved: onSaved,
              inputFormatters: inputFormatters,
              cursorWidth: cursorWidth,
              cursorHeight: cursorHeight,
              cursorRadius: cursorRadius,
              cursorColor: cursorColor,
              keyboardAppearance: keyboardAppearance,
            );
          })),
        );
  }

  // Register mobile field
  Widget mobile({
    Key? key,
    required BuildContext context,
    Widget? customChild,
    bool isMobileFieldOptional = false,
    TextEditingController? controller,
    double? width,
    double? height,
    bool showPhoneNumberLength = true,
    String? Function(String?)? validator,
    InputDecoration? decoration,
    EdgeInsetsGeometry? contentPadding,
    TextStyle? inputTextStyle,
    String? hintText,
    bool includeCountryCodeInOutput = false,
    String initialCountryCode = 'IN',
    TextInputType keyboardType = TextInputType.phone,
    FocusNode? focusNode,
    TextStyle? dropdownTextStyle,
    void Function(String)? onSubmitted,
    bool showDropdownIcon = true,
    BoxDecoration dropdownDecoration = const BoxDecoration(),
    List<TextInputFormatter>? inputFormatters,
    Brightness? keyboardAppearance,
    IconPosition dropdownIconPosition = IconPosition.leading,
    Icon dropdownIcon = const Icon(Icons.arrow_drop_down),
    bool showCountryFlag = true,
    Color? cursorColor,
    String? invalidNumberMessage = 'Invalid Mobile Number',
    double? cursorHeight,
    Radius? cursorRadius = Radius.zero,
    double cursorWidth = 2.0,
    bool? showCursor = true,
    EdgeInsets flagsButtonMargin = EdgeInsets.zero,
  }) {
    _controllers['mobile'] = controller ?? TextEditingController();

    return customChild ??
        SizedBox(
          height: height,
          width: width,
          child: Form(
              key: _formKey,
              child: IntlPhoneField(
                key: key,
                controller: _controllers['mobile'],
                decoration: decoration ??
                    InputDecoration(
                        hintText: hintText ?? 'Mobile',
                        counterText: showPhoneNumberLength ? null : "",
                        contentPadding: contentPadding ??
                            (height != null
                                ? const EdgeInsets.symmetric(
                                    vertical: 0,
                                    horizontal: 15.0,
                                  )
                                : null),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20))),
                textAlignVertical: TextAlignVertical.center,
                initialCountryCode: initialCountryCode,
                onSaved: (value) {
                  if (value != null && value.number.isNotEmpty) {
                    _controllers['mobile']?.text = includeCountryCodeInOutput
                        ? value.completeNumber
                        : value.number;
                    isMobileNumberEmpty = false;
                    isMobileOptional = isMobileFieldOptional;
                  } else if (value != null && value.number.isEmpty) {
                    isMobileNumberEmpty = true;
                    isMobileOptional = isMobileFieldOptional;
                  }
                },
                keyboardType: keyboardType,
                focusNode: focusNode,
                style: inputTextStyle,
                dropdownTextStyle: dropdownTextStyle,
                onSubmitted: onSubmitted,
                showDropdownIcon: showDropdownIcon,
                dropdownDecoration: dropdownDecoration,
                inputFormatters: inputFormatters,
                keyboardAppearance: keyboardAppearance,
                dropdownIconPosition: dropdownIconPosition,
                dropdownIcon: dropdownIcon,
                showCountryFlag: showCountryFlag,
                cursorColor: cursorColor,
                invalidNumberMessage: invalidNumberMessage,
                cursorHeight: cursorHeight,
                cursorRadius: cursorRadius,
                cursorWidth: cursorWidth,
                showCursor: showCursor,
                flagsButtonMargin: flagsButtonMargin,
              )),
        );
  }

  // Validation and Submission Button
  Widget submitButton({
    Key? key,
    Widget? customChild,
    required VoidCallback onSubmit,
    required bool validate,
    void Function(String?)? onValidationError,
    required Size screenSize,
    VoidCallback? onValidationSuccess,
    String buttonText = 'Submit',
    Color? fontColor = Colors.white,
    double fontSize = 16.5,
    Color? buttonColor,
    Color? borderColor,
    Widget? titleWidget,
    EdgeInsets? margin,
    double heightMultiply = 0.06,
    String fontFamily = 'semiBold',
    bool isDisabled = false,
    Color? disableColor,
    Color? disableBorderColor,
    double widthMultipier = 0.9,
    double borderRadius = 6,
    double borderWidth = 1.5,
    AlignmentGeometry? alignment,
  }) {
    return customChild ??
        Container(
          margin: margin,
          alignment: alignment,
          height: screenSize.height * heightMultiply,
          width: screenSize.width * widthMultipier,
          decoration: BoxDecoration(
            color: (isDisabled)
                ? disableColor ?? Colors.grey
                : buttonColor ?? Colors.blue,
            border: Border.all(
              width: borderWidth,
              color: (isDisabled)
                  ? disableBorderColor ?? Colors.grey
                  : borderColor ?? Colors.blue,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: TextButton(
            onPressed: isDisabled
                ? null
                : () {
                    bool isValid = true;
                    if (validate) {
                      isValid = _validateFields();
                    }

                    if (isValid) {
                      onValidationSuccess?.call();
                      onSubmit();
                    } else {
                      onValidationError?.call(errorMessage);
                    }
                  },
            child: titleWidget ??
                Text(
                  buttonText,
                  style: TextStyle(
                      color: fontColor ?? Colors.white,
                      fontFamily: fontFamily,
                      fontSize: fontSize),
                ),
          ),
        );
  }
  // return ElevatedButton(
  //   key: key,
  //   onPressed: () {
  //     bool isValid = true;
  //     if (validate) {
  //       isValid = _validateFields();
  //     }

  //     if (isValid) {
  //       onValidationSuccess?.call();
  //       onSubmit();
  //     } else {
  //       onValidationError?.call(errorMessage);
  //     }
  //   },
  //   style: ElevatedButton.styleFrom(backgroundColor: backgroundColor),
  //   child: Text(buttonText, style: TextStyle(color: textColor)),
  // );

  // Validation logic for all fields
  bool _validateFields() {
    bool isValid = true;

    for (String key in _controllers.keys) {
      String? validationMessage =
          _validators[key]?.call(_controllers[key]!.text);
      if (validationMessage != null && validationMessage.isNotEmpty) {
        errorMessage = validationMessage;
        isValid = false;
        break;
      } else {
        errorMessage = null;
      }
    }
    if (_formKey.currentState != null && errorMessage == null) {
      if (!_formKey.currentState!.validate()) {
        errorMessage = 'Please enter valid mobile number';
        isValid = false;
      } else {
        _formKey.currentState!.save();
        if (!isMobileOptional) {
          if (isMobileNumberEmpty) {
            errorMessage = ' Mobile number field is empty!!.';
            isValid = false;
          } else {
            errorMessage = null;
          }
        } else {
          errorMessage = null;
        }
      }
    }

    return isValid;
  }

  // Default email validator
  String? _defaultEmailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!isEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Default password validator
  String? _defaultPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 10) {
      return 'Password must be at least 10 characters long';
    }
    return null;
  }

  // Google login button
  Widget googleLogin(
      {Key? key,
      required BuildContext context,
      required Size screenSize,
      required void Function(
              {UserCredential? authResult,
              String? googleAccessToken,
              String? googleIDToken,
              String? firebaseToken})
          onGoogleLogin,
      Widget? customChild,
      ButtonType buttonType = ButtonType.button,
      String buttonText = 'Login with Google',
      bool isRegistration = false,
      bool Function(String)?
          checkUserExists, //pass user email id for cross checking
      void Function(String? error)? onSignInError,
      Color loadingIndicatorColor = Colors.green,
      double? widthMultiplier = 0.55,
      double? heightMultiplier,
      double? iconImageScale,
      Color? backgroundColor,
      TextStyle? textStyle,
      Decoration? decoration,
      EdgeInsets? padding,
      double? iconSize,
      Color? iconColor,
      Color? disabledIconColor,
      bool autofocus = false,
      BoxConstraints? iconConstraints,
      ButtonStyle? iconStyle,
      bool? isIconSelected,
      Widget? selectedIcon,
      Widget? icon,
      AlignmentGeometry? iconAlignment = Alignment.center,
      TextAlign? buttonTextAlignment = TextAlign.left}) {
    return customChild ??
        (buttonType == ButtonType.icon
            ? IconButton(
                key: key,
                onPressed: () {
                  signInWithGoogle(
                      context: context,
                      isRegistration: isRegistration,
                      checkUserExists: checkUserExists,
                      onSignInError: onSignInError,
                      loadingIndicatorColor: loadingIndicatorColor,
                      onSignInCallback: onGoogleLogin);
                },
                icon: icon ??
                    Container(
                      //padding: padding,
                      decoration: decoration ??
                          const BoxDecoration(shape: BoxShape.circle),
                      child: Image.asset(
                        'packages/custom_login/assets/images/application/login/google_logo.png',
                        scale: iconImageScale ?? 1.4,
                      ),
                    ),
                iconSize: iconSize,
                color: iconColor,
                disabledColor: disabledIconColor,
                autofocus: autofocus,
                constraints: iconConstraints,
                style: iconStyle,
                isSelected: isIconSelected,
                selectedIcon: selectedIcon,
              )
            : Container(
                //margin: EdgeInsets.symmetric(horizontal: widthMultiplier ?? 0),
                width: screenSize.width * (widthMultiplier ?? 1),
                height: screenSize.height * (heightMultiplier ?? 0.06),
                padding: padding,
                decoration: decoration ??
                    BoxDecoration(
                        color: backgroundColor ?? Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(28)),
                child: GestureDetector(
                  onTap: () {
                    signInWithGoogle(
                        context: context,
                        isRegistration: isRegistration,
                        checkUserExists: checkUserExists,
                        onSignInError: onSignInError,
                        loadingIndicatorColor: loadingIndicatorColor,
                        onSignInCallback: onGoogleLogin);
                  },
                  child: Row(
                    children: [
                      Container(
                        width:
                            (screenSize.width * (widthMultiplier ?? 1)) * 0.25,
                        alignment: iconAlignment,
                        child: Image.asset(
                          'packages/custom_login/assets/images/application/login/google_logo.png',
                          scale: iconImageScale ?? 2.1,
                        ),
                      ),
                      Expanded(
                        child: Text(buttonText,
                            textAlign: buttonTextAlignment,
                            style: textStyle ??
                                const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    overflow: TextOverflow.ellipsis)),
                      )
                    ],
                  ),
                )));
  }

  // Apple login button
  Widget appleLogin(
      {Key? key,
      required BuildContext context,
      required Size screenSize,
      required void Function(
              {UserCredential? authResult,
              String? appleIDToken,
              String? appleAuthorizationCode,
              String? firebaseToken})
          onAppleLogin,
      required String clientID,
      required String redirectURL,
      Widget? customChild,
      ButtonType buttonType = ButtonType.button,
      String buttonText = 'Login with Apple',
      bool isRegistration = false,
      bool Function(String)?
          checkUserExists, //pass user email id for cross checking
      void Function(String? error)? onSignInError,
      Color loadingIndicatorColor = Colors.green,
      double? widthMultiplier = 0.55,
      double? heightMultiplier,
      double? iconImageScale,
      Color? backgroundColor,
      TextStyle? textStyle,
      Decoration? decoration,
      EdgeInsets? padding,
      double? iconSize,
      Color? iconColor,
      Color? disabledIconColor,
      bool autofocus = false,
      BoxConstraints? iconConstraints,
      ButtonStyle? iconStyle,
      bool? isIconSelected,
      Widget? selectedIcon,
      Widget? icon,
      AlignmentGeometry? iconAlignment = Alignment.center,
      TextAlign? buttonTextAlignment = TextAlign.left}) {
    return customChild ??
        (buttonType == ButtonType.icon
            ? IconButton(
                key: key,
                onPressed: () {
                  signInWithApple(
                      context: context,
                      clientID: clientID,
                      redirectURL: redirectURL,
                      isRegistration: isRegistration,
                      checkUserExists: checkUserExists,
                      onSignInError: onSignInError,
                      loadingIndicatorColor: loadingIndicatorColor,
                      onSignInCallback: onAppleLogin);
                },
                icon: icon ??
                    Container(
                      //padding: padding,
                      decoration: decoration ??
                          const BoxDecoration(shape: BoxShape.circle),
                      child: Image.asset(
                        'packages/custom_login/assets/images/application/login/apple.png',
                        scale: iconImageScale ?? 1.3,
                      ),
                    ),
                iconSize: iconSize,
                color: iconColor,
                disabledColor: disabledIconColor,
                autofocus: autofocus,
                constraints: iconConstraints,
                style: iconStyle,
                isSelected: isIconSelected,
                selectedIcon: selectedIcon,
              )
            : Container(
                //margin: EdgeInsets.symmetric(horizontal: widthMultiplier ?? 0),
                width: screenSize.width * (widthMultiplier ?? 1),
                height: screenSize.height * (heightMultiplier ?? 0.06),
                padding: padding,
                decoration: decoration ??
                    BoxDecoration(
                        color: backgroundColor ?? Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(28)),
                child: GestureDetector(
                  onTap: () {
                    signInWithApple(
                        context: context,
                        clientID: clientID,
                        redirectURL: redirectURL,
                        isRegistration: isRegistration,
                        checkUserExists: checkUserExists,
                        onSignInError: onSignInError,
                        loadingIndicatorColor: loadingIndicatorColor,
                        onSignInCallback: onAppleLogin);
                  },
                  child: Row(
                    children: [
                      Container(
                        width:
                            (screenSize.width * (widthMultiplier ?? 1)) * 0.25,
                        alignment: iconAlignment,
                        child: Image.asset(
                          'packages/custom_login/assets/images/application/login/apple.png',
                          scale: iconImageScale ?? 1.8,
                        ),
                      ),
                      Expanded(
                        child: Text(buttonText,
                            textAlign: buttonTextAlignment,
                            style: textStyle ??
                                const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    overflow: TextOverflow.ellipsis)),
                      )
                    ],
                  ),
                )));
  }

  Widget linkedInLogin(
      {Key? key,
      required BuildContext context,
      required Size screenSize,
      required String clientID,
      required String clientSecret,
      required String redirectURL,
      List<Scopes> scopes = const [Scopes.email, Scopes.profile, Scopes.openid],
      required void Function({
        LinkedInProfile? userDetail,
        String? linkedInAccessToken,
        String? linkedInAuthorizationCode,
      }) onLinkedInLogin,
      Widget? customChild,
      ButtonType buttonType = ButtonType.button,
      String buttonText = 'Login with LinkedIn',
      bool isRegistration = false,
      bool Function(String)?
          checkUserExists, //pass user email id for cross checking
      void Function(String? error)? onSignInError,
      Color loadingIndicatorColor = Colors.green,
      double? widthMultiplier = 0.55,
      double? heightMultiplier,
      double? iconImageScale,
      Color? backgroundColor,
      TextStyle? textStyle,
      Decoration? decoration,
      EdgeInsets? padding,
      double? iconSize,
      Color? iconColor,
      Color? disabledIconColor,
      bool autofocus = false,
      BoxConstraints? iconConstraints,
      ButtonStyle? iconStyle,
      bool? isIconSelected,
      Widget? selectedIcon,
      Widget? icon,
      AlignmentGeometry? iconAlignment = Alignment.center,
      TextAlign? buttonTextAlignment = TextAlign.left}) {
    return customChild ??
        LinkedInSignIn(
          ctxt: context,
          screenSize: screenSize,
          clientID: clientID,
          clientSecret: clientSecret,
          redirectUri: redirectURL,
          onSignInCallback: onLinkedInLogin,
          scopes: scopes,
          isRegistration: isRegistration,
          loadingIndicatorColor: loadingIndicatorColor,
          checkUserExists: checkUserExists,
          onSignInError: onSignInError,
          ////
          buttonType: buttonType,
          buttonText: buttonText,
          widthMultiplier: widthMultiplier,
          heightMultiplier: heightMultiplier,
          iconImageScale: iconImageScale,
          backgroundColor: backgroundColor,
          textStyle: textStyle,
          decoration: decoration,
          padding: padding,
          iconSize: iconSize,
          iconColor: iconColor,
          disabledIconColor: disabledIconColor,
          autofocus: autofocus,
          iconConstraints: iconConstraints,
          iconStyle: iconStyle,
          isIconSelected: isIconSelected,
          selectedIcon: selectedIcon,
          icon: icon,
          iconAlignment: iconAlignment,
          buttonTextAlignment: buttonTextAlignment,
        );
  }

  Widget facebookLogin(
      {Key? key,
      required BuildContext context,
      required Size screenSize,
      required void Function(
              {UserCredential? authResult,
              String? facebookAccessToken,
              String? firebaseToken})
          onFacebookLogin,
      Widget? customChild,
      ButtonType buttonType = ButtonType.button,
      String buttonText = 'Login with Facebook',
      bool isRegistration = false,
      bool Function(String)?
          checkUserExists, //pass user email id for cross checking
      void Function(String? error)? onSignInError,
      Color loadingIndicatorColor = Colors.green,
      double? widthMultiplier = 0.55,
      double? heightMultiplier,
      double? iconImageScale,
      Color? backgroundColor,
      TextStyle? textStyle,
      Decoration? decoration,
      EdgeInsets? padding,
      double? iconSize,
      Color? iconColor,
      Color? disabledIconColor,
      bool autofocus = false,
      BoxConstraints? iconConstraints,
      ButtonStyle? iconStyle,
      bool? isIconSelected,
      Widget? selectedIcon,
      Widget? icon,
      AlignmentGeometry? iconAlignment = Alignment.center,
      TextAlign? buttonTextAlignment = TextAlign.left}) {
    return customChild ??
        (buttonType == ButtonType.icon
            ? IconButton(
                key: key,
                onPressed: () {
                  signInWithFacebook(
                      context: context,
                      isRegistration: isRegistration,
                      checkUserExists: checkUserExists,
                      onSignInError: onSignInError,
                      loadingIndicatorColor: loadingIndicatorColor,
                      onSignInCallback: onFacebookLogin);
                },
                icon: icon ??
                    Container(
                      //padding: padding,
                      decoration: decoration ??
                          BoxDecoration(
                              color: backgroundColor ??
                                  Colors.grey.withOpacity(0.5),
                              shape: BoxShape.circle),
                      child: Image.asset(
                        'packages/custom_login/assets/images/application/login/facebook.png',
                        scale: iconImageScale ?? 1.4,
                      ),
                    ),
                iconSize: iconSize,
                color: iconColor,
                disabledColor: disabledIconColor,
                autofocus: autofocus,
                constraints: iconConstraints,
                style: iconStyle,
                isSelected: isIconSelected,
                selectedIcon: selectedIcon,
              )
            : Container(
                //margin: EdgeInsets.symmetric(horizontal: widthMultiplier ?? 0),
                width: screenSize.width * (widthMultiplier ?? 1),
                height: screenSize.height * (heightMultiplier ?? 0.06),
                padding: padding,
                decoration: decoration ??
                    BoxDecoration(
                        color: backgroundColor ?? Colors.grey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(28)),
                child: GestureDetector(
                  onTap: () {
                    signInWithFacebook(
                        context: context,
                        isRegistration: isRegistration,
                        checkUserExists: checkUserExists,
                        onSignInError: onSignInError,
                        loadingIndicatorColor: loadingIndicatorColor,
                        onSignInCallback: onFacebookLogin);
                  },
                  child: Row(
                    children: [
                      Container(
                        width:
                            (screenSize.width * (widthMultiplier ?? 1)) * 0.25,
                        alignment: iconAlignment,
                        child: Image.asset(
                          'packages/custom_login/assets/images/application/login/facebook_c.png',
                          scale: iconImageScale ?? 1.8,
                        ),
                      ),
                      Expanded(
                        child: Text(buttonText,
                            textAlign: buttonTextAlignment,
                            style: textStyle ??
                                const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    overflow: TextOverflow.ellipsis)),
                      )
                    ],
                  ),
                )));
  }

  Widget otpField({
    required Size screenSize,
    bool otpAutoFillEnabled = true,
    required String? otpProjectCode,
    bool showCursor = true,
    int numberOfFields = 4,
    double fieldWidth = 40.0,
    double? fieldHeight,
    double borderWidth = 2.0,
    Alignment? alignment,
    Color enabledBorderColor = const Color(0xFFE7E7E7),
    Color focusedBorderColor = const Color(0xFF4F44FF),
    Color disabledBorderColor = const Color(0xFFE7E7E7),
    Color borderColor = const Color(0xFFE7E7E7),
    Color errorBorderColor = const Color.fromARGB(255, 255, 0, 0),
    bool hasOTPError = false,
    String errorText = 'OTP Error',
    TextStyle? errorTextStyle = const TextStyle(color: Colors.red),
    String resendOTPText = 'Resend OTP in: ',
    TextStyle? resendOTPTextStyle = const TextStyle(color: Color(0xFF4F44FF)),
    AlignmentGeometry? resendOTPTextAlignment = Alignment.centerRight,
    Color? cursorColor,
    EdgeInsetsGeometry margin = const EdgeInsets.only(right: 8.0),
    TextInputType keyboardType = TextInputType.number,
    TextStyle? textStyle,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.center,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    OnCodeEnteredCompletion? onSubmit,
    OnCodeChanged? onCodeChanged,
    HandleControllers? handleControllers,
    bool obscureText = false,
    bool showFieldAsBox = false,
    bool enabled = true,
    bool filled = false,
    bool autoFocus = false,
    bool readOnly = false,
    bool clearText = false,
    bool hasCustomInputDecoration = false,
    Color fillColor = const Color(0xFFFFFFFF),
    BorderRadius borderRadius = const BorderRadius.all(Radius.circular(4.0)),
    InputDecoration? decoration,
    List<TextStyle> styles = const [],
    List<TextInputFormatter>? inputFormatters,
    EdgeInsetsGeometry? contentPadding,
    Widget otpHeaderWidget = const Text('OTP Header'),
    Duration timerDuration = const Duration(seconds: 10),
    Widget? resendOTPButton,
    required VoidCallback onResendOTP,
    bool showTimer = true,
    bool startInitialTimer = true,
    bool restartTimer = true,
  }) {
    return Column(
      children: [
        otpHeaderWidget,
        OTPField(
          // context: context,
          showCursor: showCursor,
          numberOfFields: numberOfFields,
          otpAutoFillEnabled: otpAutoFillEnabled,
          otpProjectCode: otpProjectCode,
          fieldWidth: fieldWidth,
          fieldHeight: fieldHeight,
          borderWidth: borderWidth,
          alignment: alignment,
          enabledBorderColor: enabledBorderColor,
          focusedBorderColor: focusedBorderColor,
          disabledBorderColor: disabledBorderColor,
          borderColor: borderColor,
          errorBorderColor: errorBorderColor,
          hasOTPError: hasOTPError,
          cursorColor: cursorColor,
          margin: margin,
          keyboardType: keyboardType,
          textStyle: textStyle,
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          onSubmit: (value) {
            cancelTimer();
            if (onSubmit != null) {
              onSubmit(value);
            }
          },
          onCodeChanged: onCodeChanged,
          handleControllers: handleControllers,
          obscureText: obscureText,
          showFieldAsBox: showFieldAsBox,
          enabled: enabled,
          filled: filled,
          autoFocus: autoFocus,
          readOnly: readOnly,
          clearText: clearText,
          hasCustomInputDecoration: hasCustomInputDecoration,
          fillColor: fillColor,
          borderRadius: borderRadius,
          decoration: decoration,
          styles: styles,
          inputFormatters: inputFormatters,
          contentPadding: contentPadding,
        ),
        if (hasOTPError)
          Container(
            margin: const EdgeInsets.only(top: 3),
            child: Text(
              errorText,
              style: errorTextStyle?.copyWith(
                  height: 0.9, overflow: TextOverflow.ellipsis),
            ),
          ),
        StatefulBuilder(builder: (context, setstate) {
          if (startInitialTimer && _remainingTime == 0) {
            startTimer(timerDuration, setstate);
            startInitialTimer = false;
          }
          return !(!startInitialTimer && _remainingTime == 0)
              ? Container(
                  alignment: resendOTPTextAlignment,
                  child: Text(
                    "$resendOTPText$_remainingTime sec.",
                    style: resendOTPTextStyle?.copyWith(height: 1.5),
                  ),
                )
              : resendOTPButton ??
                  reSendOTPButton(
                      margin: EdgeInsets.only(top: screenSize.height * 0.02),
                      onSubmit: () {
                        if (restartTimer) {
                          setstate(() {
                            startInitialTimer = true;
                          });
                        }
                        onResendOTP();
                      },
                      screenSize: screenSize);
        })
      ],
    );
  }

  Widget reSendOTPButton({
    Key? key,
    Widget? customChild,
    required void Function()? onSubmit,
    void Function(String?)? onValidationError,
    required Size screenSize,
    VoidCallback? onValidationSuccess,
    String buttonText = 'Resend OTP',
    Color? fontColor = Colors.white,
    double fontSize = 16.5,
    Color? buttonColor,
    Color? borderColor,
    Widget? titleWidget,
    EdgeInsets? margin,
    double heightMultiply = 0.06,
    String fontFamily = 'semiBold',
    bool isDisabled = false,
    Color? disableColor,
    Color? disableBorderColor,
    double widthMultipier = 0.5,
    double borderRadius = 6,
    double borderWidth = 1.5,
    AlignmentGeometry? alignment,
  }) {
    return customChild ??
        Container(
          margin: margin,
          alignment: alignment,
          height: screenSize.height * heightMultiply,
          width: screenSize.width * widthMultipier,
          decoration: BoxDecoration(
            color: (isDisabled)
                ? disableColor ?? Colors.grey
                : buttonColor ?? Colors.blue,
            border: Border.all(
              width: borderWidth,
              color: (isDisabled)
                  ? disableBorderColor ?? Colors.grey
                  : borderColor ?? Colors.blue,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: TextButton(
            onPressed: onSubmit,
            child: titleWidget ??
                Text(
                  buttonText,
                  style: TextStyle(
                      color: fontColor ?? Colors.white,
                      fontFamily: fontFamily,
                      fontSize: fontSize),
                ),
          ),
        );
  }
}
