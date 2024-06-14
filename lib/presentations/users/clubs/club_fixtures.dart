import 'dart:core';
import 'package:get/get.dart';
import 'manage_fixtures.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'controller/clubs_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/models/fixtures_model.dart';
import '../../../data/models/club_teams_model.dart';

class FixturesScreen extends StatefulWidget {
  FixturesScreen({Key? key});

  @override
  State<FixturesScreen> createState() => _FixturesScreenState();
}

class _FixturesScreenState extends State<FixturesScreen> {
  final ClubController clubController = Get.find();

  @override
  void initState() {
    super.initState();
    clubController.fetchAllFixtures();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Fixtures',
          style: GoogleFonts.nunito(),
        ),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_active_outlined),
          )
        ],
        centerTitle: true,
      ),
      body: clubController.isLoading.value
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text(
                    'Processing request...',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Create Fixture',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      _buildFixtureForm(),
                      SizedBox(height: 20),
                      Divider(
                        thickness: 5,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Existing Fixtures',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      Expanded(child: _buildFixtureList()),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildFixtureForm() {
    //final clubController = Get.find<ClubController>();
    String? _pickedDate =
        //DateTime.now().toString();
        DateFormat("dd/MM/yyyy").format(clubController.matchDateController);

    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DropdownButtonFormField<String>(
            value: clubController.selectedTeam1.value.isNotEmpty
                ? clubController.selectedTeam1.value
                : null, // Set initial value to null if not selected
            items: clubController.clubsTeamsData.map((team) {
              return DropdownMenuItem<String>(
                value: team.id!,
                child: Text(team.name!),
              );
            }).toList(),
            onChanged: (value) {
              clubController.selectedTeam1.value = value!;
            },
            decoration: InputDecoration(
              labelText: 'Select Team 1',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: clubController.selectedTeam2.value.isNotEmpty
                ? clubController.selectedTeam2.value
                : null, // Set initial value to null if not selected
            items: clubController.clubsTeamsData.map((team) {
              return DropdownMenuItem<String>(
                value: team.id!,
                child: Text(team.name!),
              );
            }).toList(),
            onChanged: (value) {
              clubController.selectedTeam2.value = value!;
            },
            decoration: InputDecoration(
              labelText: 'Select Team 2',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 10),
          InkWell(
            onTap: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: Get.context!,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(DateTime.now().year + 1),
              );
              if (pickedDate != null) {
                clubController.matchDateController = pickedDate;
                _pickedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                //DateFormat('dd/MM/yyyy')
                //  .format(pickedDate); // Update the controller value
              }
            },
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.date_range),
                  SizedBox(width: 10),
                  Text(
                    'Match Date',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  Spacer(),
                  Text(
                    _pickedDate,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: TextFormField(
              controller: clubController.locationController,
              focusNode: clubController.locationFocusNode,
              decoration: InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: clubController.locationFocusNode.hasFocus
                        ? Colors.blue
                        : Colors.grey.shade400,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _submitFixtureForm();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.teal),
              foregroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              padding: MaterialStateProperty.all(
                EdgeInsets.symmetric(vertical: 16, horizontal: 40),
              ),
            ),
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _submitFixtureForm() {
    //final clubController = Get.find<ClubController>();

    // Check if both teams are selected and they are different
    if (clubController.selectedTeam1.isNotEmpty &&
        clubController.selectedTeam2.isNotEmpty &&
        clubController.selectedTeam1.value !=
            clubController.selectedTeam2.value) {
      // Get the sport from either team (assuming they belong to the same sport)
      final sport = clubController.clubsTeamsData
          .firstWhere(
            (team) => team.id == clubController.selectedTeam1.value,
            orElse: () => ClubTeamsData(sport: ''),
          )
          .sport;

      // Both teams are selected and they are different, proceed to submit the fixture
      clubController.createFixture(
        team1Id: clubController.selectedTeam1.value,
        team2Id: clubController.selectedTeam2.value,
        sport: sport!, // Set the sport dynamically
        matchDateTime: clubController
            .matchDateController!, // Replace with actual match date
        location: clubController.locationController.text,
      );
    } else {
      // Show error message indicating that the selected teams are not valid
      Get.snackbar(
        'Error',
        'Please select two different teams',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

// Existing code...
  Widget _buildFixtureList() {
    return Obx(
      () => clubController.isLoading.value
          ? Center(child: CircularProgressIndicator())
          : clubController.fixtures.isEmpty
              ? Center(
                  child: Text(
                  'No fixtures available',
                  style: GoogleFonts.nunito(),
                ))
              : ListView.builder(
                  itemCount: clubController.fixtures.length,
                  itemBuilder: (context, index) {
                    final fixture = clubController.fixtures[index];
                    return GestureDetector(
                      onTap: () {
                        _navigateToManageFixture(fixture.fixtureId);
                      },
                      child: _buildFixtureCard(fixture),
                    );
                  },
                ),
    );
  }

  void _navigateToManageFixture(String fixtureId) {
    Get.to(() => ManageFixtureScreen(fixtureId: fixtureId));
  }

// Existing code...
  Widget _buildFixtureCard(Fixture fixture) {
    final team1 = clubController.clubsTeamsData.firstWhere(
      (team) => team.id == fixture.team1Id,
      orElse: () => ClubTeamsData(logoUrl: ''),
    );
    final team2 = clubController.clubsTeamsData.firstWhere(
      (team) => team.id == fixture.team2Id,
      orElse: () => ClubTeamsData(logoUrl: ''),
    );

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    team1.logoUrl ?? '',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.error),
                  ),
                ),
                Text(
                  'VS',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    team2.logoUrl ?? '',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.error),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Sport: ${fixture.sport}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Match Date: ${DateFormat.yMMMd().format(fixture.matchDateTime)}',
            ),
            SizedBox(height: 8),
            Text(
              'Location: ${fixture.location}',
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _showDeleteConfirmationDialog(fixture);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(Fixture fixture) {
    showDialog(
      context: Get.overlayContext!,
      builder: (context) => AlertDialog(
        title: Text('Delete Fixture'),
        content: Text('Are you sure you want to delete this fixture?'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              clubController.deleteFixture(fixture.fixtureId);
              Get.back();
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
