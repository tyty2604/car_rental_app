// ignore_for_file: use_build_context_synchronously

import 'package:car_rental_app/Component/list.dart';
import 'package:car_rental_app/Component/validate_btn.dart';
import 'package:car_rental_app/view/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../Toast/CustomToast.dart';
import 'package:intl/intl.dart';

class BookingDetails extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;

  const BookingDetails({super.key, required this.documentSnapshot});

  @override
  State<BookingDetails> createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  var bookingdays = 0;
  final usercontroller = TextEditingController();
  final addresscontroller = TextEditingController();
  final phonecontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  void loadUserData() async {
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance.collection("users");

    try {
      final snapshot = await firestore.where("uid", isEqualTo: auth.currentUser!.uid).get();
      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        setState(() {
          usercontroller.text = data['username'] ?? '';
          addresscontroller.text = data['address'] ?? '';
          phonecontroller.text = data['phoneno'] ?? '';
        });
      } else {
        CustomToast().Toastt("Không tìm thấy thông tin người dùng.");
      }
    } catch (e) {
      CustomToast().Toastt("Lỗi tải thông tin người dùng: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black38,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.15,
                  width: MediaQuery.of(context).size.width * 0.45,
                  child: const Image(
                    image: AssetImage('assets/images/logocar2.png'),
                  ),
                )
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            const Text(
              'Chi Tiết Đặt Xe',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
            ),
            ListCars(
              controller: usercontroller,
              text: 'Họ Tên Người Đặt',
              hinttext: 'vui lòng nhập tên của bạn vào đây',
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            ListCars(
              controller: addresscontroller,
              text: 'Địa Chỉ',
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            ListCars(
              controller: phonecontroller,
              text: 'Số Điện Thoại',
              hinttext: '+84 ***********',
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Số Ngày Đặt Xe: ',
                    style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                        wordSpacing: 1,
                        height: 1,
                        textBaseline: TextBaseline.alphabetic),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 30,
                        width: 30,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blueGrey,
                        ),
                        child: InkWell(
                          onTap: () {
                            if (bookingdays > 0) {
                              bookingdays--;
                              setState(() {});
                            }
                          },
                          child: const Center(
                              child: Text(
                            '-',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.02,
                      ),
                      Text(
                        '$bookingdays',
                        style: const TextStyle(height: 1),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.02,
                      ),
                      Container(
                        height: 30,
                        width: 30,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.indigo,
                        ),
                        child: InkWell(
                          onTap: () {
                            bookingdays++;
                            setState(() {});
                          },
                          child: const Center(
                              child: Text(
                            '+',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.03),
              child: ValidateBtn(
                title: 'Xác Nhận Đặt Xe',
                ontap: () {
                  final auth = FirebaseAuth.instance;
                  final firestore =
                      FirebaseFirestore.instance.collection('BookedCars');
                  final carId = widget.documentSnapshot['id'];
                  final query = firestore
                      .where('car id', isEqualTo: carId)
                      .where('uid', isEqualTo: auth.currentUser!.uid);
                  query.get().then((snapshot) {
                    if (snapshot.docs.isNotEmpty) {
                      CustomToast().Toastt('Chiếc xe này đã được bạn đặt trước');
                    } else if (usercontroller.text.isEmpty ||
                        addresscontroller.text.isEmpty ||
                        phonecontroller.text.isEmpty) {
                      CustomToast().Toastt('Vui lòng nhập đầy đủ thông tin của bạn trước');
                    } else if (bookingdays == 0) {
                      CustomToast().Toastt('Vui lòng nhập ngày thuê xe');
                    } else {
                      String pricestring =
                          widget.documentSnapshot['price'].toString();
                      int price = int.parse(pricestring);
                      int totalprice = bookingdays * price;
                       String formattedTotalPrice = NumberFormat('#,##0').format(totalprice);
                      String bookedID =
                          DateTime.now().millisecondsSinceEpoch.toString();
                      firestore.doc(bookedID).set({
                        'carname': widget.documentSnapshot['make'].toString(),
                        'uid': auth.currentUser!.uid,
                        'image': widget.documentSnapshot['image'].toString(),
                        'model': widget.documentSnapshot['model'].toString(),
                        'price per day':
                            widget.documentSnapshot['price'].toString(),
                        'car id': carId,
                        'totalbill': totalprice.toString(),
                        'bookedId': bookedID,
                        'booked by': usercontroller.text,
                        'address': addresscontroller.text,
                        'phoneno': phonecontroller.text,
                        'booking days': bookingdays.toString(),
                      }).then((value) {
                        showDialog<void>(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              title: const Text('Hoàn Thành Đặt Xe'),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                      "Tên Xe:      ${widget.documentSnapshot['make']} ${widget.documentSnapshot['model']}"),
                                  Text("Đã Đặt Bởi :    ${usercontroller.text}"),
                                  Text("Số Ngày Đặt :  $bookingdays"),
                                  Text("Tổng Hóa Đơn :   $formattedTotalPrice VNĐ"),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Hủy Bỏ'),
                                  onPressed: () {
                                    Navigator.of(dialogContext).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Xong'),
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => const HomePage()), 
                                    (Route<dynamic> route) => false,
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }).onError((error, stackTrace) {
                        CustomToast().Toastt(error.toString());
                      });
                    }
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
