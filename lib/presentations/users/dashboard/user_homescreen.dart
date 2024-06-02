import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/widgets/user_drawer.dart';
import '../../../data/models/fixtures_model.dart';
import '../../../data/models/articles_model.dart';
import '../../../data/models/club_teams_model.dart';
import 'package:sportsapp/presentations/users/clubs/controller/clubs_controller.dart';
import 'package:sportsapp/presentations/login_screen/controller/login_controller.dart';

class UserDashboardScreen extends StatelessWidget {
  final LoginController loginController;
  final ClubController clubController = Get.put(ClubController());

  UserDashboardScreen({required this.loginController, Key? key})
      : super(key: key);

  List<Article> dummyArticles = [
    Article(
      title: 'Fundraising Event',
      description: 'Details about the upcoming fundraising event.',
      date: 'May 30, 2024',
    ),
    Article(
      title: 'New Training Schedule',
      description: 'Check out the updated training schedule for next week.',
      date: 'June 5, 2024',
    ),
    // Add more dummy articles as needed
  ];

  // Inside UserDashboardScreen build method
  Widget userInformationCard() {
    final firstName = GetStorage().read('first_name') ?? '';
    final lastName = GetStorage().read('last_name') ?? '';
    final imageUrl = GetStorage().read('image_url') ??
        ''; // Replace 'image_url' with your key

    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey.shade200,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(imageUrl),
                radius: 30.0,
              ),
              SizedBox(width: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, $firstName $lastName!',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    'View your sports details and updates here.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

// Inside UserDashboardScreen build method
// Inside UserDashboardScreen class

// Inside selectCategorySection method
// Inside UserDashboardScreen class

// Inside selectCategorySection method
Widget selectCategorySection() {
  // Logic to fetch upcoming games for each club
  List<String> sportsTypes = clubController.sportsTypes;
  return Container(
    margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Sport Category',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, fontSize: 18.0),
        ),
        SizedBox(height: 16.0),
        SizedBox(
          width: double.infinity,
          child: Center(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: sportsTypes.length,
              itemBuilder: (context, index) {
                String sport = sportsTypes[index];
                // Fetch fixtures for this sport
                List<Fixture> fixtures = clubController.fixtures
                    .where((fixture) => fixture.sport == sport)
                    .toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      sport,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                    SizedBox(height: 8.0),
                    // Replace this with dropdown widget to select fixtures
                    DropdownButton<Fixture>(
                      items: fixtures
                          .map<DropdownMenuItem<Fixture>>((Fixture fixture) {
                        final team1 = clubController.clubsTeamsData.firstWhere(
                          (team) => team.id == fixture.team1Id,
                          orElse: () => ClubTeamsData(name: ''),
                        );
                        final team2 = clubController.clubsTeamsData.firstWhere(
                          (team) => team.id == fixture.team2Id,
                          orElse: () => ClubTeamsData(name: ''),
                        );

                        return DropdownMenuItem<Fixture>(
                          value: fixture,
                          child: Text(
                            '${team1.name ?? 'Team 1'} vs ${team2.name ?? 'Team 2'}',
                          ),
                        );
                      }).toList(),
                      onChanged: (selectedFixture) {
                        // Handle selected fixture
                      },
                      hint: Text('Select Fixture'),
                    ),
                    SizedBox(height: 16.0),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    ),
  );
}





  // Widget selectCategorySection() {
  //   // Logic to fetch upcoming games for each club
  //   // if sport == cluBcontroller.fixtures.sport => place the fixture in same sport category
  //   List<String> sport = clubController.sportsTypes;
  //   return Container(
  //     margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           'Select Sport Category',
  //           style: GoogleFonts.poppins(
  //               fontWeight: FontWeight.bold, fontSize: 18.0),
  //         ),
  //         SizedBox(height: 16.0),
  //         SizedBox(
  //           width: double.infinity,
  //           child: Center(
  //             child: ListView.builder(
  //               shrinkWrap: true,
  //               itemCount: sport.length,
  //               itemBuilder: (context, index) {
  //                 String club = sport[index];
  //                 // Replace this with actual dropdown widget showing upcoming games
  //                 return Column(
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: [
  //                     Text(
  //                       club,
  //                       style: TextStyle(
  //                           fontWeight: FontWeight.bold, fontSize: 16.0),
  //                     ),
  //                     SizedBox(height: 8.0),
  //                     // Replace this with dropdown widget
  //                     DropdownButton<String>(
  //                       items: [],
  //                       onChanged: (value) {},
  //                       hint: Text('Upcoming Games'),
  //                     ),
  //                     SizedBox(height: 16.0),
  //                   ],
  //                 );
  //               },
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

// Inside UserDashboardScreen build method
  Widget whatsNewSection() {
    // Logic to fetch articles
    List<Article> articles = dummyArticles;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "What's New?",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
          ),
          SizedBox(height: 16.0),
          ListView.builder(
            shrinkWrap: true,
            itemCount: articles.length,
            itemBuilder: (context, index) {
              Article article = articles[index];
              return Card(
                elevation: 2.0,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: Icon(Icons.sports_handball),
                  title: Text(article.title),
                  subtitle: Text(article.description),
                  onTap: () {
                    // Handle article tap
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(
        context: context,
      ), // Pass imageUrl to the CustomDrawer
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open drawer on icon tap
              },
              icon: const Icon(Icons.menu_rounded),
            );
          },
        ),
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Sports Center',
          style: GoogleFonts.nunito(fontSize: 17),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_active_outlined),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            userInformationCard(),
            selectCategorySection(),
            whatsNewSection(),
          ],
        ),
      ),
    );
  }
}
