import 'package:car_rental_app/Component/custom_btn.dart';
import 'package:car_rental_app/view/BookedCars/alluserbookedcars.dart';
import 'package:car_rental_app/view/home_page.dart';
import 'package:car_rental_app/view/adminCarlist/car_list_admin.dart';
import 'package:flutter/material.dart';
import 'addcars/add_cars.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({super.key});

  @override
  State<AdminPanel> createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
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
                    'Trang Quản Trị',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Icon(
              Icons.admin_panel_settings,
              size: 250,
              color: Color.fromARGB(255, 3, 122, 51),
            ),
            const SizedBox(
              height: 50,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text('Bạn Muốn Gì',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color:Color.fromARGB(255, 67, 207, 81))),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 40, left: 20, right: 20, bottom: 20),
              child: CustomBtn(
                color: Colors.white70,
                icon: const Icon(
                  Icons.car_crash_outlined,
                  size: 40,
                ),
                title: 'Thêm Ô Tô',
                ontap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddCars(),
                      ));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: CustomBtn(
                color: Colors.blueGrey.shade200,
                icon: const Icon(
                  Icons.car_repair,
                  size: 40,
                ),
                title: 'Danh Sách Ô Tô',
                ontap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminCarList(),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: CustomBtn(
                color: Colors.white70,
                icon: const Icon(
                  Icons.car_rental,
                  size: 40,
                ),
                title: 'Xe Đã Đặt',
                ontap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AllUserBookedCars(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
