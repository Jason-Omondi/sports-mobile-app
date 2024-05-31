import 'club_fixtures.dart';
import 'package:get/get.dart';
import 'all_teams_screen.dart';
import 'package:flutter/material.dart';
import 'controller/clubs_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../login_screen/controller/login_controller.dart';
import 'package:sportsapp/presentations/users/clubs/single_team.dart';

//create a new club with members

class CreateNewClub extends StatelessWidget {
  final LoginController loginController;
  CreateNewClub({required this.loginController, Key? key}) : super(key: key);

  final ClubController controller = Get.put(ClubController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Club Category",
          style: GoogleFonts.nunito(fontSize: 17),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Select the appropriate category: ",
                style: GoogleFonts.poppins(fontSize: 17, color: Colors.black),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Expanded(
              // Wrap GridView.builder with Expanded
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 1.0, // Adjust as needed
                ),
                itemCount: 5, // Number of options
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      // Navigate to respective screen based on index
                      switch (index) {
                        case 0:
                          // Navigate to create single team screen
                          Get.to(() => CreateSingleTeam());
                          break;
                        case 1:
                          // Navigate to create multiple teams screen
                          break;
                        case 2:
                          // Navigate to create league screen
                          Get.to(() => TeamsDataScreen());
                          break;
                        case 3:
                          // Navigate to create fixtures screen
                          Get.to(() => FixturesScreen());
                          break;
                        // case 4:
                        //   // Navigate to create other screen
                        //   break;
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _getIcon(index), // Get icon based on index
                            size: 50,
                            color: Colors.blue,
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            _getSubtitle(index), // Get subtitle based on index
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(int index) {
    switch (index) {
      case 0:
        return Icons.sports_soccer;
      case 1:
        return Icons.sports_baseball;
      case 2:
        return Icons.sports_basketball;
      case 3:
        return Icons.category_outlined;
      // case 4:
      //   return Icons.category;
      default:
        return Icons.category;
    }
  }

  String _getSubtitle(int index) {
    switch (index) {
      case 0:
        return 'Single Club (Team)';
      case 1:
        return 'Club (Multiple Teams)';
      case 2:
        return 'All Teams';
      case 3:
        return 'Club Fixtures';
      // case 4:
      //   return 'Other';
      default:
        return 'Other';
    }
  }
}
