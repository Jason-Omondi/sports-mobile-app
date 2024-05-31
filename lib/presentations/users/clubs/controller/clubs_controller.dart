import 'dart:io';
import 'dart:math';
import 'package:get/get.dart';
import '../all_teams_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../data/models/club_teams_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../login_screen/controller/login_controller.dart';

class ClubController extends GetxController {
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode postalCodeFocusNode = FocusNode();
  final FocusNode contactEmailFocusNode = FocusNode();
  final LoginController loginController = Get.find();
  final List<String> sportsTypes = ['Football', 'Basketball', 'Tennis'];
  final List<String> counties = [
    //'Baringo',
    //'Bomet',
    //'Bungoma',
    //'Busia',
    //'Elgeyo Marakwet',
    'Embu',
    //'Garissa',
    'Homa Bay',
    'Isiolo',
    'Kajiado',
    'Kakamega',
    'Kericho',
    'Kiambu',
    'Kilifi',
    'Kirinyaga',
    'Kisii',
    'Kisumu',
    'Kitui',
    'Kwale',
    'Laikipia',
    //'Lamu',
    'Machakos',
    'Makueni',
    'Mandera',
    'Marsabit',
    'Meru',
    //'Migori',
    'Mombasa',
    'Murang\'a',
    'Nairobi',
    'Nakuru',
    'Nandi',
    'Narok',
    'Nyamira',
    'Nyandarua',
    'Nyeri',
    'Samburu',
    'Siaya',
    'Taita Taveta',
    'Tana River',
    'Tharaka Nithi',
    'Trans Nzoia',
    //'Turkana',
    'Uasin Gishu',
    //'Vihiga',
    //'Wajir',
    //'West Pokot'
  ];

  final TextEditingController? postalCodeController = TextEditingController();
  final TextEditingController? clubEmailController = TextEditingController();
  final TextEditingController? nameController = TextEditingController();

  String? clubType;
  String? logoUrl;

  // Reactive list to store the clubsTeamsData fetched
  RxList<ClubTeamsData> clubsTeamsData = <ClubTeamsData>[].obs;

  RxBool isLoading = false.obs;
  RxBool isJuniorTeam = false.obs;
  RxString selectedSport = ''.obs;
  RxString selectedCounty = ''.obs;

  @override
  void onInit() {
    super.onInit();
    selectedSport.value = sportsTypes.isNotEmpty ? sportsTypes.first : '';
    selectedCounty.value = counties.isNotEmpty ? counties.first : '';
    fetchAllClubs();
  }

  String generateRandomString({int length = 10}) {
    const charset = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  //method should accept image
  Future<String?> uploadImageToFirebaseStorage(File image) async {
    try {
      isLoading.value = true;
      if (image == null) {
        throw Exception('No image selected');
      }

      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('team_logos/${DateTime.now().millisecondsSinceEpoch}');
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

  // Method to create new club
  Future<void> createNewClub(ClubTeamsData clubData) async {
    try {
      isLoading(true);

      // Simulate creation with delay
      await Future.delayed(Duration(seconds: 2));

      // Save club data to Firestore with the club ID as document ID
      await FirebaseFirestore.instance
          .collection('clubs')
          .doc(clubData.id)
          .set({
        'id': clubData.id,
        'name': clubData.name,
        'logoUrl': clubData.logoUrl,
        'isJuniorTeam': clubData.isJuniorTeam,
        'sport': clubData.sport,
        'county': clubData.county,
        'postalZip': clubData.postalZip,
        'contactEmail': clubData.contactEmail,
        //'clubType': clubData.clubType,
      });

      // Add the newly created club to the reactive list
      clubsTeamsData.add(clubData);

      // Show success snackbar
      Get.snackbar('Success', 'Club created successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 5));
      Get.to(() => TeamsDataScreen());
    } catch (e) {
      print('Error creating new club: $e');
      // Show error snackbar
      Get.snackbar('Error', 'Something went wrong!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          duration: Duration(seconds: 5));
    } finally {
      isLoading(false);
    }
  }

  // Method to fetch all clubs and other information and store in the reactive list
  Future<void> fetchAllClubs() async {
    try {
      isLoading(true);
      clubsTeamsData.clear();

      // Retrieve all records from Firestore
      final QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('clubs').get();

      // Convert each document to ClubTeamsData object and add to the reactive list
      querySnapshot.docs.forEach((doc) {
        final clubData = ClubTeamsData(
          id: doc.id,
          name: doc['name'],
          logoUrl: doc['logoUrl'],
          isJuniorTeam: doc['isJuniorTeam'],
          sport: doc['sport'],
          county: doc['county'],
          postalZip: doc['postalZip'],
          contactEmail: doc['contactEmail'],
          //clubType: doc['clubType'],
        );
        clubsTeamsData.add(clubData);
      });

      // Show success snackbar
      Get.snackbar(
        'Success',
        'Clubs fetched successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error fetching clubs: $e');
      // Show error snackbar
      Get.snackbar(
        'Error',
        'Failed to fetch clubs',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  // Other methods as needed
}



/*
class ClubController extends GetxController {
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode postalCodeFocusNode = FocusNode();
  final FocusNode contactEmailFocusNode = FocusNode();
  final LoginController loginController = Get.find();
  final List<String> sportsTypes = ['Football', 'Basketball', 'Tennis'];
  final List<String> counties = [
    //'Baringo',
    //'Bomet',
    //'Bungoma',
    //'Busia',
    //'Elgeyo Marakwet',
    'Embu',
    //'Garissa',
    'Homa Bay',
    'Isiolo',
    'Kajiado',
    'Kakamega',
    'Kericho',
    'Kiambu',
    'Kilifi',
    'Kirinyaga',
    'Kisii',
    'Kisumu',
    'Kitui',
    'Kwale',
    'Laikipia',
    //'Lamu',
    'Machakos',
    'Makueni',
    'Mandera',
    'Marsabit',
    'Meru',
    //'Migori',
    'Mombasa',
    'Murang\'a',
    'Nairobi',
    'Nakuru',
    'Nandi',
    'Narok',
    'Nyamira',
    'Nyandarua',
    'Nyeri',
    'Samburu',
    'Siaya',
    'Taita Taveta',
    'Tana River',
    'Tharaka Nithi',
    'Trans Nzoia',
    //'Turkana',
    'Uasin Gishu',
    //'Vihiga',
    //'Wajir',
    //'West Pokot'
  ];

  final TextEditingController? postalCodeController = TextEditingController();
  final TextEditingController? clubEmailController = TextEditingController();
  final TextEditingController? nameController = TextEditingController();

  String? clubType;
  String? logoUrl;

  // Reactive list to store the clubsTeamsData fetched
  RxList<ClubTeamsData> clubsTeamsData = <ClubTeamsData>[].obs;

  RxBool isLoading = false.obs;

  String generateRandomString({int length = 10}) {
    const charset = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  //method should accept image
  Future<String?> uploadImageToFirebaseStorage(File image) async {
    try {
      isLoading.value = true;
      if (image == null) {
        throw Exception('No image selected');
      }

      final Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('team_logos/${DateTime.now().millisecondsSinceEpoch}');
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

  // Method to create new club
  Future<void> createNewClub(ClubTeamsData clubData) async {
    try {
      isLoading(true);

      // Simulate creation with delay
      await Future.delayed(Duration(seconds: 2));

      // Save club data to Firestore with the club ID as document ID
      await FirebaseFirestore.instance
          .collection('clubs')
          .doc(clubData.id)
          .set({
        'name': clubData.name,
        'logoUrl': clubData.logoUrl,
        'isJuniorTeam': clubData.isJuniorTeam,
        'sport': clubData.sport,
        'county': clubData.county,
        'postalZip': clubData.postalZip,
        'contactEmail': clubData.contactEmail,
        'clubType': clubData.clubType,
      });

      // Add the newly created club to the reactive list
      clubsTeamsData.add(clubData);

      // Show success snackbar
      Get.snackbar(
        'Success',
        'Club created successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error creating new club: $e');
      // Show error snackbar
      Get.snackbar(
        'Error',
        'Failed to create club',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  // Method to fetch all clubs and other information and store in the reactive list
  Future<void> fetchAllClubs() async {
    try {
      isLoading(true);
      clubsTeamsData.clear();

      // Retrieve all records from Firestore
      final QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('clubs').get();

      // Convert each document to ClubTeamsData object and add to the reactive list
      querySnapshot.docs.forEach((doc) {
        final clubData = ClubTeamsData(
          id: doc.id,
          name: doc['name'],
          logoUrl: doc['logoUrl'],
          isJuniorTeam: doc['isJuniorTeam'],
          sport: doc['sport'],
          county: doc['county'],
          postalZip: doc['postalZip'],
          contactEmail: doc['contactEmail'],
          clubType: doc['clubType'],
        );
        clubsTeamsData.add(clubData);
      });

      // Show success snackbar
      Get.snackbar(
        'Success',
        'Clubs fetched successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error fetching clubs: $e');
      // Show error snackbar
      Get.snackbar(
        'Error',
        'Failed to fetch clubs',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  // Other methods as needed
}
*/