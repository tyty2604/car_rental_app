// ignore_for_file: use_build_context_synchronously

import 'package:car_rental_app/Component/list.dart';
import 'package:car_rental_app/Component/validate_btn.dart';
import 'package:car_rental_app/Toast/CustomToast.dart';
import 'package:car_rental_app/view/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../Component/customdrop_down.dart';
import '../../Toast/customsnackbar.dart';

class AddCars extends StatefulWidget {
  const AddCars({super.key});

  @override
  State<AddCars> createState() => _AddCarsState();
}

class _AddCarsState extends State<AddCars> {
  final categorycontroller = TextEditingController();
  final makecontroller = TextEditingController();
  final modelcontroller = TextEditingController();
  final modelyearcontroller = TextEditingController();
  final pricecontroller = TextEditingController();
  final usercontroller = TextEditingController();

  var fuel = ['Xăng', 'Dầu', 'Điện'];
  var transmission = ['Số Tự Động', 'Số Sàn'];
  var selectOptionfuel = 'Xăng, Dầu, Điện';
  var selectOptiontrans = 'AT, MT';
  bool isopen = false;
  bool isOpentrans = false;
  File? _image;
  final picker = ImagePicker();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final firestore = FirebaseFirestore.instance.collection('Cars');

  Future getImage() async {
    final pickedimage =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if (pickedimage != null) {
        _image = File(pickedimage.path);
      } else {
        CustomToast().Toastt('Không Có Ảnh được chọn!');
      }
    });
  }
  
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
      appBar: AppBar(
        title: const Text('Thêm Ô TÔ'),
        elevation: 10,
        scrolledUnderElevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                getImage();
              },
              child: _image == null
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.27,
                      width: MediaQuery.of(context).size.width * 0.93,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomLeft,
                          colors: [ Color.fromARGB(255, 67, 207, 81), Color.fromARGB(255, 12, 216, 9)],
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_circle_outline,
                            size: 45,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Thêm Ảnh',
                            style: TextStyle(
                                fontSize: 26, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height * 0.27,
                      width: MediaQuery.of(context).size.width * 0.93,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(_image!.absolute),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
            ),
            const SizedBox(
              height: 30,
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05),
                  child: const Row(
                    children: [
                      Text(
                        'Mô Tả',
                        style: TextStyle(
                            fontSize: 27, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ListCars(
                  text: 'Loại Xe',
                  leading: const CircleAvatar(
                    radius: 30,
                    backgroundColor: Color.fromARGB(255, 67, 207, 81),
                    child: Icon(
                      Icons.car_repair,
                      size: 37,
                    ),
                  ),
                  hinttext: 'MPV , SUV,...',
                  controller: categorycontroller,
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.03),
                  child: Column(
                    children: [
                      ListCars(
                          text: 'Hãng',
                          hinttext: 'TOYOTA,...',
                          controller: makecontroller),
                      const SizedBox(
                        height: 20,
                      ),
                      ListCars(
                          text: 'Mẫu xe',
                          hinttext: 'CAMRY,...',
                          controller: modelcontroller),
                      const SizedBox(
                        height: 20,
                      ),
                      ListCars(
                          text: 'Mẫu xe năm',
                          hinttext: '2024,...',
                          controller: modelyearcontroller),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05),
                  child: const Row(
                    children: [
                      Text(
                        'Giá Mỗi Ngày',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05),
                  child: TextFormField(
                    controller: pricecontroller,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.calculate),
                      prefixIconColor: Color(0xff282F66),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.indigo, width: 2.0),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.indigo),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05),
                  child: const Row(
                    children: [
                      Text(
                        'Loại Nhiên Liệu',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomDropDown(
                  selectOption: selectOptionfuel,
                  fuel: fuel,
                  ontap: () {
                    isopen = !isopen;
                    setState(() {});
                  },
                  icon: isopen
                      ? const Icon(
                          Icons.arrow_drop_up_outlined,
                          size: 35,
                          color: Colors.indigo,
                        )
                      : const Icon(
                          Icons.arrow_drop_down_sharp,
                          size: 35,
                          color: Colors.indigo,
                        ),
                ),
                if (isopen)
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.04),
                    child: ListView(
                        primary: true,
                        shrinkWrap: true,
                        children: fuel.map((e) {
                          return Column(
                            children: [
                              InkWell(
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(e),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  selectOptionfuel = e;
                                  isopen = false;
                                  setState(() {});
                                },
                              ),
                              const Padding(
                                padding: EdgeInsets.only(bottom: 4),
                                child: Divider(
                                  thickness: 0.09,
                                  height: 0.07,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          );
                        }).toList()),
                  ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05),
                  child: const Row(
                    children: [
                      Text(
                        'Kiểu Hộp Số',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomDropDown(
                  selectOption: selectOptiontrans,
                  fuel: transmission,
                  ontap: () {
                    isOpentrans = !isOpentrans;
                    setState(() {});
                  },
                  icon: isOpentrans
                      ? const Icon(
                          Icons.arrow_drop_up_outlined,
                          size: 35,
                          color: Colors.indigo,
                        )
                      : const Icon(
                          Icons.arrow_drop_down_sharp,
                          size: 35,
                          color: Colors.indigo,
                        ),
                ),
                if (isOpentrans)
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.04),
                    child: ListView(
                        primary: true,
                        shrinkWrap: true,
                        children: transmission.map((e) {
                          return Column(
                            children: [
                              InkWell(
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(e),
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  selectOptiontrans = e;
                                  isOpentrans = false;
                                  setState(() {});
                                },
                              ),
                              const Padding(
                                padding: EdgeInsets.only(bottom: 4),
                                child: Divider(
                                  thickness: 0.09,
                                  height: 0.07,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          );
                        }).toList()),
                  ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.04,
                right: MediaQuery.of(context).size.width * 0.04,
                bottom: MediaQuery.of(context).size.width * 0.04,
              ),
              child: ValidateBtn(
                title: 'Thêm xe',
                ontap: () {
                    validate();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                      (Route<dynamic> route) => false,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void validate() async {
  final user = FirebaseAuth.instance.currentUser;

  if (categorycontroller.text.isEmpty &&
      makecontroller.text.isEmpty &&
      modelcontroller.text.isEmpty &&
      modelyearcontroller.text.isEmpty &&
      pricecontroller.text.isEmpty &&
      selectOptionfuel == 'Select Option' &&
      selectOptiontrans == 'Select Option' &&
      _image == null) {
    if (mounted) {
      CustomSnackbar().snackbar('Vui lòng nhập dữ liệu', context);
    }
  } else if (_image == null) {
    if (mounted) {
      CustomSnackbar().snackbar('Vui lòng chọn một hình ảnh ', context);
    }
  } else {
    if (user == null) {
      if (mounted) {
        CustomSnackbar().snackbar('Không tìm thấy người dùng', context);
      }
      return;
    }

    try {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref('/carsimages/' +
              'Images' +
              DateTime.now().millisecondsSinceEpoch.toString());
      firebase_storage.UploadTask uploadTask = ref.putFile(_image!.absolute);
      await uploadTask;

      var newurl = await ref.getDownloadURL();
      String id = DateTime.now().microsecondsSinceEpoch.toString();
      await firestore.doc(id).set({
        'id': id,
        'image': newurl.toString(),
        'category': categorycontroller.text,
        'make': makecontroller.text,
        'model': modelcontroller.text,
        'modelyear': modelyearcontroller.text,
        'price': pricecontroller.text.toString(),
        'fuel': selectOptionfuel,
        'transmission': selectOptiontrans,
        'addedBy': usercontroller.text,
      });

      if (mounted) {
        CustomSnackbar().snackbar('Đã thêm xe thành công', context);
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar().snackbar("Lỗi: $e", context);
      }
    }
  }
}


}
