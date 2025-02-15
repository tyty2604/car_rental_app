import 'package:car_rental_app/Toast/CustomToast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../Component/detail_container.dart';
import 'package:intl/intl.dart';

class BookedCarUser extends StatefulWidget {
  const BookedCarUser({super.key});

  @override
  State<BookedCarUser> createState() => _BookedCarUserState();
}

class _BookedCarUserState extends State<BookedCarUser> {
  final auth = FirebaseAuth.instance;
  CollectionReference<Map<String, dynamic>> bookedCarsRef =
      FirebaseFirestore.instance.collection('BookedCars');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xe Đã Đặt'),
        elevation: 10,
        scrolledUnderElevation: 2.0,
        primary: true,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_outlined)),
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("BookedCars")
                .where('uid', isEqualTo: auth.currentUser!.uid)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final id = snapshot.data!.docs[index]['bookedId'].toString();
                          final String priceString = snapshot.data!.docs[index]['totalbill'].toString();
                    final int price = int.tryParse(priceString) ?? 0;
                    final formattedPrice = NumberFormat("#,##0", "vi_VN").format(price);
                      return Slidable(
                        startActionPane: ActionPane(
                            motion: const StretchMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  bookedCarsRef
                                      .doc(id)
                                      .delete()
                                      .onError((error, stackTrace) {
                                    CustomToast().Toastt(error.toString());
                                  });
                                },
                                label: 'Xóa bỏ',
                                backgroundColor: Colors.indigo,
                                autoClose: true,
                                foregroundColor: Colors.black,
                                flex: 2,
                                icon: Icons.delete,
                                spacing: 2.0,
                              )
                            ]),
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height * 0.02,
                            left: MediaQuery.of(context).size.height * 0.01,
                            right: MediaQuery.of(context).size.height * 0.02,
                          ),
                          child: DetailContainer(
                            image:
                                snapshot.data!.docs[index]['image'].toString(),
                            text:
                                'Tổng : $formattedPrice đ',
                            title: '${snapshot.data!.docs[index]['carname'].toString()} ${snapshot.data!.docs[index]['model'].toString()}',  
                            subtitle:
                                snapshot.data!.docs[index]['booked by'],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          )
        ],
      ),
    );
  }
}
