// ignore_for_file: use_build_context_synchronously

import 'package:car_rental_app/Toast/CustomToast.dart';
import 'package:car_rental_app/view/admin_panel.dart';
import 'package:car_rental_app/view/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Authentication/login_via.dart';
import '../Component/validate_btn.dart';

class AdminPanelAuth extends StatefulWidget {
  const AdminPanelAuth({super.key});

  @override
  State<AdminPanelAuth> createState() => _AdminPanelAuthState();
}

class _AdminPanelAuthState extends State<AdminPanelAuth> {
  final _formfield = GlobalKey<FormState>();
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final auth = FirebaseAuth.instance;

  void isLogin() {
    FirebaseFirestore.instance
        .collection('admin')
        .doc('adminlogin')
        .snapshots()
        .forEach((element) {
      if (element.data()!['adminemail'] == emailcontroller.text &&
          element.data()!['adminpassword'] == passwordcontroller.text) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminPanel(),
            ),
            (route) => false);
      } else {
        CustomToast().Toastt('Incorrect email or password');
      }
    });
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
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: MediaQuery.of(context).size.height * 0.30,
                    child:
                        const Image(image: AssetImage('assets/images/logocar2.png')),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            const Text('Đăng Nhập Tài Khoản Admin',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 67, 207, 81))),
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
                            'Email',
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
                            return 'vui lòng làm theo đúng định dạng của email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mật khẩu',
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
                        controller: passwordcontroller,
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            prefixIconColor: Color(0xff282F66),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.indigo, width: 2.0)),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.indigo))),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Vui lòng nhập mật khẩu';
                          } else if (value.length < 3) {
                            return 'Mật khẩu phải có ít nhất 4 ký tự';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                )),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.04),
                child: ValidateBtn(
                  title: 'Đăng nhập',
                  ontap: () {
                    if (_formfield.currentState!.validate()) {
                      isLogin();
                    }
                  },
                )),
          ],
        ),
      ),
    );
  }
}
