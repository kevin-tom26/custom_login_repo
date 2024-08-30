part of custom_login;

typedef OnCodeEnteredCompletion = void Function(String value);
typedef OnCodeChanged = void Function(String value);
typedef HandleControllers = void Function(
    List<TextEditingController?> controllers);

class OTPField extends StatefulWidget {
  final bool showCursor;
  final int numberOfFields;
  final bool otpAutoFillEnabled;
  final String? otpProjectCode;
  final double fieldWidth;
  final double? fieldHeight;
  final double borderWidth;
  final Alignment? alignment;
  final Color enabledBorderColor;
  final Color focusedBorderColor;
  final Color disabledBorderColor;
  final Color borderColor;
  final Color errorBorderColor;
  final bool hasOTPError;
  final Color? cursorColor;
  final EdgeInsetsGeometry margin;
  final TextInputType keyboardType;
  final TextStyle? textStyle;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final OnCodeEnteredCompletion? onSubmit;
  final OnCodeChanged? onCodeChanged;
  final HandleControllers? handleControllers;
  final bool obscureText;
  final bool showFieldAsBox;
  final bool enabled;
  final bool filled;
  final bool autoFocus;
  final bool readOnly;
  final bool clearText;
  final bool hasCustomInputDecoration;
  final Color fillColor;
  final BorderRadius borderRadius;
  final InputDecoration? decoration;
  final List<TextStyle> styles;
  final List<TextInputFormatter>? inputFormatters;
  final EdgeInsetsGeometry? contentPadding;
  const OTPField({
    super.key,
    this.showCursor = true,
    this.numberOfFields = 4,
    this.otpAutoFillEnabled = true,
    required this.otpProjectCode,
    this.fieldWidth = 40.0,
    this.fieldHeight,
    this.borderWidth = 2.0,
    this.alignment,
    this.enabledBorderColor = const Color(0xFFE7E7E7),
    this.focusedBorderColor = const Color(0xFF4F44FF),
    this.disabledBorderColor = const Color(0xFFE7E7E7),
    this.borderColor = const Color(0xFFE7E7E7),
    this.errorBorderColor = const Color.fromARGB(255, 255, 0, 0),
    this.hasOTPError = false,
    this.cursorColor,
    this.margin = const EdgeInsets.only(right: 8.0),
    this.keyboardType = TextInputType.number,
    this.textStyle,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.onSubmit,
    this.onCodeChanged,
    this.handleControllers,
    this.obscureText = false,
    this.showFieldAsBox = false,
    this.enabled = true,
    this.filled = false,
    this.autoFocus = false,
    this.readOnly = false,
    this.clearText = false,
    this.hasCustomInputDecoration = false,
    this.fillColor = const Color(0xFFFFFFFF),
    this.borderRadius = const BorderRadius.all(Radius.circular(4.0)),
    this.decoration,
    this.styles = const [],
    this.inputFormatters,
    this.contentPadding,
  });

  @override
  State<OTPField> createState() => _OTPFieldState();
}

class _OTPFieldState extends State<OTPField> {
  late List<String?> _verificationCode;
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _textControllers;
  final Telephony telephony = Telephony.instance;

  @override
  void initState() {
    super.initState();
    _verificationCode = List<String?>.filled(widget.numberOfFields, null);
    _focusNodes =
        List<FocusNode>.generate(widget.numberOfFields, (_) => FocusNode());
    _textControllers = List<TextEditingController>.generate(
        widget.numberOfFields, (_) => TextEditingController());

    if (widget.clearText) {
      for (var controller in _textControllers) {
        controller.clear();
      }
      _verificationCode = List<String?>.filled(widget.numberOfFields, null);
    }

    if (widget.handleControllers != null) {
      widget.handleControllers!(_textControllers);
    }

    if (widget.otpAutoFillEnabled) {
      startListeningToOTP();
    }
  }

  @override
  void dispose() {
    for (var controller in _textControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void startListeningToOTP() {
    telephony.listenIncomingSms(
        onNewMessage: (SmsMessage message) {
          if (widget.otpProjectCode != null && message.body != null) {
            if (message.body!.contains(widget.otpProjectCode!)) {
              // Construct the dynamic regex pattern
              String pattern =
                  r'\b\d{' + widget.numberOfFields.toString() + r'}\b';
              RegExp regExp = RegExp(pattern);
              Match? match = regExp.firstMatch(message.body!);

              if (match != null) {
                String otp = match.group(0)!;

                for (int i = 0; i < widget.numberOfFields; i++) {
                  _textControllers[i].text = otp[i];
                }

                if (widget.onSubmit != null) {
                  widget.onSubmit!(otp);
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "OTP size mismatch!!",
                      style: TextStyle(color: Colors.red),
                    ),
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            }
          }
        },
        listenInBackground: false);
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (value) {
        if (value is RawKeyDownEvent &&
            value.logicalKey == LogicalKeyboardKey.backspace) {
          _handleBackspace(context);
        }
      },
      child: Row(
        mainAxisAlignment: widget.mainAxisAlignment,
        crossAxisAlignment: widget.crossAxisAlignment,
        children: List.generate(widget.numberOfFields, (index) {
          return _buildTextField(context: context, index: index);
        }),
      ),
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required int index,
  }) {
    return Container(
      width: widget.fieldWidth,
      height: widget.fieldHeight,
      alignment: widget.alignment,
      margin: widget.margin,
      child: TextFormField(
        showCursor: widget.showCursor,
        keyboardType: widget.keyboardType,
        textAlign: TextAlign.center,
        maxLength: 1,
        readOnly: widget.readOnly,
        style:
            widget.styles.isNotEmpty ? widget.styles[index] : widget.textStyle,
        autofocus: widget.autoFocus,
        cursorColor: widget.cursorColor,
        controller: _textControllers[index],
        focusNode: _focusNodes[index],
        enabled: widget.enabled,
        inputFormatters: widget.inputFormatters,
        decoration: widget.hasCustomInputDecoration
            ? widget.decoration
            : InputDecoration(
                counterText: "",
                filled: widget.filled,
                fillColor: widget.fillColor,
                focusedBorder: widget.showFieldAsBox
                    ? outlineBorder(widget.focusedBorderColor,
                        widget.borderWidth, widget.borderRadius)
                    : underlineInputBorder(
                        widget.focusedBorderColor, widget.borderWidth),
                enabledBorder: widget.showFieldAsBox
                    ? outlineBorder(widget.enabledBorderColor,
                        widget.borderWidth, widget.borderRadius)
                    : underlineInputBorder(
                        widget.enabledBorderColor, widget.borderWidth),
                disabledBorder: widget.showFieldAsBox
                    ? outlineBorder(widget.disabledBorderColor,
                        widget.borderWidth, widget.borderRadius)
                    : underlineInputBorder(
                        widget.disabledBorderColor, widget.borderWidth),
                border: widget.showFieldAsBox
                    ? outlineBorder(widget.borderColor, widget.borderWidth,
                        widget.borderRadius)
                    : underlineInputBorder(
                        widget.borderColor, widget.borderWidth),
                contentPadding: widget.contentPadding,
              ),
        obscureText: widget.obscureText,
        onChanged: (String value) {
          _verificationCode[index] = value;
          if (widget.onCodeChanged != null) widget.onCodeChanged!(value);

          if (value.length == 1 && index + 1 != _focusNodes.length) {
            FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
          }
          if (_verificationCode
              .every((code) => code != null && code.isNotEmpty)) {
            if (widget.onSubmit != null) {
              widget.onSubmit!(_verificationCode.join());
            }
          }
        },
        onTap: () {
          _textControllers[index].clear();
        },
        onFieldSubmitted: (_) {
          if (_verificationCode
              .every((code) => code != null && code.isNotEmpty)) {
            if (widget.onSubmit != null) {
              widget.onSubmit!(_verificationCode.join());
            }
          }
        },
      ),
    );
  }

  void _handleBackspace(BuildContext context) {
    final index = _focusNodes.indexWhere((element) => element.hasFocus);

    if (index >= 0 && _textControllers[index].text.isEmpty) {
      if (index > 0) {
        FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
        _textControllers[index - 1].clear();
      }
    }
  }

  OutlineInputBorder outlineBorder(
      Color color, double borderWidth, BorderRadius borderRadius) {
    return OutlineInputBorder(
      borderSide: widget.hasOTPError
          ? BorderSide(width: borderWidth, color: widget.errorBorderColor)
          : BorderSide(width: borderWidth, color: color),
      borderRadius: borderRadius,
    );
  }

  UnderlineInputBorder underlineInputBorder(Color color, double borderWidth) {
    return UnderlineInputBorder(
      borderSide: widget.hasOTPError
          ? BorderSide(width: borderWidth, color: widget.errorBorderColor)
          : BorderSide(width: borderWidth, color: color),
    );
  }
}
