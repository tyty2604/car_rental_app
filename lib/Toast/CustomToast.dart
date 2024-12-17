import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class CustomToast {
    void Toastt(String? msg){
        Fluttertoast.showToast(
            msg: msg.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 4,
            backgroundColor: const Color.fromARGB(255, 67, 207, 81),
            textColor: const Color.fromARGB(255, 240, 241, 243),
            fontSize: 16.0
        );
    }

  }
