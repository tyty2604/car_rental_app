import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../Component/detail_container.dart';
import 'cardetail.dart';

class BrandsPage extends StatefulWidget {
  const BrandsPage({super.key});

  @override
  State<BrandsPage> createState() => _BrandsPageState();
}

class _BrandsPageState extends State<BrandsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Danh Sách Hãng Xe',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Cars').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Lấy danh sách các hãng xe
          List<String> brands = snapshot.data!.docs
              .map((doc) => doc['make'].toString())
              .toSet()
              .toList(); // Loại bỏ trùng lặp

          return ListView.builder(
            itemCount: brands.length,
            itemBuilder: (context, index) {
              String brand = brands[index];
               int carCount = snapshot.data!.docs
                  .where((doc) => doc['make'].toString() == brand)
                  .length;            
              return Padding(
                padding: const EdgeInsets.all(8.0), // Khoảng cách xung quanh box
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white, // Màu nền cho box
                    borderRadius: BorderRadius.circular(10), // Góc bo tròn
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 67, 207, 81).withOpacity(0.5), // Màu bóng
                        // spreadRadius: 3,
                       // blurRadius: 3,
                        offset:
                            const Offset(0, 3), // Vị trí bóng
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(
                      brand,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      'Số Xe Hiện Có: $carCount',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CarsByBrandPage(brand: brand),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


class CarsByBrandPage extends StatelessWidget {
  final String brand;

  const CarsByBrandPage({super.key, required this.brand});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Xe Thuộc Hãng: $brand',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Cars')
            .where('make', isEqualTo: brand)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Lấy danh sách car id đã book từ BookerCars
          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('BookedCars')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> bookerSnapshot) {
              if (!bookerSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              // Lấy danh sách car id đã book
              List<String> bookedCarIds = bookerSnapshot.data!.docs
                  .map((doc) => doc['car id'].toString())
                  .toList();

              // Lọc các xe không trùng car id
              var cars = snapshot.data!.docs.where((doc) {
                return !bookedCarIds.contains(doc.id);
              }).toList();

              if (cars.isEmpty) {
                return const Center(
                  child: Text(
                    'Tất cả xe đã được thuê.',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                );
              }

              return ListView.builder(
                itemCount: cars.length,
                itemBuilder: (context, index) {
                  final carDoc = cars[index];
                  final String carname = carDoc['make'].toString();

                  final String priceString = carDoc['price'].toString();
                  final int price = int.tryParse(priceString) ?? 0;
                  final formattedPrice =
                      NumberFormat("#,##0", "vi_VN").format(price);

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
                },
              );
            },
          );
        },
      ),
    );
  }
}