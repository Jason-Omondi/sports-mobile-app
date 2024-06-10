import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/widgets/user_drawer.dart';
import '../../../data/models/fixtures_model.dart';
import '../../../data/models/articles_model.dart';
import '../../../data/models/club_teams_model.dart';
import 'package:sportsapp/presentations/users/clubs/controller/clubs_controller.dart';
import 'package:sportsapp/presentations/login_screen/controller/login_controller.dart';


class UserDashboardScreen extends StatefulWidget {
  final LoginController loginController;

  UserDashboardScreen({required this.loginController, Key? key})
      : super(key: key);

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  final ClubController clubController = Get.put(ClubController());

  @override
  void initState() {
    super.initState();
    clubController.fetchAllFixtures();
  }

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
  ];

  Widget userInformationCard() {
    final firstName = GetStorage().read('first_name') ?? '';
    final lastName = GetStorage().read('last_name') ?? '';
    final imageUrl = GetStorage().read('image_url') ?? '';

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
          ConstrainedBox(
            constraints: BoxConstraints(minWidth: double.infinity),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(imageUrl),
                  radius: 30.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, $firstName $lastName!',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        'View your sports details and updates here.',
                        style: GoogleFonts.nunito(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget selectCategorySection() {
    return Obx(() {
      if (clubController.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      } else {
        List<String> sportsTypes = clubController.sportsTypes;
        return Container(
          margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Sport Category',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20.0),
              ListView.builder(
                shrinkWrap: true,
                itemCount: sportsTypes.length,
                itemBuilder: (context, index) {
                  String sport = sportsTypes[index];
                  List<Fixture> fixtures = clubController.fixtures
                      .where((fixture) => fixture.sport == sport)
                      .toList();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        sport,
                        style: GoogleFonts.nunito(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 12.0),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: DropdownButton<Fixture>(
                          items: fixtures.map((Fixture fixture) {
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
                                style: GoogleFonts.nunito(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w300),
                              ),
                            );
                          }).toList(),
                          onChanged: (selectedFixture) {
                            // Handle selected fixture
                          },
                          hint: Text(
                            'Select Fixture',
                            style: GoogleFonts.nunito(color: Colors.grey),
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      }
    });
  }

  Widget whatsNewSection() {
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
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth <= 600;

    return Scaffold(
      drawer: CustomDrawer(
        context: context,
      ),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu_rounded),
            );
          },
        ),
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Sports Center',
          style: GoogleFonts.nunito(fontSize: isSmallScreen ? 14 : 17),
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
            SizedBox(height: 20.0),
            selectCategorySection(),
            SizedBox(height: 20.0),
            whatsNewSection(),
          ],
        ),
      ),
    );
  }
}


/*
class UserDashboardScreen extends StatefulWidget {
  final LoginController loginController;

  UserDashboardScreen({required this.loginController, Key? key})
      : super(key: key);

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  final ClubController clubController = Get.put(ClubController());

  @override
  void initState() {
    super.initState();
    clubController.fetchAllFixtures();
  }

  //  @override
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

  Widget userInformationCard() {
    final firstName = GetStorage().read('first_name') ?? '';
    final lastName = GetStorage().read('last_name') ?? '';
    final imageUrl = GetStorage().read('image_url') ?? '';

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
          ConstrainedBox(
            constraints: BoxConstraints(minWidth: double.infinity),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(imageUrl),
                  radius: 30.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, $firstName $lastName!',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        'View your sports details and updates here.',
                        style: GoogleFonts.nunito(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget selectCategorySection() {
    List<String> sportsTypes = clubController.sportsTypes;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Sport Category',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 20.0),
          ListView.builder(
            shrinkWrap: true,
            itemCount: sportsTypes.length,
            itemBuilder: (context, index) {
              String sport = sportsTypes[index];
              List<Fixture> fixtures = clubController.fixtures
                  .where((fixture) => fixture.sport == sport)
                  .toList();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    sport,
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: DropdownButton<Fixture>(
                      items: fixtures.map((Fixture fixture) {
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
                            style: GoogleFonts.nunito(
                                color: Colors.black87,
                                fontWeight: FontWeight.w300),
                          ),
                        );
                      }).toList(),
                      onChanged: (selectedFixture) {
                        // Handle selected fixture
                      },
                      hint: Text(
                        'Select Fixture',
                        style: GoogleFonts.nunito(color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget whatsNewSection() {
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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final bool isLargeScreen = screenWidth > 1200;
    final bool isMediumScreen = screenWidth > 600 && screenWidth <= 1200;
    final bool isSmallScreen = screenWidth <= 600;

    return Scaffold(
      drawer: CustomDrawer(
        context: context,
      ),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu_rounded),
            );
          },
        ),
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Sports Center',
          style: GoogleFonts.nunito(fontSize: isSmallScreen ? 14 : 17),
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
            SizedBox(height: 20.0),
            selectCategorySection(),
            SizedBox(height: 20.0),
            whatsNewSection(),
          ],
        ),
      ),
    );
  }
}
*/