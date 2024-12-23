import 'package:car_rental_app/Component/validate_btn.dart';
import 'package:car_rental_app/PhoneNoAuth/verify_code.dart';
import 'package:car_rental_app/Toast/CustomToast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Authentication/login_via.dart';

class LoginViaPhone extends StatefulWidget {
  const LoginViaPhone({super.key});

  @override
  State<LoginViaPhone> createState() => _LoginViaPhoneState();
}

class _LoginViaPhoneState extends State<LoginViaPhone> {
  final _formfield = GlobalKey<FormState>();
  final phonecontroller = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    phonecontroller.dispose();
  }

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
                            builder: (context) => const LoginVia(),
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
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: 'background',
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.20,
                    width: MediaQuery.of(context).size.height * 0.30,
                    child: const Image(
                        image: AssetImage('assets/images/logocar2.png')),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            const Text('Đăng nhập qua điện thoại',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff282F66))),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            Form(
                key: _formfield,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.04),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Số điện thoại',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff282F66),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      TextFormField(
                        controller: phonecontroller,
                        maxLength: 13,
                        keyboardType: const TextInputType.numberWithOptions(),
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.phone),
                            prefixIconColor: Color(0xff282F66),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.indigo, width: 2.0)),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.indigo))),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Vui lòng nhập số điện thoại';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.04,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.height * 0.04),
                        child: ValidateBtn(
                          title: 'Gửi mã',
                          ontap: () {
                            if (_formfield.currentState!.validate()) {
                              auth.verifyPhoneNumber(
                                phoneNumber: phonecontroller.text.toString(),
                                verificationCompleted: (_) {},
                                verificationFailed: (error) {
                                  CustomToast().Toastt(error.toString());
                                  debugPrint(error.toString());
                                },
                                codeSent: (String verificationId,
                                    int? forceResendingToken) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VerifyCode(
                                          number:
                                              phonecontroller.text.toString(),
                                          verifactionid: verificationId,
                                        ),
                                      ));
                                },
                                codeAutoRetrievalTimeout: (error) {
                                  CustomToast().Toastt(error.toString());
                                },
                              );
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
