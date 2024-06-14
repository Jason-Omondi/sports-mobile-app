import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/models/users_model.dart';
import '../../users/clubs/club_categories.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../users/dashboard/user_homescreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxList<Users> userList = RxList<Users>([]);
  RxList<Users> normalUsersList = RxList<Users>([]);
  RxList<Users> adminUsersList = RxList<Users>([]);
  RxBool isLoading = false.obs;
  final _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchAllUsers();
  }

  // Fetch all users
  Future<void> fetchAllUsers() async {
    try {
      //isLoading(true);
      userList.clear();
      normalUsersList.clear();
      adminUsersList.clear();
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      List<Users> users = querySnapshot.docs
          .map((doc) => Users.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      userList.assignAll(users);
      normalUsersList.assignAll(users.where((user) => user.userRole == 'user'));
      adminUsersList.assignAll(users.where((user) => user.userRole == 'admin'));
      debugPrint(userList.length.toString());
    } catch (e) {
      debugPrint("Error $e");
      throw Exception(e);
    } finally {
      isLoading(false);
    }
  }

  // Future<void> fetchAllUsers() async {
  //   try {
  //     //isLoading(true);
  //     userList.clear();
  //     QuerySnapshot querySnapshot =
  //         await FirebaseFirestore.instance.collection('users').get();
  //     userList.assignAll(
  //       querySnapshot.docs
  //           .map((doc) => Users.fromJson(doc.data() as Map<String, dynamic>))
  //           .toList(),
  //     );
  //     debugPrint(userList.length.toString());
  //   } catch (e) {
  //     debugPrint("Error $e");
  //     throw Exception(e);
  //   } finally {
  //     isLoading(false);
  //   }
  // }

  // Login functionality
  Future<void> loginUser(String email, String password) async {
    try {
      await fetchAllUsers();
      isLoading(true);
      if (!checkIfEmailExists(email)) {
        Get.snackbar('Info!',
            "$email does not exist in our systems, consider registering!",
            duration: Duration(seconds: 5), backgroundColor: Colors.red[300]);
        throw Exception('User with email $email does not exist.');
      }

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Users user = userList.firstWhere((user) => user.email == email);

      if (user.userRole == null || user.userRole.isEmpty) {
        throw Exception('User role not defined for $email');
      }

      // Save user information to GetStorage
      saveUserInfoToStorage(
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        userRole: user.userRole,
        phoneNumber: user.phoneNumber,
        imageUrl: user.imageUrl,
      );

      // Navigate based on user role
      if (user.userRole == 'admin') {
        Get.off(() => ClubCategories(loginController: this));
      } else if (user.userRole == 'user') {
        Get.off(() => UserDashboardScreen(loginController: this));
      }

      Get.snackbar('Success', 'Welcome to Sports Center!',
          backgroundColor: Colors.teal);
    } catch (e) {
      Get.snackbar("Error!", "Something went wrong: $e",
          duration: Duration(seconds: 5), backgroundColor: Colors.redAccent);
      debugPrint('Error during login: $e');
      throw Exception(e);
    } finally {
      isLoading(false);
    }
  }

  /*
  Future<void> loginUser(String email, String password) async {
    try {
      await fetchAllUsers();
      isLoading(true);
      if (!checkIfEmailExists(email)) {
        Get.snackbar('Info!',
            "$email does not exist in our systems, consider registering!",
            duration: Duration(seconds: 5), backgroundColor: Colors.red[300]);
        throw Exception('User with email $email does not exist.');
      }

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Users user = userList.firstWhere((user) => user.email == email);

      // Save user information to GetStorage
      saveUserInfoToStorage(
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        userRole: user.userRole,
        phoneNumber: user.phoneNumber,
        imageUrl: user.imageUrl,
      );

      // Do something after successful login, like navigating to a new screen
      debugPrint('User logged in successfully: ${userCredential.user!.email}');
      Get.off(() => UserDashboardScreen(
            loginController: this,
          ));
      Get.snackbar('Success', 'Welcome to Sports Center!',
          backgroundColor: Colors.teal);
    } catch (e) {
      Get.snackbar("Error!", "Something went wrong: $e",
          duration: Duration(seconds: 5), backgroundColor: Colors.redAccent);
      debugPrint('Error during login: $e');
      throw Exception(e);
    } finally {
      isLoading(false);
    }
  }
*/
  // Method to check if email exists in the user list
  bool checkIfEmailExists(String email) {
    return userList.any((user) => user.email == email);
  }

  //store the current logged in user information to get storage
  void saveUserInfoToStorage({
    required String firstName,
    required String lastName,
    required String email,
    required String userRole,
    required String phoneNumber,
    required String imageUrl,
  }) {
    try {
      isLoading.value = true;
      _storage.write('first_name', firstName);
      _storage.write('last_name', lastName);
      _storage.write('email', email);
      _storage.write('user_role', userRole);
      _storage.write('phone_number', phoneNumber);
      _storage.write('image_url', imageUrl);
    } catch (e) {
      throw Exception(e);
    } finally {
      isLoading.value = false;
    }
  }
}
