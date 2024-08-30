part of custom_login;

mixin CountdownTimerMixin<T extends StatefulWidget> on State<T> {
  late Duration _remainingTime;
  Timer? _timer;

  void startTimer(Duration totalDuration, VoidCallback onTick) {
    _remainingTime = totalDuration;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime.inSeconds > 0) {
        _remainingTime = Duration(seconds: _remainingTime.inSeconds - 1);
        onTick();
      } else {
        timer.cancel();
      }
    });
  }

  int getCurrentTime() => _remainingTime.inSeconds;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class OTPTimerWidget extends StatefulWidget {
  final Duration totalDuration;
  const OTPTimerWidget({super.key, required this.totalDuration});

  @override
  State<OTPTimerWidget> createState() => _OTPTimerWidgetState();
}

class _OTPTimerWidgetState extends State<OTPTimerWidget> {
  late Duration _remainingTime;
  late Timer _timer;
  @override
  void initState() {
    super.initState();
    _remainingTime = widget.totalDuration;
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime.inSeconds > 0) {
        setState(() {
          _remainingTime = Duration(seconds: _remainingTime.inSeconds - 1);
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: Text("Data send in ${_remainingTime.inSeconds}"),
      // Text(
      //   "$resendOTPText${remOTPTime.toString()} sec.",
      //   style: resendOTPTextStyle?.copyWith(height: 0.9),
      // ),
    );
  }
}
