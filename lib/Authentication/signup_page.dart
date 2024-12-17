import 'package:car_rental_app/Toast/CustomToast.dart';
import 'package:flutter/material.dart';
import '../Component/validate_btn.dart';
import '../UserProfile/userdata.dart';
import 'login_via_email.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formfield = GlobalKey<FormState>();
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final usernamecontroller = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  void dispose() {
    super.dispose();
    emailcontroller.dispose();
    passwordcontroller.dispose();
    usernamecontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CustomToast toast = CustomToast();
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
                            builder: (context) => const LoginViaEmail(),
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
            const Text('Tạo tài khoản của bạn',
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
                        keyboardType: TextInputType.emailAddress,
                        controller: emailcontroller,
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
                            return 'Vui lòng làm theo đúng định dạng email';
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
                          Text('Mật khẩu',
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
                        keyboardType: TextInputType.text,
                        controller: passwordcontroller,
                        obscureText: true,
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
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.04),
                child: ValidateBtn(
                  title: 'Đăng ký',
                  ontap: () {
                    if (_formfield.currentState!.validate()) {
                      auth
                          .createUserWithEmailAndPassword(
                              email: emailcontroller.text,
                              password: passwordcontroller.text)
                          .then((value) {
                        toast.Toastt('Tài khoản được tạo thành công');
                        Navigator.pushAndRemoveUntil(
                            // ignore: use_build_context_synchronously
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UserData(),
                            ),
                            (route) => false);
                      }).onError((error, stackTrace) {
                        toast.Toastt(error.toString());
                      });
                    }
                  },
                )),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Bạn đã có tài khoản",
                  style: TextStyle(fontSize: 16),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginViaEmail(),
                        ),
                        (route) => false);
                  },
                  child: const Text(
                    "Đăng nhập",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
