import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/models/club_teams_model.dart';
import 'controller/clubs_controller.dart'; // Import your ClubController

class TeamsDataScreen extends StatelessWidget {
  final ClubController clubController = Get.find();

  TeamsDataScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Clubs',
          style: GoogleFonts.nunito(),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {}, icon: Icon(Icons.notifications_active_outlined))
        ],
      ),
      body: Obx(
        () => clubController.isLoading.value
            ? Center(
                child: CircularProgressIndicator(),
              )
            : clubController.clubsTeamsData.isEmpty
                ? Center(
                    child: Text(
                      'No data available',
                      style: GoogleFonts.nunito(),
                    ),
                  )
                : ListView.builder(
                    itemCount: clubController.clubsTeamsData.length,
                    itemBuilder: (context, index) {
                      final club = clubController.clubsTeamsData[index];
                      return _buildClubCard(context, club);
                    },
                  ),
      ),
    );
  }

  Widget _buildClubCard(BuildContext context, ClubTeamsData club) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (club.logoUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      club.logoUrl!,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        club.name!,
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Sport: ${club.sport}',
                        style: GoogleFonts.nunito(),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'County: ${club.county}',
                        style: GoogleFonts.nunito(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              'Junior Team: ${club.isJuniorTeam! ? 'Yes' : 'No'}',
              style: GoogleFonts.nunito(),
            ),
            SizedBox(height: 4),
            Text(
              'Contact Email: ${club.contactEmail}',
              style: GoogleFonts.nunito(),
            ),
            SizedBox(height: 4),
            Text(
              'Postal Zip: ${club.postalZip}',
              style: GoogleFonts.nunito(),
            ),
          ],
        ),
      ),
    );
  }
}
