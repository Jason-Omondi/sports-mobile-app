import 'club_fixtures.dart';
import 'package:get/get.dart';
import 'all_teams_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'controller/clubs_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/widgets/user_drawer.dart';
import '../../login_screen/controller/login_controller.dart';
import 'package:sportsapp/presentations/users/clubs/single_team.dart';

//create a new club with members

class ClubCategories extends StatelessWidget {
  final LoginController loginController;
  ClubCategories({required this.loginController, Key? key}) : super(key: key);
  final ClubController controller = Get.put(ClubController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Sports App",
          style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: CustomDrawer(
        context: context,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.blue,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Manage Clubs!",
                      style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Lottie.asset(
                      'assets/animations/clubanimation.json',
                      height: 200,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
              ),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  _buildCategoryCard(
                    icon: Icons.sports_soccer,
                    title: 'Create a Club',
                    onTap: () => Get.to(() => CreateSingleTeam()),
                  ),
                  _buildCategoryCard(
                    icon: Icons.sports_baseball,
                    title: 'View All Teams',
                    onTap: () => Get.to(() => TeamsDataScreen()),
                  ),
                  _buildCategoryCard(
                    icon: Icons.sports_basketball,
                    title: 'Manage Fixtures',
                    onTap: () => Get.to(() => FixturesScreen()),
                  ),
                  // Add more categories as needed
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3))
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 60, color: Colors.blue),
            SizedBox(height: 10),
            Text(
              title,
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}



/*
class ClubCategories extends StatelessWidget {
  final LoginController loginController;
  ClubCategories({required this.loginController, Key? key}) : super(key: key);

  final ClubController controller = Get.find();

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
                          Get.to(() => TeamsDataScreen());
                          break;
                        case 2:
                          // Navigate to create league screen
                          Get.to(() => FixturesScreen());
                          break;
                        // case 3:
                        //   // Navigate to create fixtures screen

                        //   break;
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
      // case 3:
      //   return Icons.category_outlined;
      // case 4:
      //   return Icons.category;
      default:
        return Icons.category;
    }
  }

  String _getSubtitle(int index) {
    switch (index) {
      case 0:
        return 'Create a Club';
      // case 1:
      //   return 'Club (Multiple Teams)';
      case 1:
        return 'All Teams';
      case 2:
        return 'Club Fixtures';
      // case 4:
      //   return 'Other';
      default:
        return 'Other';
    }
  }
}

*/
