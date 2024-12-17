import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Component/custom_detail_booking.dart';

class Detail extends StatefulWidget {
  final DocumentSnapshot documentsnapshot;

  const Detail({super.key, required this.documentsnapshot});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  String formatCurrency(String value) {
    try {
      final number = double.tryParse(value) ?? 0.0;
      final formatter = NumberFormat.currency(
        locale: 'vi_VN',
        symbol: '',
        decimalDigits: 0,
      );
      return formatter.format(number);
    } catch (e) {
      return value; 
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
        title: const Center(
          child: Text(
            'Chi Tiết Đơn Đặt Xe',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          CustomBooking(
              leading: const CircleAvatar(
                radius: 30.0,
                backgroundColor:  Color.fromARGB(255, 67, 207, 81),
                child: Icon(Icons.car_rental),
              ),
              title: const Text(
                'Người Đặt',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                widget.documentsnapshot['booked by'],
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              )),
          CustomBooking(
              leading: const CircleAvatar(
                radius: 30.0,
                backgroundColor:  Color.fromARGB(255, 67, 207, 81),
                child: Icon(Icons.car_crash_rounded),
              ),
              title: const Text(
                'Tên Xe',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
               '${widget.documentsnapshot['carname']} ${widget.documentsnapshot['model']}',
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              )),
          CustomBooking(
              leading: const CircleAvatar(
                radius: 30.0,
                backgroundColor: Color.fromARGB(255, 67, 207, 81),
                child: Icon(Icons.phone),
              ),
              title: const Text(
                'Số Điện Thoại',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                widget.documentsnapshot['phoneno'],
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              )),
          CustomBooking(
              leading: const CircleAvatar(
                radius: 30.0,
                backgroundColor:  Color.fromARGB(255, 67, 207, 81),
                child: Icon(Icons.car_rental),
              ),
              title: const Text(
                'Địa chỉ',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                widget.documentsnapshot['address'],
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              )),
          CustomBooking(
              leading: const CircleAvatar(
                radius: 30.0,
                backgroundColor:  Color.fromARGB(255, 67, 207, 81),
                child: Icon(Icons.car_rental),
              ),
              title: const Text(
                'Số Ngày Đặt',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                widget.documentsnapshot['booking days'],
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              )),
          CustomBooking(
              leading: const CircleAvatar(
                radius: 30.0,
                backgroundColor:  Color.fromARGB(255, 67, 207, 81),
                child: Icon(Icons.car_rental),
              ),
              title: const Text(
                'Tổng Hóa Đơn',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${formatCurrency(widget.documentsnapshot['totalbill'])} VNĐ',
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              )),
          const SizedBox(
            height: 90, // Khoảng cách giữa thông tin và nút
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: 60,
              width: 200,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 3, 122, 51),
                  borderRadius: BorderRadius.circular(20)),
              child: const Center(
                  child: Text(
                'Quay Lại',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              )),
            ),
          )
        ],
      ),
    );
  }
}
