import 'package:car_rental_app/Authentication/login_via_email.dart';
import 'package:car_rental_app/Component/custom_btn.dart';
import 'package:car_rental_app/PhoneNoAuth/login_via_phone.dart';
import 'package:car_rental_app/view/admin_panel_auth.dart';
import 'package:flutter/material.dart';

class LoginVia extends StatefulWidget {
  const LoginVia({super.key});

  @override
  State<LoginVia> createState() => _LoginViaState();
}

class _LoginViaState extends State<LoginVia> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.height * 0.02,
                left: MediaQuery.of(context).size.height * 0.02,
              ),
              child: SizedBox(
                height: 300,
                width: 450,
                child: Hero(
                  tag: 'background',
                  child: Image(
                      fit: BoxFit.fitWidth,
                      height: MediaQuery.of(context).size.height * 0.60,
                      width: MediaQuery.of(context).size.height * 0.40,
                      image: const AssetImage('assets/images/logocar2.png')),
                ),
              ),
            ),
            const Text('ỨNG DỤNG THUÊ XE',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 3, 163, 67))),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.10,
                left: MediaQuery.of(context).size.height * 0.02,
                right: MediaQuery.of(context).size.height * 0.02,
                bottom: MediaQuery.of(context).size.height * 0.01,
              ),
              child: CustomBtn(
                icon: const Icon(Icons.arrow_circle_right_rounded),
                title: 'Đăng Nhập Qua Email',
                ontap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginViaEmail(),
                      ));
                },
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
             Padding(
               padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.height * 0.02,
               ),
              child: CustomBtn(
                icon: const Icon(Icons.arrow_circle_right_rounded),
                 title: 'Đăng Nhập ADMIN',
                ontap: () {
                  Navigator.pop(context);
                   Navigator.push(
                       context,
                       MaterialPageRoute(
                         builder: (context) => const AdminPanelAuth(),
                       ));
                 },
               ),
             ),
          ],
        ),
      ),
    );
  }
}
