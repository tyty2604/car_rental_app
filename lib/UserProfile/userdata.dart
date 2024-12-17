// ignore_for_file: use_build_context_synchronously

import 'package:car_rental_app/Authentication/login_via_email.dart';
import 'package:car_rental_app/Authentication/signup_page.dart';
import 'package:car_rental_app/Component/validate_btn.dart';
import 'package:car_rental_app/Toast/CustomToast.dart';
import 'package:car_rental_app/view/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserData extends StatefulWidget {
  const UserData({super.key});

  @override
  State<UserData> createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  final _formfield = GlobalKey<FormState>();
  final usernamecontroller = TextEditingController();
  final emailcontroller = TextEditingController();
  final addresscontroller = TextEditingController();
  final phonecontroller = TextEditingController();
  final firestore = FirebaseFirestore.instance;
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
                              builder: (context) => const SignUpPage()));
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
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: 'background',
                  child: SizedBox(
                    height: 120,
                    width: 200,
                    child:
                        Image(image: AssetImage('assets/images/logocar2.png')),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            const Text('Tạo hồ sơ của bạn ở đây',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff282F66))),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.04),
              child: Form(
                  key: _formfield,
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tên người dùng',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff282F66))),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      TextFormField(
                        controller: usernamecontroller,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            prefixIconColor: Color(0xff282F66),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.indigo, width: 2.0)),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.indigo))),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Vui lòng nhập tên người dùng';
                          } else if (value.length < 4) {
                            return 'Tên người dùng phải có ít nhất 4 ký tự';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff282F66))),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      TextFormField(
                        controller: emailcontroller,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            prefixIconColor: Color(0xff282F66),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.indigo, width: 2.0)),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.indigo))),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Vui lòng nhập email';
                          } else if (!value.endsWith('.com')) {
                            return 'Vui lòng làm theo đúng định dạng của email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Địa chỉ',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff282F66))),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      TextFormField(
                        controller: addresscontroller,
                        keyboardType: TextInputType.streetAddress,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.location_history),
                            prefixIconColor: Color(0xff282F66),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.indigo, width: 2.0)),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.indigo))),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Vui lòng nhập địa chỉ';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Phone No',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff282F66))),
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
                    ],
                  )),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.height * 0.04),
              child: ValidateBtn(
                title: 'Tạo hồ sơ',
                ontap: () {
                  if (_formfield.currentState!.validate()) {
                    String id =
                        DateTime.now().millisecondsSinceEpoch.toString();
                    firestore.collection('users').doc(id).set({
                      'username': usernamecontroller.text,
                      'email': emailcontroller.text,
                      'address': addresscontroller.text,
                      'uid': auth.currentUser!.uid,
                      'phoneno': phonecontroller.text.toString()
                    }).then((value) {
                      final user = auth.currentUser;
                      for (final userinfo in user!.providerData) {
                        if (userinfo.providerId == 'phone') {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                              (route) => false);
                          debugPrint('Phone No Auth');
                        } else if (userinfo.providerId == 'password') {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginViaEmail(),
                              ),
                              (route) => false);
                          debugPrint('Password Auth');
                        }
                      }
                    }).onError((error, stackTrace) {
                      CustomToast().Toastt(error.toString());
                    });
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
