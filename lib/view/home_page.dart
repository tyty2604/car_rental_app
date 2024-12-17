import 'package:car_rental_app/Component/custom_listtile.dart';
import 'package:car_rental_app/Toast/CustomToast.dart';
import 'package:car_rental_app/view/BookedCars/ownercarbooked.dart';
import 'package:car_rental_app/view/addcars/add_cars.dart';
import 'package:car_rental_app/view/adminCarlist/ownercarlist.dart';
import 'package:car_rental_app/view/admin_panel_auth.dart';
import 'package:car_rental_app/view/brandcarpage.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Authentication/login_via.dart';
import '../Component/detail_container.dart';
import 'BookedCars/booked_car_user.dart';
import 'user_detail.dart';
import 'cardetail.dart';
import 'package:intl/intl.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final auth = FirebaseAuth.instance;
  final searchcontroller = TextEditingController();
  String search = '';
  String carname = '';
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  final List<String> bannerImages = [
    'assets/images/slide1.jpeg',
    'assets/images/slide2.png',
    'assets/images/slide3.jpg',
    'assets/images/slide4.jpg',
    'assets/images/slide5.jpg',
    'assets/images/slide6.jpg',
    'assets/images/slide7.png',
    'assets/images/slide8.jpg',
    'assets/images/slide9.jpeg',
    'assets/images/slide10.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _globalKey,
        drawer: Drawer(
          child: SafeArea(
            child: ListView(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.29,
                  width: MediaQuery.of(context).size.width * 0.28,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 3, 163, 67),
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 67, 207, 81).withOpacity(0.5),
                        spreadRadius: 6,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.04),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.14,
                          width: MediaQuery.of(context).size.width * 0.24,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color:Color.fromARGB(255, 234, 242, 235),
                          ),
                          child: const Image(
                            image: AssetImage('assets/images/logocar2.png'),
                          ),
                        ),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("users")
                              .where("uid", isEqualTo: auth.currentUser!.uid)
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else {
                              return Expanded(
                                child: ListView.builder(
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(
                                        'Xin Chào <3 \n${snapshot.data!.docs[index]['username'].toString()}',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        snapshot.data!.docs[index]['email']
                                            .toString(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
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
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomListtile(
                  icon: const Icon(Icons.home_filled),
                  title: 'Trang Chủ',
                  ontap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                        (route) => false);
                    _globalKey.currentState!.closeDrawer();
                  },
                ),
                CustomListtile(
                  icon: const Icon(Icons.car_rental),
                  title: 'Xe Đã Đặt',
                  ontap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BookedCarUser(),
                        ));
                  },
                ),
                CustomListtile(
                  icon: const Icon(Icons.car_crash_outlined),
                  title: 'Đăng Kí Cho Thuê',
                  ontap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddCars(),
                        ));
                 },
                ),
                 CustomListtile(
                  icon: const Icon(Icons.car_crash_outlined),
                  title: 'Xe Đã Cho Thuê',
                  ontap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OwnerCarBooked(),
                    ),
                      );
                 },
                ),
                CustomListtile(
                  icon: const Icon(Icons.car_crash_outlined),
                  title: 'Cập Nhật Xe Của Bạn',
                  ontap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OwnerCarList(),
                    ),
                      );
                 },
                ),
                CustomListtile(
                  icon: const Icon(Icons.admin_panel_settings_outlined),
                  title: 'Trang Quản Trị',
                  ontap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminPanelAuth(),
                        ));
                  },
                ),
                CustomListtile(
                  icon: const Icon(Icons.details_outlined),
                  title: 'Chi Tiết Người Dùng',
                  ontap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UserDetail(),
                        ));
                    _globalKey.currentState!.closeDrawer();
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.03),
                  child: IconButton(
                      onPressed: () {
                        auth.signOut().then((value) {
                          Navigator.pushAndRemoveUntil(
                              // ignore: use_build_context_synchronously
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginVia(),
                              ),
                              (route) => false);
                          CustomToast().Toastt('Đăng Xuất Thành Công');
                        }).onError((error, stackTrace) {
                          CustomToast().Toastt(error.toString());
                        });
                      },
                      icon: const Row(
                        children: [
                          Icon(
                            Icons.power_settings_new,
                            color: Colors.red,
                            size: 30,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Đăng Xuất',
                            style: TextStyle(color: Colors.red, fontSize: 18),
                          )
                        ],
                      )),
                ),
              ],
            ),
          ),
        ),
         body: SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          color: const Color.fromARGB(255, 67, 207, 81).withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () {
                        _globalKey.currentState!.openDrawer();
                      },
                      icon: const Icon(
                        Icons.menu,
                        size: 34,
                        weight: 5.0,
                      ),
                    ),
                  ),
                ),
                 Expanded(
        child: Center(
          child: SizedBox(
            height: 50,
            child: Image.asset(
              'assets/images/logocar2.png', // Đường dẫn logo của bạn
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
                Card(
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 67, 207, 81).withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BookedCarUser(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.car_rental_outlined,
                        size: 34,
                        weight: 5.0,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.03,
            ),
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
                    borderSide: BorderSide(color: Colors.black38),
                  ),
                ),
                onChanged: (value) {
                  search = value.toString();
                  setState(() {});
                },
              ),
            ),
          ),
          Padding(
  padding: EdgeInsets.symmetric(
    horizontal: MediaQuery.of(context).size.width * 0.03,
  ),
  child: const Align(
    alignment: Alignment.centerLeft,
    child: Text(
      'Các Chương Trình Khuyến Mãi',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
       color: Color.fromARGB(255, 3, 163, 67),
      ),
    ),
  ),
),
SizedBox(
  height: MediaQuery.of(context).size.height * 0.02, // Khoảng cách giữa tiêu đề và slide
),
CarouselSlider(
  options: CarouselOptions(
    height: 180.0,
    autoPlay: true,
    enlargeCenterPage: true,
    aspectRatio: 16 / 9,
    autoPlayCurve: Curves.fastOutSlowIn,
    enableInfiniteScroll: true,
    autoPlayAnimationDuration: const Duration(milliseconds: 800),
    viewportFraction: 0.8,
  ),
  items: bannerImages.map((imagePath) {
    return Builder(
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }).toList(),
),
         Padding(
  padding: EdgeInsets.symmetric(
    horizontal: MediaQuery.of(context).size.width * 0.03,
  ),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Text(
        'Tất Cả Xe Ô Tô',
        style: TextStyle(
          letterSpacing: 1.5,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 3, 163, 67),
          fontSize: 19,
        ),
      ),
     ElevatedButton(
  style: ElevatedButton.styleFrom(
    elevation: 8, // Độ cao để tạo bóng
    backgroundColor: Colors.white, // Màu nền
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8), // Góc bo tròn
    ),
    shadowColor:  const Color.fromARGB(255, 67, 207, 81).withOpacity(0.5), // Màu bóng
  ),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BrandsPage()),
    );
  },
  child: const Row(
    mainAxisSize: MainAxisSize.min, // Chỉ chiếm không gian cần thiết
    children: [
      Icon(
        Icons.tornado_outlined,
        color: Color.fromARGB(255, 67, 207, 81),
      ),
      SizedBox(width: 5), // Khoảng cách giữa icon và text
      Text(
        "Tìm Theo Hãng Xe",
        style: TextStyle(
          color: Colors.black, // Màu chữ
          fontSize: 16, // Kích thước chữ
        ),
      ),
    ],
  ),
),
    ],
  ),
),
          StreamBuilder(
  stream: FirebaseFirestore.instance.collection("BookedCars").snapshots(),
  builder: (context, AsyncSnapshot<QuerySnapshot> bookedSnapshot) {
    if (!bookedSnapshot.hasData) {
      return const Center(child: CircularProgressIndicator());
    }

    // Lấy danh sách các carId đã được thuê
    List<String> bookedCarIds = bookedSnapshot.data!.docs
        .map((doc) => doc['car id'].toString())
        .toList();

    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("Cars").snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> carsSnapshot) {
        if (!carsSnapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        // Lọc danh sách các xe không nằm trong danh sách bookedCarIds
        List<QueryDocumentSnapshot> availableCars = carsSnapshot.data!.docs
            .where((doc) => !bookedCarIds.contains(doc['id'].toString()))
            .toList();

        if (availableCars.isEmpty) {
          return const Center(
            child: Text(
              'Không có xe nào có sẵn để thuê.',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: availableCars.length,
          itemBuilder: (context, index) {
            final DocumentSnapshot carDoc = availableCars[index];
            final String carname = carDoc['make'].toString();

            final String priceString = carDoc['price'].toString();
            final int price = int.tryParse(priceString) ?? 0;
            final formattedPrice =
                NumberFormat("#,##0", "vi_VN").format(price);

            if (searchcontroller.text.isEmpty ||
                carname
                    .toLowerCase()
                    .contains(searchcontroller.text.toLowerCase())) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.02,
                  left: MediaQuery.of(context).size.height * 0.01,
                  right: MediaQuery.of(context).size.height * 0.02,
                ),
                child: DetailContainer(
                  image: carDoc['image'].toString(),
                  text: '$formattedPrice đ/Ngày',
                  title:
                      '${carDoc['make'].toString()} ${carDoc['model'].toString()}',
                  subtitle:
                      '${carDoc['category'].toString()}\nChủ Xe: ${carDoc['addedBy'].toString()}',
                  ontap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CarDetail(documentSnapshot: carDoc),
                      ),
                    );
                  },
                ),
              );
            } else {
              return Container();
            }
          },
        );
      },
    );
  },
),
        ],
      ),
    ),
  );
}
}
