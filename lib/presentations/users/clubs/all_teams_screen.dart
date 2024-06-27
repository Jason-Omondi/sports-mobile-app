import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../admins/admin_equipment.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/models/club_teams_model.dart';
import 'controller/clubs_controller.dart'; // Import your ClubController


class TeamsDataScreen extends StatelessWidget {
  final ClubController clubController = Get.find();

  TeamsDataScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Clubs by Sport',
            style: GoogleFonts.nunito(),
          ),
          centerTitle: true,
          elevation: 0,
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Football'),
              Tab(text: 'Basketball'),
              Tab(text: 'Rugby'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Obx(
              () => clubController.isLoading.value
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : clubController.clubsTeamsData.isEmpty
                      ? Center(
                          child: Text(
                            'No football clubs data available',
                            style: GoogleFonts.nunito(),
                          ),
                        )
                      : ListView.builder(
                          itemCount: clubController.clubsTeamsData.length,
                          itemBuilder: (context, index) {
                            final club = clubController.clubsTeamsData[index];
                            if (club.sport == 'Football') {
                              return _buildClubCard(context, club);
                            } else {
                              return SizedBox.shrink();
                            }
                          },
                        ),
            ),
            Obx(
              () => clubController.isLoading.value
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : clubController.clubsTeamsData.isEmpty
                      ? Center(
                          child: Text(
                            'No basketball clubs data available',
                            style: GoogleFonts.nunito(),
                          ),
                        )
                      : ListView.builder(
                          itemCount: clubController.clubsTeamsData.length,
                          itemBuilder: (context, index) {
                            final club = clubController.clubsTeamsData[index];
                            if (club.sport == 'Basketball') {
                              return _buildClubCard(context, club);
                            } else {
                              return SizedBox.shrink();
                            }
                          },
                        ),
            ),
            Obx(
              () => clubController.isLoading.value
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : clubController.clubsTeamsData.isEmpty
                      ? Center(
                          child: Text(
                            'No volleyball clubs data available',
                            style: GoogleFonts.nunito(),
                          ),
                        )
                      : ListView.builder(
                          itemCount: clubController.clubsTeamsData.length,
                          itemBuilder: (context, index) {
                            final club = clubController.clubsTeamsData[index];
                            if (club.sport == 'Volleyball') {
                              return _buildClubCard(context, club);
                            } else {
                              return SizedBox.shrink();
                            }
                          },
                        ),
            ),
          ],
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
                        'County: ${club.county}',
                        style: GoogleFonts.nunito(),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'Equipment') {
                      Get.to(() => EquipmentScreen(teamId: club.id!,));
                    } else if (value == 'Delete') {
                      _confirmDelete(context, club);
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return {'Equipment', 'Delete'}.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
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

  void _confirmDelete(BuildContext context, ClubTeamsData club) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Club'),
        content: Text('Are you sure you want to delete ${club.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              clubController.deleteClub(club.id!);
              Navigator.of(context).pop();
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}




// class TeamsDataScreen extends StatelessWidget {
//   final ClubController clubController = Get.find();

//   TeamsDataScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'All Clubs',
//           style: GoogleFonts.nunito(),
//         ),
//         centerTitle: true,
//         elevation: 0,
//         actions: [
//           IconButton(
//               onPressed: () {}, icon: Icon(Icons.notifications_active_outlined))
//         ],
//       ),
//       body: Obx(
//         () => clubController.isLoading.value
//             ? Center(
//                 child: CircularProgressIndicator(),
//               )
//             : clubController.clubsTeamsData.isEmpty
//                 ? Center(
//                     child: Text(
//                       'No data available',
//                       style: GoogleFonts.nunito(),
//                     ),
//                   )
//                 : ListView.builder(
//                     itemCount: clubController.clubsTeamsData.length,
//                     itemBuilder: (context, index) {
//                       final club = clubController.clubsTeamsData[index];
//                       return _buildClubCard(context, club);
//                     },
//                   ),
//       ),
//     );
//   }

//   Widget _buildClubCard(BuildContext context, ClubTeamsData club) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             spreadRadius: 2,
//             blurRadius: 10,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 if (club.logoUrl != null)
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child: Image.network(
//                       club.logoUrl!,
//                       width: 80,
//                       height: 80,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         club.name!,
//                         style: GoogleFonts.nunito(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       SizedBox(height: 8),
//                       Text(
//                         'Sport: ${club.sport}',
//                         style: GoogleFonts.nunito(),
//                       ),
//                       SizedBox(height: 4),
//                       Text(
//                         'County: ${club.county}',
//                         style: GoogleFonts.nunito(),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 12),
//             Text(
//               'Junior Team: ${club.isJuniorTeam! ? 'Yes' : 'No'}',
//               style: GoogleFonts.nunito(),
//             ),
//             SizedBox(height: 4),
//             Text(
//               'Contact Email: ${club.contactEmail}',
//               style: GoogleFonts.nunito(),
//             ),
//             SizedBox(height: 4),
//             Text(
//               'Postal Zip: ${club.postalZip}',
//               style: GoogleFonts.nunito(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
