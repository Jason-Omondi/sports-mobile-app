import 'dart:io';
import 'dart:math';
import 'package:get/get.dart';
import '../admin_profile_screen.dart';
import 'package:flutter/material.dart';
import '../admin_announcments_list.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/models/users_model.dart';
import '../../../data/models/events_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../users/clubs/controller/clubs_controller.dart';

class AdminController extends GetxController {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  RxBool obscurePassword = true.obs;
  RxBool obscureConfirmPassword = true.obs;
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmpasswordFocusNode = FocusNode();
  final FocusNode lnameFocusNode = FocusNode();
  final FocusNode fnameFocusNode = FocusNode();
  final FocusNode phoneNumberFocusNode = FocusNode();
  RxList<Announcement> announcements = RxList<Announcement>([]);
  final ClubController clubController = Get.find<ClubController>();

  final _storage = GetStorage();
  RxList<Users> allUserList = RxList<Users>([]);
  RxList<Users> normalUsersList = RxList<Users>([]);
  RxList<Users> adminUsersList = RxList<Users>([]);
  final FirebaseAuth auth = FirebaseAuth.instance;
  String? imageUrl;

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllUsers();
    fetchAnnouncements();
  }

  String generateUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        Random().nextInt(10000).toString();
  }

  //fetch all users
  Future<void> fetchAllUsers() async {
    try {
      isLoading.value = true;
      allUserList.clear();
      normalUsersList.clear();
      adminUsersList.clear();
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      List<Users> users = querySnapshot.docs
          .map((doc) => Users.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      allUserList.assignAll(users);
      normalUsersList.assignAll(users.where((user) => user.userRole == 'user'));
      adminUsersList.assignAll(users.where((user) => user.userRole == 'admin'));
      debugPrint(allUserList.length.toString());
    } catch (e) {
      debugPrint("Error $e");
      throw Exception(e);
    } finally {
      isLoading(false);
    }
  }

  //create an admin
  Future<void> createAdmin(
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
        throw Exception('Email already exists!');
      }

      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      Users newUser = Users(
        userRole: 'admin',
        phoneNumber: phoneNumber!,
        email: email,
        firstName: firstName!,
        lastName: lastName!,
        imageUrl: imageUrl!,
      );

      await storeUserInFirestore(newUser);

      Get.snackbar('Success!', 'Admin has been created successfully!',
          duration: const Duration(seconds: 5),
          backgroundColor: Colors.tealAccent);

      Get.off(const ManageAdmins());

      //user.value = newUser;
    } catch (e) {
      Get.snackbar('Error!', e.toString(),
          duration: const Duration(seconds: 5));
    } finally {
      isLoading.value = false;
    }
  }

  bool checkIfEmailExists(String email) {
    return allUserList.any((user) => user.email == email);
  }

  //store admin to firestore all users
  Future<void> storeUserInFirestore(Users user) async {
    try {
      isLoading.value = true;
      await FirebaseFirestore.instance.collection('users').add(user.toJson());
      Get.snackbar('Success!', 'Request submitted successfully!',
          snackPosition: SnackPosition.BOTTOM,
          isDismissible: true,
          duration: const Duration(seconds: 5));
      await fetchAllUsers();
    } catch (e) {
      Get.snackbar('Error!', e.toString(),
          duration: const Duration(seconds: 5));
    } finally {
      isLoading.value = false;
    }
  }

//method to delete user in firestore via the email address
  Future<void> deleteUser(String email) async {
    try {
      isLoading.value = true;
      await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });
      Get.snackbar('Success!', 'User deleted successfully!',
          duration: const Duration(seconds: 5));
      await fetchAllUsers();
    } catch (e) {
      debugPrint("Error: $e");
      Get.snackbar('Error!', e.toString(),
          duration: const Duration(seconds: 5));
      throw Exception(e);
    } finally {
      isLoading.value = false;
    }
  }

//method to upload image file and return download string
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

// create an event and store to firestore
  Future<void> createAnnouncement(Announcement announcement) async {
    try {
      isLoading.value = true;

      String uniqueId = generateUniqueId();
      Announcement announcementWithId = Announcement(
        id: uniqueId,
        title: announcement.title,
        description: announcement.description,
        type: announcement.type,
        startDate: announcement.startDate,
        endDate: announcement.endDate,
        createdBy: announcement.createdBy,
        fixtureId: announcement.fixtureId,
        targetAudience: announcement.targetAudience,
        offerDetails: announcement.offerDetails,
        campaignGoals: announcement.campaignGoals,
        channels: announcement.channels,
      );

      await FirebaseFirestore.instance
          .collection('announcements')
          .doc(uniqueId)
          .set(announcementWithId.toJson());

      Get.snackbar('Success!', 'Announcement created successfully!',
          duration: const Duration(seconds: 5),
          backgroundColor: Colors.tealAccent);
      await fetchAnnouncements();
      Get.to(AnnouncementsScreen());
    } catch (e) {
      Get.snackbar('Error!', e.toString(),
          duration: const Duration(seconds: 5));
    } finally {
      isLoading.value = false;
    }
  }

//fetch all events and store in reactive list
  Future<void> fetchAnnouncements() async {
    try {
      isLoading.value = true;
      announcements.clear();
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('announcements').get();
      List<Announcement> fetchedAnnouncements = querySnapshot.docs
          .map((doc) =>
              Announcement.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      announcements.assignAll(fetchedAnnouncements);

      debugPrint("Announcements: ${announcements.length}");
    } catch (e) {
      debugPrint("Error fetching announcements: $e");
      throw Exception(e);
    } finally {
      isLoading.value = false;
    }
  }

  //delete
  Future<void> deleteAnnouncement(String announcementId) async {
    try {
      isLoading(true);
      await FirebaseFirestore.instance
          .collection('announcements')
          .doc(announcementId)
          .delete();
      announcements
          .removeWhere((announcement) => announcement.id == announcementId);
      await fetchAnnouncements();
      Get.snackbar('Success', 'Event deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete announcement: $e');
    } finally {
      isLoading(false);
    }
  }
}
