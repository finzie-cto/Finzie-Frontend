import 'package:finzie/services/auth_services.dart';
import 'package:finzie/utils/utils.dart';
import 'package:flutter/material.dart';

class MyOtp extends StatefulWidget {
  const MyOtp({Key? key}) : super(key: key);

  @override
  State<MyOtp> createState() => _MyOtpState();
}

class _MyOtpState extends State<MyOtp> {
  @override
  Widget build(BuildContext context) {
    final Object? rcvdData = ModalRoute.of(context)?.settings.arguments;
    final Map<String, String> temp = rcvdData as Map<String, String>;
    final otpController = TextEditingController();
    String? phone = temp['phone'];
    String? password = temp['password'];

    String phoneNumber = '';
    String otp = '';

    var code = "";
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40.0),
              const Text(
                'OTP Verification',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'We will send you a one time password on this mobile number',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 20.0),
              Text(
                '+91-$phone',
                style: TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                      child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      code = value;
                    },
                  )),
                  const SizedBox(width: 10.0),
                ],
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  const Text(
                    'Did not receive OTP?',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {
                          AuthService().resendOTP(
                              context: context, phone: phone.toString());
                        },
                        child: const Text('Resend OTP'),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (code.length != 4) {
                      showSnackBar(
                          context, "Please enter a valid otp of length 4");
                    } else {
                      AuthService().createUser(
                          context: context,
                          phone: phone as String,
                          otp: code,
                          password: password as String);
                    }
                  },
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('You have an account?'),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, "login", (route) => false);
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
