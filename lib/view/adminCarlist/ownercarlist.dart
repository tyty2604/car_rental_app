import 'package:car_rental_app/Toast/CustomToast.dart';
import 'package:car_rental_app/view/adminCarlist/admin_cardetail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import '../../Component/detail_container.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OwnerCarList extends StatefulWidget {
  const OwnerCarList({super.key});

  @override
  State<OwnerCarList> createState() => _OwnerCarListState();
}

class _OwnerCarListState extends State<OwnerCarList> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final searchcontroller = TextEditingController();
  final usercontroller = TextEditingController();
  String search = '';
  CollectionReference ref = FirebaseFirestore.instance.collection('Cars');

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Card(
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 25,
                          weight: 5.0,
                        )),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.03),
            child: Card(
                borderOnForeground: true,
                elevation: 1,
                child: TextFormField(
                  controller: searchcontroller,
                  cursorColor: Colors.black38,
                  decoration: const InputDecoration(
                      focusColor: Colors.black38,
                      hintText: 'Tìm Kiếm',
                      hintStyle: TextStyle(letterSpacing: 1.6),
                      suffixIcon: Icon(
                        Icons.search_rounded,
                        size: 30,
                        color: Colors.black38,
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black38))),
                  onChanged: (value) {
                    search = value.toString();
                    setState(() {});
                  },
                )),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.03),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quản Lý Xe Của Chủ',
                  style: TextStyle(
                      letterSpacing: 1.5, color: Colors.black38, fontSize: 19),
                ),
                Icon(Icons.tornado_outlined, color: Colors.black38)
              ],
            ),
          ),
        StreamBuilder(
  stream: FirebaseFirestore.instance
      .collection("Cars")
      .where('addedBy', isEqualTo: usercontroller.text)
      .snapshots(),
  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (!snapshot.hasData) {
      return const Center(child: CircularProgressIndicator());
    } else if (snapshot.data!.docs.isEmpty) {
      return const Center(
        child: Text(
          '\n\n\n\n\n\n\n\n\nBạn Không Có Xe Nào Để Cập Nhật.',
          style: TextStyle(fontSize: 18, color: Colors.black54),
        ),
      );
    } else {
      return Expanded(
        child: ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final DocumentSnapshot documentsnapshot =
                snapshot.data!.docs[index];
            String carname =
                snapshot.data!.docs[index]['make'].toString();

            final String priceString = snapshot.data!.docs[index]['price'].toString();
            final int price = int.tryParse(priceString) ?? 0;
            final formattedPrice = NumberFormat("#,##0", "vi_VN").format(price);

            String id = snapshot.data!.docs[index]['id'].toString();
            if (searchcontroller.text.isEmpty) {
              return Slidable(
                startActionPane:
                    ActionPane(motion: const BehindMotion(), children: [
                  SlidableAction(
                    onPressed: (context) {
                      ref.doc(id).delete().then((value) {
                        CustomToast()
                            .Toastt('Đã Xóa Xe Thành Công');
                      }).onError((error, stackTrace) {
                        CustomToast().Toastt(error.toString());
                      });
                    },
                    label: 'Xóa Bỏ',
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
                    bottom:
                        MediaQuery.of(context).size.height * 0.02,
                    left: MediaQuery.of(context).size.height * 0.01,
                    right:
                        MediaQuery.of(context).size.height * 0.02,
                  ),
                  child: DetailContainer(
                    image: documentsnapshot['image'].toString(),
                    text:
                        '$formattedPrice đ/Ngày',
                    title: '${documentsnapshot['make'].toString()} ${documentsnapshot['model'].toString()}',
                    subtitle:
                        '${documentsnapshot['category'].toString()}' '\nChủ Xe : ${documentsnapshot['addedBy'].toString()}',
                    ontap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminCarDetail(
                              documentSnapshot: documentsnapshot,
                            ),
                          ));
                    },
                  ),
                ),
              );
            } else if (carname
                .toLowerCase()
                .contains(searchcontroller.text.toLowerCase())) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.02,
                  left: MediaQuery.of(context).size.height * 0.01,
                  right: MediaQuery.of(context).size.height * 0.02,
                ),
                child: DetailContainer(
                  image: snapshot.data!.docs[index]['image']
                      .toString(),
                  text:
                      '${documentsnapshot['price'].toString()}/Ngày',
                  title:
                      '${snapshot.data!.docs[index]['make'].toString()} ${snapshot.data!.docs[index]['model'].toString()}',
                  subtitle: snapshot.data!.docs[index]['category']
                      .toString(),
                  ontap: () {},
                ),
              );
            } else {
              return Container();
            }
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
