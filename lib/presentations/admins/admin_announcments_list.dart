import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'news_articles_screen.dart';
import 'package:flutter/material.dart';
import 'controller/admin_controller.dart';
import '../../data/models/events_model.dart';
import 'package:get_storage/get_storage.dart';
import '../../data/models/fixtures_model.dart';
import 'package:google_fonts/google_fonts.dart';
import '../users/clubs/controller/clubs_controller.dart';

class AnnouncementsScreen extends StatelessWidget {
  final AdminController controller = Get.find<AdminController>();
  final ClubController clubController = Get.find<ClubController>();

  AnnouncementsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Announcements', style: GoogleFonts.nunito()),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Matches'),
              Tab(text: 'Promotions'),
              Tab(text: 'Campaigns'),
            ],
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Processing...',
                      style: GoogleFonts.nunito(fontSize: 18)),
                ],
              ),
            );
          }
          return TabBarView(
            children: [
              AnnouncementList(
                announcements: controller.announcements
                    .where((a) => a.type == 'match')
                    .toList()
                    .obs,
                type: 'match',
              ),
              AnnouncementList(
                announcements: controller.announcements
                    .where((a) => a.type == 'promotion')
                    .toList()
                    .obs,
                type: 'promotion',
              ),
              AnnouncementList(
                announcements: controller.announcements
                    .where((a) => a.type == 'campaign')
                    .toList()
                    .obs,
                type: 'campaign',
              ),
            ],
          );
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Get.to(() => CreateEventsScreen()),
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class AnnouncementCard extends StatelessWidget {
  final Announcement announcement;
  final ClubController clubController = Get.find<ClubController>();
  final AdminController adminController = Get.find<AdminController>();
  final storage = GetStorage();

  AnnouncementCard({Key? key, required this.announcement}) : super(key: key);

  String formatDate(DateTime date) {
    return DateFormat('MMM d, y HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final userRole = storage.read('user_role') ?? '';
    final isAdmin = userRole == 'admin';

    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    announcement.title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                if (isAdmin)
                  PopupMenuButton<String>(
                    onSelected: (String result) {
                      if (result == 'update') {
                        // TODO: Implement update functionality
                        Get.snackbar('Update', 'Update functionality not implemented yet');
                      } else if (result == 'delete') {
                        adminController.deleteAnnouncement(announcement.id);
                      }
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'update',
                        child: Text('Update'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                  ),
              ],
            ),
            SizedBox(height: 8),
            Text(announcement.description ?? 'No description available'),
            SizedBox(height: 8),
            Text('From: ${formatDate(announcement.startDate)}'),
            Text('To: ${formatDate(announcement.endDate)}'),
            SizedBox(height: 8),
            Text('Type: ${announcement.type.capitalize}'),
            if (announcement.type == 'match' && announcement.fixtureId != null)
              FutureBuilder<String>(
                future: _getMatchDetails(announcement.fixtureId!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  return Text(snapshot.data ?? 'Match details not available');
                },
              ),
            if (announcement.type == 'promotion' && announcement.offerDetails != null)
              Text('Offer: ${announcement.offerDetails}'),
            if (announcement.type == 'campaign' && announcement.campaignGoals != null)
              Text('Goals: ${announcement.campaignGoals}'),
            if (announcement.targetAudience != null)
              Text('Target Audience: ${announcement.targetAudience}'),
            if (announcement.channels != null && announcement.channels!.isNotEmpty)
              Text('Channels: ${announcement.channels!.join(', ')}'),
            SizedBox(height: 8),
            Text('Created by: ${announcement.createdBy}'),
          ],
        ),
      ),
    );
  }
  Future<String> _getMatchDetails(String fixtureId) async {
    Fixture? fixture = clubController.fixtures
        .firstWhereOrNull((f) => f.fixtureId == fixtureId);
    if (fixture == null) return 'Match not found';

    String team1Name = clubController.getTeamName(fixture.team1Id);
    String team2Name = clubController.getTeamName(fixture.team2Id);

    return '$team1Name vs $team2Name on ${formatDate(fixture.matchDateTime)}';
  }
}





class AnnouncementList extends StatelessWidget {
  final RxList<Announcement> announcements;
  final String type;

  const AnnouncementList(
      {Key? key, required this.announcements, required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (announcements.isEmpty) {
        return Center(child: Text('No ${type} announcements'));
      }
      return ListView.builder(
        itemCount: announcements.length,
        itemBuilder: (context, index) {
          return AnnouncementCard(announcement: announcements[index]);
        },
      );
    });
  }
}


/*
// class AnnouncementsScreen extends StatelessWidget {
//   final AdminController controller = Get.find<AdminController>();
//   final ClubController clubController = Get.find<ClubController>();

//   AnnouncementsScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Announcements', style: GoogleFonts.nunito()),
//           bottom: TabBar(
//             tabs: [
//               Tab(text: 'Matches'),
//               Tab(text: 'Promotions'),
//               Tab(text: 'Campaigns'),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             AnnouncementList(
//                 announcements: controller.announcements
//                     .where((a) => a.type == 'match')
//                     .toList()
//                     .obs,
//                 type: 'match'),
//             AnnouncementList(
//                 announcements: controller.announcements
//                     .where((a) => a.type == 'promotion')
//                     .toList()
//                     .obs,
//                 type: 'promotion'),
//             AnnouncementList(
//                 announcements: controller.announcements
//                     .where((a) => a.type == 'campaign')
//                     .toList()
//                     .obs,
//                 type: 'campaign'),
//           ],
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () => Get.to(() => CreateEventsSCreen()),
//           child: Icon(Icons.add),
//         ),
//       ),
//     );
//   }
// }



// class AnnouncementCard extends StatelessWidget {
//   final Announcement announcement;
//   final ClubController clubController = Get.find<ClubController>();

//   AnnouncementCard({Key? key, required this.announcement}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.all(8),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(announcement.title,
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             SizedBox(height: 8),
//             Text(announcement.description),
//             SizedBox(height: 8),
//             Text('From: ${announcement.startDate.toLocal()}'),
//             Text('To: ${announcement.endDate.toLocal()}'),
//             if (announcement.type == 'match' && announcement.fixtureId != null)
//               FutureBuilder<String>(
//                 future: _getMatchDetails(announcement.fixtureId!),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return CircularProgressIndicator();
//                   }
//                   return Text(snapshot.data ?? 'Match details not available');
//                 },
//               ),
//             if (announcement.type == 'promotion')
//               Text('Offer: ${announcement.offerDetails ?? 'No offer details'}'),
//             if (announcement.type == 'campaign')
//               Text(
//                   'Goals: ${announcement.campaignGoals ?? 'No campaign goals'}'),
//             if (announcement.targetAudience != null)
//               Text('Target Audience: ${announcement.targetAudience}'),
//             if (announcement.channels != null &&
//                 announcement.channels!.isNotEmpty)
//               Text('Channels: ${announcement.channels!.join(', ')}'),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<String> _getMatchDetails(String fixtureId) async {
//     Fixture? fixture = clubController.fixtures
//         .firstWhereOrNull((f) => f.fixtureId == fixtureId);
//     if (fixture == null) return 'Match not found';

//     String team1Name = clubController.getTeamName(fixture.team1Id);
//     String team2Name = clubController.getTeamName(fixture.team2Id);

//     return '$team1Name vs $team2Name on ${fixture.matchDateTime.toLocal()}';
//   }
// }
*/
