import 'package:car_rental_app/Toast/CustomToast.dart';
import 'package:car_rental_app/view/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Component/detail_container.dart';
import 'Detail.dart';

class OwnerCarBooked extends StatefulWidget {
  const OwnerCarBooked({super.key});

  @override
  State<OwnerCarBooked> createState() => _OwnerCarBookedState();
}

class _OwnerCarBookedState extends State<OwnerCarBooked> {
  final usercontroller = TextEditingController();
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

        });
      } else {
        CustomToast().Toastt("Không tìm thấy thông tin người dùng.");
      }
    } catch (e) {
      CustomToast().Toastt("Lỗi tải thông tin người dùng: $e");
    }
  }

  Future<List<String>> getCarIdsAddedByUser() async {
    final QuerySnapshot carsSnapshot = await FirebaseFirestore.instance
        .collection('Cars')
        .where('addedBy', isEqualTo: usercontroller.text)
        .get();

    // Trả về danh sách carId
    return carsSnapshot.docs.map((doc) => doc.id).toList();
  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat currencyFormatter =
        NumberFormat.currency(locale: 'vi_VN', symbol: '');

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Card(
                  elevation: 3,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                            (route) => false);
                      },
                      icon: const Icon(
                        Icons.navigate_before_outlined,
                        size: 34,
                        weight: 5.0,
                      )),
                ),
                const SizedBox(
                  width: 50,
                ),
                const Text(
                  'Xe Đã Cho Thuê',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          FutureBuilder<List<String>>(
            future: getCarIdsAddedByUser(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final List<String> carIds = snapshot.data!;
              if (carIds.isEmpty) {
                 return const Expanded(
                  child: Center( 
                    child: Text(
                        'Không có xe nào của bạn được đặt.',
                        style: TextStyle(fontSize: 18),
                    ),
                  ),
                );
              }

              return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('BookedCars')
                    .where('car id', whereIn: carIds)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> bookedSnapshot) {
                  if (!bookedSnapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (bookedSnapshot.data!.docs.isEmpty) {
                    return const Expanded(
                      child: Center(
                        child: Text(
                            'Không có xe nào của bạn được đặt.',
                            style: TextStyle(fontSize: 18),
                        ),
                      ),
                    );
                  }

                  return Expanded(
                    child: ListView.builder(
                      itemCount: bookedSnapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot documentSnapshot =
                            bookedSnapshot.data!.docs[index];
                        String formattedPrice = currencyFormatter.format(
                          double.tryParse(documentSnapshot['totalbill'].toString()) ?? 0,
                        );
                        return DetailContainer(
                          image: documentSnapshot['image'],
                          text: '$formattedPrice VNĐ',
                          title:
                              '${documentSnapshot['carname'].toString()} ${documentSnapshot['model'].toString()}',
                          subtitle: documentSnapshot['booked by'],
                          ontap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Detail(
                                    documentsnapshot: documentSnapshot,
                                  ),
                                ));
                          },
                        );
                      },
                    ),
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }
}
