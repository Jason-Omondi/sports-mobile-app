import 'dart:io';
import 'dart:math';
import 'package:get/get.dart';
import '../all_teams_screen.dart';
import 'package:flutter/material.dart';
import 'package:mpesadaraja/mpesadaraja.dart';
import '../../../../data/models/users_model.dart';
import '../../../../data/config/mpesa_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../../data/models/fixtures_model.dart';
import '../../../../data/models/equipment_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../data/models/club_teams_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../admins/controller/admin_controller.dart';
import '../../../login_screen/controller/login_controller.dart';

class ClubController extends GetxController {
  //final AdminController adminController = Get.put(AdminController());
  //final LoginController _loginCont = Get.find();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode locationFocusNode = FocusNode();
  final FocusNode postalCodeFocusNode = FocusNode();
  final FocusNode contactEmailFocusNode = FocusNode();
  //final LoginController loginController = Get.find();
  //final LoginController loginController = Get.find();
  //final AdminController adminController = Get.find();
  TextEditingController equipmentNameController = TextEditingController();
  TextEditingController equipmentTypeController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
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
  final List<String> equipmentNames = ['Training Kits', 'Balls', 'Sports Wear'];
  final List<String> equipmentTypes = [
    'Footballs',
    'Basketballs',
    'Rugby Balls',
    'Training Gears'
  ];
  final List<String> equipmentConditions = ['Good', 'Needs Repair'];

  String? clubType;
  String? logoUrl;

  final MpesaService _mpesaService = MpesaService();
  final LoginController lcontroller = Get.find();

  //final List<ClubTeamsData> teams = <ClubTeamsData>[].obs;
  late DateTime matchDateController = DateTime.now();
  final TextEditingController locationController = TextEditingController();
  final RxString selectedTeam1 = ''.obs;
  final RxString selectedTeam2 = ''.obs;

  // Reactive list to store the clubsTeamsData fetched
  RxList<ClubTeamsData> clubsTeamsData = <ClubTeamsData>[].obs;
  // Reactive list to store the fixtures fetched
  RxList<Fixture> fixtures = <Fixture>[].obs;
  RxList<Equipment> equipments =
      <Equipment>[].obs; // Reactive list for equipment

  RxBool isLoading = false.obs;
  RxBool isJuniorTeam = false.obs;
  RxString selectedSport = ''.obs;
  RxString selectedCounty = ''.obs;
  RxList<Users> userList = RxList<Users>([]);

  @override
  void onInit() {
    super.onInit();
    // if (Get.isRegistered<LoginController>()) {
    //   loginController = Get.find<LoginController>();
    // } else {
    //   loginController = Get.put(LoginController());
    // }
    // if (Get.isRegistered<AdminController>()) {
    //   adminController = Get.find<AdminController>();
    // } else {
    //   adminController = Get.put(AdminController());
    // }
    selectedSport.value = sportsTypes.isNotEmpty ? sportsTypes.first : '';
    selectedCounty.value = counties.isNotEmpty ? counties.first : '';
    fetchAllClubs();
    fetchAllEquipment();
    fetchAllFixtures();
    //_loginCont.normalUsersList = userList;
  }

  String generateRandomString({int length = 10}) {
    const charset = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String getTeamName(String teamId) {
    ClubTeamsData? team = clubsTeamsData.firstWhere(
      (team) => team.id == teamId,
      orElse: () => ClubTeamsData(id: teamId, name: 'Unknown Team'),
    );
    return team.name!;
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
  Future<bool> initiateStkPush(String phoneNumber, double amount) async {
    try {
      isLoading.value = true;
      await _mpesaService.lipaNaMpesa(phoneNumber, amount);
      Get.snackbar('Success', 'STK Push sent successfully.');
      return true;
    } catch (error) {
      Get.snackbar('Error', 'Failed to send STK Push. Retrying...');
      retryStkPush(phoneNumber, amount);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

//retryStk if failed
  Future<void> retryStkPush(String phoneNumber, double amount) async {
    try {
      isLoading.value = true;
      await _mpesaService.lipaNaMpesa(phoneNumber, amount);
      Get.snackbar('Success', 'STK Push sent successfully.',
          duration: const Duration(seconds: 5));
    } catch (error) {
      Get.snackbar('Error', 'Something went wrong. Please try again later.',
          backgroundColor: Colors.red, duration: const Duration(seconds: 5));
    } finally {
      isLoading.value = false;
    }
  }

  // Method to create a new club
  Future<void> createNewClub(ClubTeamsData clubData, String phoneNumber) async {
    try {
      isLoading(true);

      // Initiate STK push
      final stkSuccess = await initiateStkPush(phoneNumber, 10.0);

      if (!stkSuccess) {
        throw Exception('Failed to initiate STK push');
      }

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
      Get.snackbar('Error', 'Failed to create club: $e',
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

  Future<void> fetchAllEquipment() async {
    try {
      isLoading(true);
      equipments.clear();
      final QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('equipment').get();
      for (var doc in querySnapshot.docs) {
        final equipment =
            Equipment.fromJson(doc.data() as Map<String, dynamic>);
        equipment.equipmentID =
            doc.id; // Ensure equipmentID matches Firestore document ID
        equipments.add(equipment);
      }
      debugPrint('Equipments: ${equipments.length}');
    } catch (e) {
      debugPrint('Error fetching equipment: $e');
      Get.snackbar('Error', 'Failed to fetch equipment',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 5));
    } finally {
      isLoading(false);
    }
  }

  Future<void> createEquipment(Equipment equipment) async {
    try {
      isLoading(true);
      await fetchAllEquipment();

      // Normalize the equipment name to lowercase for comparison
      String normalizedEquipmentName = equipment.name?.toLowerCase() ?? '';

      // Check if the team has already been assigned the same type of equipment that hasn't been returned
      final existingEquipment = equipments.firstWhereOrNull(
        (e) =>
            e.teamId == equipment.teamId &&
            (e.name?.toLowerCase() ?? '') == normalizedEquipmentName &&
            !e.isReturned,
      );

      if (existingEquipment != null) {
        Get.snackbar(
          'Error',
          'This team has already been assigned this type of equipment and it has not been returned yet',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
        return;
      }

      final docRef = FirebaseFirestore.instance.collection('equipment').doc();
      equipment.equipmentID = docRef.id;
      await docRef.set(equipment.toJson());
      fetchAllEquipment();

      Get.snackbar(
        'Success',
        'Equipment added successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } catch (e) {
      debugPrint('Error adding equipment: $e');
      Get.snackbar(
        'Error',
        'Failed to add equipment',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateEquipment(Equipment equipment) async {
    try {
      isLoading(true);
      await FirebaseFirestore.instance
          .collection('equipment')
          .doc(equipment.equipmentID)
          .update(equipment.toJson());
      final index =
          equipments.indexWhere((e) => e.equipmentID == equipment.equipmentID);
      if (index != -1) {
        equipments[index] = equipment;
      }
      Get.snackbar('Success', 'Equipment updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 5));
    } catch (e) {
      print('Error updating equipment: $e');
      Get.snackbar('Error', 'Failed to update equipment',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 5));
    } finally {
      isLoading(false);
    }
  }

  Future<void> returnEquipment(Equipment equipment, String condition) async {
    try {
      isLoading(true);
      equipment.isReturned = true;
      equipment.returnDate = DateTime.now();
      equipment.condition = condition;
      await FirebaseFirestore.instance
          .collection('equipment')
          .doc(equipment.equipmentID)
          .update(equipment.toJson());

      final index =
          equipments.indexWhere((e) => e.equipmentID == equipment.equipmentID);
      if (index != -1) {
        equipments[index] = equipment;
      }

      Get.snackbar('Success', 'Equipment returned successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 5));
    } catch (e) {
      print('Error returning equipment: $e');
      Get.snackbar('Error', 'Something went wrong!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 5));
    } finally {
      isLoading(false);
    }
  }

// revert method so that we can only delete equipments that sa been returned.
  Future<void> deleteEquipment(Equipment equipment) async {
    try {
      isLoading(true);

      // Check if equipment has been returned
      if (!equipment.isReturned) {
        Get.snackbar(
          'Error',
          'Cannot delete equipment that has not been returned.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
        return;
      }

      await FirebaseFirestore.instance
          .collection('equipment')
          .doc(equipment.equipmentID)
          .delete();

      // Remove the equipment from the local list
      equipments.removeWhere((e) => e.equipmentID == equipment.equipmentID);

      Get.snackbar(
        'Success',
        'Equipment deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
      );
    } catch (e) {
      print('Error deleting equipment: $e');
      Get.snackbar(
        'Error',
        'Failed to delete equipment',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
      );
    } finally {
      isLoading(false);
    }
  }
}


  /*
  Future<void> createNewClub(ClubTeamsData clubData, String phoneNumber) async {
    try {
      isLoading(true);

     // initiate stk push here befre storing data to firebase, if stk push returns erro then throw error and stop execution
// hard code amount to 10


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
*/


/*
  Future<void> deleteEquipment(Equipment equipment) async {
    try {
      isLoading(true);
      await FirebaseFirestore.instance
          .collection('equipment')
          .doc(equipment.equipmentID)
          .delete();
      equipments.removeWhere((e) => e.equipmentID == equipment.equipmentID);
      Get.snackbar('Success', 'Equipment deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 5));
    } catch (e) {
      print('Error deleting equipment: $e');
      Get.snackbar('Error', 'Failed to delete equipment',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 5));
    } finally {
      isLoading(false);
    }
  } */
  /* Future<void> createEquipment(Equipment equipment) async {
    try {
      isLoading(true);
      await fetchAllEquipment();

      // Check if the team has already been assigned equipment
      final existingEquipment =
          equipments.firstWhereOrNull((e) => e.teamId == equipment.teamId);
      if (existingEquipment != null) {
        Get.snackbar('Error', 'This team has already been assigned equipment',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: Duration(seconds: 5));
        return;
      }

      final docRef = FirebaseFirestore.instance.collection('equipment').doc();
      equipment.equipmentID = docRef.id;
      await docRef.set(equipment.toJson());
      //equipments.add(equipment);
      fetchAllEquipment();
      Get.snackbar('Success', 'Equipment added successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 5));
    } catch (e) {
      print('Error adding equipment: $e');
      Get.snackbar('Error', 'Failed to add equipment',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: Duration(seconds: 5));
    } finally {
      isLoading(false);
    }
  } */


  /*
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

*/


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