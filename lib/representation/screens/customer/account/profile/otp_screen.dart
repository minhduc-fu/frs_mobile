import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frs_mobile/core/constants/color_constants.dart';
import 'package:frs_mobile/core/constants/dismension_constants.dart';
import 'package:frs_mobile/core/constants/textstyle_constants.dart';
import 'package:frs_mobile/representation/widgets/button_widget.dart';
import 'package:frs_mobile/utils/asset_helper.dart';
import 'package:frs_mobile/utils/dialog_helper.dart';
import 'package:frs_mobile/utils/image_helper.dart';
import 'package:pinput/pinput.dart';

class OTPScreen extends StatefulWidget {
  late String verificationId;
  final Function(bool) setPhoneNumberVerified;
  final String phone;

  OTPScreen(
      {required this.verificationId,
      required this.setPhoneNumberVerified,
      required this.phone});

  setVerificationId(String newVerificationId) {
    verificationId = newVerificationId;
  }

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController otpController = TextEditingController();
  String? otpCode;
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isResending = false;
  Timer? _timer;
  int _countDown = 45;
  bool isOtpValid = true;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _timer!.cancel();
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countDown > 0) {
          _countDown--;
        } else {
          isResending = true;
          _timer?.cancel();
          isOtpValid = false;
        }
      });
    });
  }

  void _resendOtp() async {
    if (isResending) {
      setState(() {
        _countDown = 45;
        isResending = false;
        isOtpValid = true;
      });
      startTimer();

      try {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: widget.phone,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await FirebaseAuth.instance.signInWithCredential(credential);
            widget.setPhoneNumberVerified(true);
            Navigator.pop(context);
          },
          verificationFailed: (FirebaseAuthException e) {
            print('Error sending OTP: $e');
          },
          codeSent: (String vId, int? resendToken) async {
            widget.setVerificationId(vId);
          },
          codeAutoRetrievalTimeout: (String vId) {},
          timeout: Duration(seconds: 45),
        );
      } catch (e) {
        print('Error resending OTP: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPalette.backgroundScaffoldColor,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
              color: ColorPalette.backgroundScaffoldColor,
              child: Icon(FontAwesomeIcons.angleLeft)),
        ),
        title: Text(
          'Xác thực OTP',
          style: TextStyles.defaultStyle.bold.setTextSize(19),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 25, horizontal: 35),
            child: Column(
              children: [
                Container(
                  width: 200,
                  height: 200,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  child: Center(
                    child: ImageHelper.loadFromAsset(
                      AssetHelper.imageVerified,
                    ),
                  ),
                ),

                SizedBox(height: 20),
                Text(
                  'Xác thực',
                  style: TextStyles.defaultStyle.setTextSize(22).bold,
                ),
                SizedBox(height: 20),
                Text(
                  'Nhập mã OTP gửi đến ${widget.phone}',
                  style: TextStyles.defaultStyle.bold
                      .setColor(ColorPalette.textHide),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Pinput(
                  length: 6,
                  showCursor: true,
                  defaultPinTheme: PinTheme(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kDefaultCircle14),
                        border: Border.all(color: ColorPalette.primaryColor)),
                  ),
                  onCompleted: (value) {
                    setState(() {
                      otpCode = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('00:${_countDown.toString()}'),
                    isResending
                        ? InkWell(
                            onTap: () {
                              _resendOtp();
                            },
                            child: Text('Gửi lại'),
                          )
                        : Text(
                            'Gửi lại',
                            style: TextStyles.defaultStyle
                                .setColor(ColorPalette.textHide),
                          )
                  ],
                ),
                // TextField(
                //   controller: otpController,
                //   decoration: InputDecoration(labelText: 'Nhập mã OTP'),
                //   keyboardType: TextInputType.number,
                // ),
                SizedBox(height: 20),
                ButtonWidget(
                  title: "Xác nhận",
                  size: 18,
                  height: 70,
                  onTap: () async {
                    if (otpCode != null) {
                      if (isOtpValid) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: ColorPalette.primaryColor,
                              ),
                            );
                          },
                        );
                        try {
                          PhoneAuthCredential credential =
                              PhoneAuthProvider.credential(
                            verificationId: widget.verificationId,
                            smsCode: otpCode!,
                          );
                          await FirebaseAuth.instance
                              .signInWithCredential(credential);
                          print('Verification Completeddddddd');
                          widget.setPhoneNumberVerified(true);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        } catch (e) {
                          Navigator.pop(context);
                          showCustomDialog(
                              context, "Lỗi", "Bạn nhập sai mã OTP", true);
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text('Mã OTP đã hết thời gian hiệu lực'),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text('Nhập 6 ký tự code'),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
