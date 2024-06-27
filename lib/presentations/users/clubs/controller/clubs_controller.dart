import 'dart:io';
import 'dart:math';
import 'package:get/get.dart';
import '../all_teams_screen.dart';
import 'package:flutter/material.dart';
import 'package:mpesadaraja/mpesadaraja.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../../data/models/fixtures_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../data/models/club_teams_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../admins/controller/admin_controller.dart';
import '../../../login_screen/controller/login_controller.dart';

class ClubController extends GetxController {
  final AdminController adminController = Get.put(AdminController());
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode locationFocusNode = FocusNode();
  final FocusNode postalCodeFocusNode = FocusNode();
  final FocusNode contactEmailFocusNode = FocusNode();
  final LoginController loginController = Get.find();
  final List<String> sportsTypes = ['Football', 'Basketball', 'Rugby'];
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
    'Uasin Gishu',
  ];

  final TextEditingController? postalCodeController = TextEditingController();
  final TextEditingController? clubEmailController = TextEditingController();
  final TextEditingController? nameController = TextEditingController();

  String? clubType;
  String? logoUrl;

  //final List<ClubTeamsData> teams = <ClubTeamsData>[].obs;
  late DateTime matchDateController = DateTime.now();
  final TextEditingController locationController = TextEditingController();
  final RxString selectedTeam1 = ''.obs;
  final RxString selectedTeam2 = ''.obs;

  // Reactive list to store the clubsTeamsData fetched
  RxList<ClubTeamsData> clubsTeamsData = <ClubTeamsData>[].obs;
  // Reactive list to store the fixtures fetched
  RxList<Fixture> fixtures = <Fixture>[].obs;

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
    //fetchAllFixtures();
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

  //mpesa stk push
  Future<bool> performMpesaStkPush(String phoneNumber) async {
    try {
      final MpesaDaraja mpesaStk = MpesaDaraja(
        consumerKey: dotenv.env['CONSUMER_KEY']!,
        consumerSecret: dotenv.env['CONSUMER_SECRET']!,
        passKey: dotenv.env['PASSKEY']!,
        //accessToken: dotenv.env['ACCESS_TOKEN']!, // Ensure this is correctly set
      );

      // Validate and set the access token
      //await mpesaStk.li();

      final Response resp = await mpesaStk.lipaNaMpesaStk(
        dotenv.env['SHORT_CODE']!,
        10,
        phoneNumber,
        dotenv.env['SHORT_CODE']!,
        phoneNumber,
        dotenv.env['CALLBACK_URL']!,
        'accountReference',
        'Registration Fee',
      );

      if (!resp.hasError) {
        debugPrint(resp.body.toString());
        return true;
      } else {
        debugPrint(resp.body.toString());
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  // Future<bool> performMpesaStkPush(String phoneNumber) async {
  //   try {
  //     final MpesaDaraja mpesaStk = MpesaDaraja(

  //       consumerKey: dotenv.env['CONSUMER_KEY']!,
  //       consumerSecret: dotenv.env['CONSUMER_SECRET']!,
  //       passKey: dotenv.env['PASSKEY']!,
  //     ).;

  //     final Response resp = await mpesaStk.lipaNaMpesaStk(

  //         dotenv.env['SHORT_CODE']!,
  //         10,
  //         phoneNumber.toString(),
  //         dotenv.env['SHORT_CODE']!,
  //         phoneNumber.toString(),
  //         dotenv.env['CALLBACK_URL']!,
  //         'accountReference',
  //         'Registeration Fee');

  //     debugPrint(resp.body.toString());
  //     debugPrint(resp.bodyString.toString());

  //     if (!resp.hasError) {
  //       debugPrint(resp.body.toString());
  //       debugPrint(resp.bodyString.toString());
  //       return true;
  //     } else {
  //        debugPrint(resp.body.toString());
  //       debugPrint(resp.bodyString.toString());
  //       return false;
  //     }
  //   } catch (e) {
  //     debugPrint(e.toString());
  //     throw Exception();
  //   }
  // }

  // Method to create a new club

  // Future<void> createNewClub(ClubTeamsData clubData, String phoneNumber) async {
  //   isLoading.value = true;
  //   try {
  //     bool paymentSuccessful = await performMpesaStkPush(phoneNumber);
  //     clubData.hasPaidRegistrationFee = paymentSuccessful;
  //     if (paymentSuccessful) {
  //       // Proceed to save club data in Firestore
  //       await FirebaseFirestore.instance
  //           .collection('clubs')
  //           .doc(clubData.id)
  //           .set(clubData.toJson());
  //       Get.snackbar("Success", "Club created successfully!");
  //     } else {
  //       Get.snackbar("Error", "Payment unsuccessful. Please try again.");
  //     }
  //   } catch (e) {
  //     print('Error during club creation: $e');
  //     Get.snackbar("Error", "An error occurred while creating the club.");
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

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
      //Show error snackbar
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
      // Get.snackbar(
      //   'Success',
      //   'Clubs fetched successfully',
      //   snackPosition: SnackPosition.TOP,
      //   backgroundColor: Colors.green,
      //   colorText: Colors.white,
      // );
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

// Method to fetch all fixtures and store them in a reactive list
  Future<void> fetchAllFixtures() async {
    try {
      //isLoading(true);
      fixtures.clear();

      // Retrieve all records from Firestore
      final QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('fixtures').get();

      // Convert each document to Fixture object and add to the reactive list
      querySnapshot.docs.forEach((doc) {
        final fixture = Fixture.fromJson(doc.data() as Map<String, dynamic>);
        fixtures.add(fixture);
        //isLoading(false);
      });

      print('fixtures: ${fixtures.length}');

      // Show success snackbar
      // Get.snackbar(
      //   'Success',
      //   'Fixtures fetched successfully',
      //   snackPosition: SnackPosition.TOP,
      //   backgroundColor: Colors.green,
      //   colorText: Colors.white,
      // );
    } catch (e) {
      print('Error fetching fixtures: $e');
      // Show error snackbar
      Get.snackbar(
        'Error',
        'Failed to fetch fixtures',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  // Method to create fixture
  Future<void> createFixture({
    required String team1Id,
    required String team2Id,
    required String sport,
    required DateTime matchDateTime,
    required String location,
  }) async {
    try {
      // Perform validation: Ensure teams belong to the same sport
      final ClubTeamsData team1 = clubsTeamsData.firstWhere(
        (team) => team.id == team1Id,
        orElse: () => ClubTeamsData(id: '', sport: ''),
      );
      final ClubTeamsData team2 = clubsTeamsData.firstWhere(
        (team) => team.id == team2Id,
        orElse: () => ClubTeamsData(id: '', sport: ''),
      );

      if (team1.sport != team2.sport) {
        throw Exception('Teams must belong to the same sport for a fixture.');
      }

      // Generate fixture ID
      String fixtureId = generateRandomString();

      // Create fixture object
      Fixture fixture = Fixture(
        fixtureId: fixtureId,
        team1Id: team1Id,
        team2Id: team2Id,
        sport: sport,
        matchDateTime: matchDateTime,
        location: location,
      );

      // Save fixture to Firestore
      await FirebaseFirestore.instance
          .collection('fixtures')
          .doc(fixtureId)
          .set(fixture.toJson());

      // Show success snackbar
      Get.snackbar(
        'Success',
        'Fixture created successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      await fetchAllFixtures();
    } catch (e) {
      print('Error creating fixture: $e');
      // Show error snackbar
      Get.snackbar(
        'Error',
        'Failed to create fixture: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Method to delete a fixture by ID
  Future<void> deleteFixture(String fixtureId) async {
    try {
      isLoading(true);

      // Delete fixture from Firestore
      await FirebaseFirestore.instance
          .collection('fixtures')
          .doc(fixtureId)
          .delete();

      // Clear the reactive list
      fixtures.clear();

      // Fetch updated fixtures
      await fetchAllFixtures();

      // Show success snackbar
      Get.snackbar(
        'Success',
        'Fixture deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error deleting fixture: $e');
      // Show error snackbar
      Get.snackbar(
        'Error',
        'Failed to delete fixture: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

// Method to delete a club by ID
  Future<void> deleteClub(String clubId) async {
    try {
      isLoading(true);

      // Delete club from Firestore
      await FirebaseFirestore.instance.collection('clubs').doc(clubId).delete();

      // Clear the reactive list
      clubsTeamsData.clear();

      // Fetch updated clubs
      await fetchAllClubs();

      // Show success snackbar
      Get.snackbar(
        'Success',
        'Club deleted successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error deleting club: $e');
      // Show error snackbar
      Get.snackbar(
        'Error',
        'Failed to delete club: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  // Method to update fixture date
  Future<void> updateFixtureDate(String fixtureId, String newDate) async {
    try {
      isLoading(true);

      // Update fixture date in Firestore
      await FirebaseFirestore.instance
          .collection('fixtures')
          .doc(fixtureId)
          .update({
        'matchDateTime': newDate,
      });

      // Fetch updated fixtures
      await fetchAllFixtures();

      // Show success snackbar
      Get.snackbar(
        'Success',
        'Fixture date updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error updating fixture date: $e');
      // Show error snackbar
      Get.snackbar(
        'Error',
        'Failed to update fixture date: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  // Method to update fixture result
  Future<void> updateFixtureResult(String fixtureId, String newResult) async {
    try {
      isLoading(true);

      // Update fixture result in Firestore
      await FirebaseFirestore.instance
          .collection('fixtures')
          .doc(fixtureId)
          .update({
        'result': newResult,
      });

      // Fetch updated fixtures
      await fetchAllFixtures();

      // Show success snackbar
      Get.snackbar(
        'Success',
        'Fixture result updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error updating fixture result: $e');
      // Show error snackbar
      Get.snackbar(
        'Error',
        'Failed to update fixture result: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  // Method to update fixture location
  Future<void> updateFixtureLocation(
      String fixtureId, String newLocation) async {
    try {
      isLoading(true);

      // Update fixture location in Firestore
      await FirebaseFirestore.instance
          .collection('fixtures')
          .doc(fixtureId)
          .update({
        'location': newLocation,
      });

      // Fetch updated fixtures
      await fetchAllFixtures();

      // Show success snackbar
      Get.snackbar(
        'Success',
        'Fixture location updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error updating fixture location: $e');
      // Show error snackbar
      Get.snackbar(
        'Error',
        'Failed to update fixture location: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }
}


 // Future<bool> performMpesaStkPush(dynamic phoneNumber) async {
  //   try {
  //     final MpesaResponse response = await FlutterMpesaSTK(
  //             dotenv.env['CONSUMER_KEY']!,
  //             dotenv.env['CONSUMER_SECRET']!,
  //             dotenv.env['PASSKEY']!, // stk_password
  //             dotenv.env['SHORT_CODE']!,
  //             dotenv.env['CALLBACK_URL']!,
  //             'Test Payment', // defaultMessage,
  //             env: "sandbox")
  //         .stkPush(Mpesa(
  //       10,
  //       phoneNumber,
  //     ));

  //     debugPrint("M-Pesa response: ${response.body}");

  //     if (response.status == 200) {
  //       return true;
  //     } else {
  //       debugPrint("M-Pesa STK push failed with status: ${response.status}");
  //       return false;
  //     }
  //   } catch (e) {
  //     debugPrint('Error during M-Pesa STK push: $e');
  //     return false; // Return false instead of throwing an exception
  //   }
  // }



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