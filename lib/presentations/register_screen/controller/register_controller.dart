import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/models/users_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sportsapp/presentations/login_screen/login_screen.dart';

class RegisterController extends GetxController {
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final phonenumberController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  RxBool obscurePassword = true.obs; // Define obscurePassword
  RxBool obscureConfirmPassword = true.obs; // Define obscureConfirmPassword
  RxList<Users> userList = RxList<Users>([]);
  final FirebaseAuth auth = FirebaseAuth.instance;
  final _storage = GetStorage();
  String? imageUrl;

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllUsers();
  }

  Future<void> fetchAllUsers() async {
    try {
      isLoading.value = true;
      userList.clear();
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      userList.assignAll(
        querySnapshot.docs
            .map((doc) => Users.fromJson(doc.data() as Map<String, dynamic>))
            .toList(),
      );
      debugPrint(userList.length.toString());
      //isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      debugPrint("Error $e");
      throw Exception(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(
    String email,
    String password,
    String? imageUrl,
    String? firstName,
    String? lastName,
    String? phoneNumber,
  ) async {
    try {
      isLoading.value = true;
      if (checkIfEmailExists(email)) {
        throw Exception('Email already exists. Cannot register.');
      }

      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      Users newUser = Users(
        userRole: 'user',
        phoneNumber: phoneNumber!,
        email: email,
        firstName: firstName!,
        lastName: lastName!,
        imageUrl: imageUrl!,
      );

      await storeUserInFirestore(newUser);

      Get.snackbar('Success!', 'Registration was successful',
          duration: const Duration(seconds: 5),
          backgroundColor: Colors.tealAccent);

      //get to login screen
      Get.off(LoginScreen());

      //user.value = newUser;
    } catch (e) {
      Get.snackbar('Error!', e.toString(),
          duration: const Duration(seconds: 5));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> storeUserInFirestore(Users user) async {
    try {
      isLoading.value = true;
      await FirebaseFirestore.instance.collection('users').add(user.toJson());
      Get.snackbar('Success!', 'User data stored in Firestore',
          duration: const Duration(seconds: 5));
      await fetchAllUsers();
    } catch (e) {
      Get.snackbar('Error!', e.toString(),
          duration: const Duration(seconds: 5));
    } finally {
      isLoading.value = false;
    }
  }

  bool checkIfEmailExists(String email) {
    return userList.any((user) => user.email == email);
  }

//method should accept image, not pick image
  Future<String?> uploadImageToFirebaseStorage(File image) async {
    try {
      isLoading.value = true;
      if (image == null) {
        throw Exception('No image selected');
      }

      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('user_profiles/${DateTime.now().millisecondsSinceEpoch}');
      final UploadTask uploadTask = storageRef.putFile(image);
      final TaskSnapshot taskSnapshot = await uploadTask;
      final String imageUrl = await taskSnapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      debugPrint('Error! $e');
      throw Exception(e);
    } finally {
      isLoading.value = false; // Set loading state back to false
    }
  }

  // Future<String?> uploadImageToFirebaseStorage() async {
  //   try {
  //     isLoading.value = true;
  //     final XFile? pickedImage =
  //         await ImagePicker().pickImage(source: ImageSource.gallery);
  //     if (pickedImage == null) {
  //       return null;
  //     }

  //     final File imageFile = File(pickedImage.path);
  //     final Reference storageRef = FirebaseStorage.instance
  //         .ref()
  //         .child('user_profiles/${DateTime.now().millisecondsSinceEpoch}');
  //     final UploadTask uploadTask = storageRef.putFile(imageFile);
  //     final TaskSnapshot taskSnapshot = await uploadTask;
  //     final String imageUrl = await taskSnapshot.ref.getDownloadURL();
  //     return imageUrl;
  //   } catch (e) {
  //     throw Exception(e);
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

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
