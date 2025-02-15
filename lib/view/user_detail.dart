import 'package:car_rental_app/Component/custom_listtile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserDetail extends StatefulWidget {
  const UserDetail({super.key});

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  final FirebaseAuth auth = FirebaseAuth.instance;

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
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset:
                            const Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.navigate_before_outlined,
                        size: 34,
                        weight: 5.0,
                      )),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          const Image(
              height: 200,
              width: 300,
              image: AssetImage('assets/images/userdetail.png')),
          const SizedBox(
            height: 10,
          ),
          const Align(
            alignment: Alignment.center,
            child: Text(
              'Chi Tiết Người Dùng',
              style: TextStyle(
                fontSize: 30,
                color:  Color.fromARGB(255, 3, 163, 67),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("users")
                .where("uid", isEqualTo: auth.currentUser!.uid)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.04,
                            vertical: MediaQuery.of(context).size.width * 0.02),
                        child: Column(
                          children: [
                            Card(
                              elevation: 10,
                              color: Colors.blueGrey.shade100,
                              child: CustomListtile(
                                icon: const Icon(Icons.person,
                                    color:Color.fromARGB(255, 67, 207, 81)),
                                title: snapshot.data!.docs[index]['username']
                                    .toString(),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Card(
                              elevation: 10,
                              color: Colors.blueGrey.shade100,
                              child: CustomListtile(
                                icon: const Icon(Icons.email,
                                    color: Color.fromARGB(255, 67, 207, 81)),
                                title: snapshot.data!.docs[index]['email']
                                    .toString(),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Card(
                              elevation: 10,
                              color: Colors.blueGrey.shade100,
                              child: CustomListtile(
                                icon: const Icon(Icons.phone,
                                    color:Color.fromARGB(255, 67, 207, 81)),
                                title: snapshot.data!.docs[index]['phoneno']
                                    .toString(),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Card(
                              elevation: 10,
                              color: Colors.blueGrey.shade100,
                              child: CustomListtile(
                                icon: const Icon(
                                  Icons.location_history,
                                  color: Color.fromARGB(255, 67, 207, 81),
                                ),
                                title: snapshot.data!.docs[index]['address']
                                    .toString(),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
