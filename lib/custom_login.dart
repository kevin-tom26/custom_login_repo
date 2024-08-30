library custom_login;

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//apple
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

//facebook
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

//google
import 'package:google_sign_in/google_sign_in.dart';

//LinkedIn
import 'package:app_links/app_links.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';

//CustomLogin
import 'dart:async';

import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:validators/validators.dart';

//OTP
import 'package:telephony/telephony.dart';

part 'social_login/apple_login/apple_login.dart';
part 'social_login/facebook_login/facebook_login.dart';
part 'social_login/google_login/google_login.dart';
part 'social_login/linkedin_login/linkedin_login.dart';
part 'custom_login_main/custom_login.dart';
part 'otp_setup/otp_setup.dart';
part 'otp_setup/timer_mixin.dart';
