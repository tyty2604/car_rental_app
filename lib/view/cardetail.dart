import 'package:car_rental_app/view/BookedCars/bookingdetailsuser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../../Component/customspecs.dart';
import 'package:intl/intl.dart';

class CarDetail extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;

  const CarDetail({super.key, required this.documentSnapshot});

  @override
  State<CarDetail> createState() => _CarDetailState();
}

class _CarDetailState extends State<CarDetail> {
  var bookingdays = 0;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {

    final NumberFormat currencyFormatter =
        NumberFormat.currency(locale: 'vi_VN', symbol: '');
        
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
                  const Text(
                    'Chi Tiết Xe',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.40,
              width: double.infinity,
              child: ClipRRect(
                child: Image(
                  image: NetworkImage(widget.documentSnapshot['image']),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.03),
              child: const Row(
                children: [
                  Text(
                    'Đặc Điểm Kỹ Thuật',
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold, height: 3),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.03),
                child: Row(
                  children: [
                    CustomSpecs(
                      icon: const Icon(
                        Icons.local_gas_station,
                        color: Colors.white,
                        size: 30,
                      ),
                      text: widget.documentSnapshot['fuel'].toString(),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.04,
                    ),
                    CustomSpecs(
                      icon: const Icon(
                        CupertinoIcons.car_detailed,
                        color: Colors.white,
                        size: 30,
                      ),
                      text: widget.documentSnapshot['make'].toString(),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.04,
                    ),
                    CustomSpecs(
                      icon: const Icon(
                        CupertinoIcons.car,
                        color: Colors.white,
                        size: 30,
                      ),
                      text: widget.documentSnapshot['model'].toString(),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.04,
                    ),
                    CustomSpecs(
                      icon: const Icon(
                        CupertinoIcons.timer_fill,
                        color: Colors.white,
                        size: 30,
                      ),
                      text: widget.documentSnapshot['modelyear'].toString(),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.04,
                    ),
                    CustomSpecs(
                      icon: const Icon(
                        CupertinoIcons.gear_alt,
                        color: Colors.white,
                        size: 30,
                      ),
                      text: widget.documentSnapshot['transmission'].toString(),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.04,
                    ),
                    CustomSpecs(
                      icon: const Icon(
                        Icons.car_repair,
                        color: Colors.white,
                        size: 30,
                      ),
                      text: widget.documentSnapshot['category'].toString(),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Giá Thuê: ',
                    style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                        wordSpacing: 1,
                        height: 1,
                        textBaseline: TextBaseline.alphabetic),
                  ),
                  Row(
                    children: [
                      Text(
                         currencyFormatter.format(
                          double.tryParse(widget.documentSnapshot['price'].toString()) ?? 0,
                      ),
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'đ',
                        style: TextStyle(
                            color: Colors.indigo,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        '  /Ngày',
                        style: TextStyle(
                            color: Colors.indigo,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.03),
              child: InkWell(
                onTap: () {
                  final DocumentSnapshot documentsnapshot;
                  documentsnapshot = widget.documentSnapshot;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BookingDetails(documentSnapshot: documentsnapshot),
                      ));
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.08,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color:const Color.fromARGB(255, 3, 122, 51),
                      borderRadius: BorderRadius.circular(20)),
                  child: const Center(
                      child: Text(
                    'Đặt Ngay',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
