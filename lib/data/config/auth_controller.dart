import 'package:get/get.dart';
import '../models/users_model.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AuthController extends GetxController {
  Rx<Users?> user = Rx<Users?>(null);
  RxList<Users> userList = RxList<Users>([]);
  FirebaseAuth auth = FirebaseAuth.instance;
  final storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchAllUsers();
  }

  //fetch all users and store in reactive list
  Future<void> fetchAllUsers() async {
    try {
      //userList.clear();
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      userList.assignAll(
        querySnapshot.docs
            .map((doc) => Users.fromJson(doc.data() as Map<String, dynamic>))
            .toList(),
      );
      debugPrint(userList.length.toString());
      // Get.snackbar('Success!', 'Fetched all users data',
      //     duration: const Duration(seconds: 5));
    } catch (e) {
      debugPrint("Error $e");
      throw Exception(e);
      // Get.snackbar('Error!', e.toString(),
      //     duration: const Duration(seconds: 5));
    }
  }

  //login functionality

  // register functionality

  // check if email exist
  bool checkIfEmailExists(String email) {
    return userList.any((user) => user.email == email);
  }
}
