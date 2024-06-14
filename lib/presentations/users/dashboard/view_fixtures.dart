import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../../../data/models/fixtures_model.dart';
import '../clubs/controller/clubs_controller.dart';
import '../../../data/models/club_teams_model.dart';

class ViewFixtureScreen extends StatelessWidget {
  final ClubController clubController = Get.find();
  final String fixtureId;

  ViewFixtureScreen({Key? key, required this.fixtureId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Fixture'),
        centerTitle: true,
      ),
      body: Obx(() {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: 20),
                _buildFixtureDetails(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          Icons.sports_cricket,
          size: 30,
        ),
        SizedBox(width: 10),
        Text(
          'Fixture Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFixtureDetails() {
    Fixture? fixture = clubController.fixtures.firstWhereOrNull(
      (fixture) => fixture.fixtureId == fixtureId,
    );

    if (fixture == null) {
      return Center(child: Text('Fixture not found.'));
    }

    if (clubController.isLoading.value) {
      return _buildLoadingIndicator();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTeamDetailsSection(fixture),
        SizedBox(height: 20),
        _buildSectionTitle('Match Details'),
        SizedBox(height: 10),
        _buildSportSection(fixture),
        SizedBox(height: 10),
        _buildDateSection(fixture),
        SizedBox(height: 10),
        _buildResultSection(fixture),
        SizedBox(height: 10),
        _buildLocationSection(fixture),
      ],
    );
  }

  Widget _buildTeamDetailsSection(Fixture fixture) {
    ClubTeamsData? team1 = clubController.clubsTeamsData
        .firstWhereOrNull((team) => team.id == fixture.team1Id);
    ClubTeamsData? team2 = clubController.clubsTeamsData
        .firstWhereOrNull((team) => team.id == fixture.team2Id);

    if (team1 == null || team2 == null) {
      return Center(child: Text('One or both teams not found.'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTeamDetailCard('Team 1', team1),
        SizedBox(height: 20),
        _buildTeamDetailCard('Team 2', team2),
      ],
    );
  }

  Widget _buildTeamDetailCard(String label, ClubTeamsData team) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: team.logoUrl != null && team.logoUrl!.isNotEmpty
            ? CircleAvatar(
                backgroundImage: NetworkImage(team.logoUrl!),
              )
            : Icon(Icons.sports),
        title: Text(
          team.name!,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Coach: ${team.contactEmail ?? 'N/A'}',
            ),
            Text(
              'Sport: ${team.sport ?? 'N/A'}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    );
  }

  Widget _buildSportSection(Fixture fixture) {
    return ListTile(
      leading: Icon(Icons.sports_cricket),
      title: Text(
        'Sport',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(fixture.sport),
    );
  }

  Widget _buildDateSection(Fixture fixture) {
    return ListTile(
      leading: Icon(Icons.date_range),
      title: Text(
        'Match Date',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        DateFormat('dd/MM/yyyy').format(fixture.matchDateTime),
      ),
    );
  }

  Widget _buildResultSection(Fixture fixture) {
    return ListTile(
      leading: Icon(Icons.emoji_events_outlined),
      title: Text(
        'Match Result',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(fixture.result ?? 'No result available'),
    );
  }

  Widget _buildLocationSection(Fixture fixture) {
    return ListTile(
      leading: Icon(Icons.location_on_outlined),
      title: Text(
        'Location',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(fixture.location),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Processing request...",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 15,
          ),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}


/*
class ViewFixtureScreen extends StatelessWidget {
  final ClubController clubController = Get.find();
  final String fixtureId;

  ViewFixtureScreen({Key? key, required this.fixtureId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Fixture'),
        centerTitle: true,
      ),
      body: Obx(() {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: 20),
                _buildFixtureDetails(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Icon(
          Icons.sports_cricket,
          size: 30,
        ),
        SizedBox(width: 10),
        Text(
          'Fixture Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFixtureDetails() {
    Fixture? fixture = clubController.fixtures.firstWhereOrNull(
      (fixture) => fixture.fixtureId == fixtureId,
    );

    if (fixture == null) {
      return Center(child: Text('Fixture not found.'));
    }

    if (clubController.isLoading.value) {
      return _buildLoadingIndicator();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTeamDetailsSection(fixture),
        SizedBox(height: 20),
        _buildSportSection(fixture),
        SizedBox(height: 20),
        _buildDateSection(fixture),
        SizedBox(height: 20),
        _buildResultSection(fixture),
        SizedBox(height: 20),
        _buildLocationSection(fixture),
      ],
    );
  }

  Widget _buildTeamDetailsSection(Fixture fixture) {
    ClubTeamsData? team1 = clubController.clubsTeamsData
        .firstWhereOrNull((team) => team.id == fixture.team1Id);
    ClubTeamsData? team2 = clubController.clubsTeamsData
        .firstWhereOrNull((team) => team.id == fixture.team2Id);

    if (team1 == null || team2 == null) {
      return Center(child: Text('One or both teams not found.'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTeamDetailCard('Team 1', team1),
        SizedBox(height: 20),
        _buildTeamDetailCard('Team 2', team2),
      ],
    );
  }

  Widget _buildTeamDetailCard(String label, ClubTeamsData team) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blue[100],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (team.logoUrl != null && team.logoUrl!.isNotEmpty)
                Image.network(
                  team.logoUrl!,
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
              SizedBox(width: 10),
              Text(
                '$label: ${team.name}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'Coach: ${team.contactEmail ?? 'N/A'}',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            'Sport: ${team.sport ?? 'N/A'}',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

 
  Widget _buildSportSection(Fixture fixture) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blue[100],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.sports_cricket),
          SizedBox(width: 10),
          Text(
            'Sport: ${fixture.sport}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSection(Fixture fixture) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blue[100],
      ),
      child: Row(
        children: [
          Icon(Icons.date_range, size: 24),
          SizedBox(width: 10),
          Text(
            'Match Date: ${DateFormat('dd/MM/yyyy').format(fixture.matchDateTime)}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildResultSection(Fixture fixture) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blue[100],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.emoji_events_outlined),
          SizedBox(width: 10),
          Text(
            'Match Result: ${fixture.result ?? 'No result available'}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection(Fixture fixture) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blue[100],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.location_on_outlined),
          SizedBox(width: 10),
          Text(
            'Location: ${fixture.location}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Processing request...",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 15,
          ),
          CircularProgressIndicator(),
        ],
      ),
    );
  }
}

*/

 // Widget _buildTeamDetailCard(String label, ClubTeamsData team) {
  //   return Container(
  //     padding: EdgeInsets.all(10),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(10),
  //       color: Colors.blue[100],
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           '$label: ${team.name}',
  //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
  //         ),
  //         SizedBox(height: 10),
  //         Text(
  //           'Coach: ${team.contactEmail ?? 'N/A'}',
  //           style: TextStyle(fontSize: 16),
  //         ),
  //         SizedBox(height: 10),
  //         Text(
  //           'Sport: ${team.sport ?? 'N/A'}',
  //           style: TextStyle(fontSize: 16),
  //         ),
  //         SizedBox(height: 10),
  //         // Text(
  //         //   'Recent Performance:',
  //         //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //         // ),
  //         // ...team.recentMatches.map((match) => Text(
  //         //       '• ${match}',
  //         //       style: TextStyle(fontSize: 14),
  //         //     )),
  //       ],
  //     ),
  //   );
  // }

