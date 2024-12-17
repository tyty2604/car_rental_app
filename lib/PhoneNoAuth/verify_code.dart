import 'package:car_rental_app/Component/validate_btn.dart';
import 'package:car_rental_app/PhoneNoAuth/login_via_phone.dart';
import 'package:car_rental_app/Toast/CustomToast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../UserProfile/userdata.dart';

class VerifyCode extends StatefulWidget {
  final String number;
  final String verifactionid;

  const VerifyCode({
    super.key,
    required this.number,
    required this.verifactionid,
  });

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  final verifyController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.height * 0.02,
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginViaPhone(),
                          ));
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      size: 37,
                      semanticLabel: 'Back',
                      shadows: [
                        Shadow(
                            color: Colors.white10,
                            blurRadius: 15.0,
                            offset: Offset(2.0, 4.0))
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.20,
                width: MediaQuery.of(context).size.height * 0.40,
                child: const Icon(
                  Icons.lock,
                  size: 105,
                  color: Colors.indigo,
                  shadows: [
                    Shadow(
                        color: Colors.white10,
                        blurRadius: 15.0,
                        offset: Offset(2.0, 4.0))
                  ],
                )),
            const Text(
              'Xác minh OTP',
              style: TextStyle(
                  color: Color(0xff282F66),
                  fontSize: 27.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: "Nhập OTP gửi tới:",
                    style: TextStyle(
                        color: Colors.indigo.withOpacity(0.6), fontSize: 15),
                    children: [
                      TextSpan(
                          text: '  ${widget.number}',
                          style: const TextStyle(
                              fontSize: 16.5, fontWeight: FontWeight.bold))
                    ])),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.height * 0.04),
              child: Pinput(
                controller: verifyController,
                defaultPinTheme: PinTheme(
                  width: 56,
                  height: 56,
                  textStyle: const TextStyle(
                    fontSize: 22,
                    color: Color.fromRGBO(30, 60, 87, 1),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(19),
                    border: Border.all(color: Colors.indigo, width: 2.0),
                  ),
                ),
                length: 6,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.height * 0.06),
              child: ValidateBtn(
                title: 'Xác minh',
                ontap: () async {
                  final credential = PhoneAuthProvider.credential(
                      verificationId: widget.verifactionid,
                      smsCode: verifyController.text.toString());
                  await auth.signInWithCredential(credential).then((value) {
                    Navigator.pushAndRemoveUntil(
                        // ignore: use_build_context_synchronously
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserData(),
                        ),
                        (route) => false);
                  }).onError((error, stackTrace) {
                    CustomToast().Toastt(error.toString());
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
