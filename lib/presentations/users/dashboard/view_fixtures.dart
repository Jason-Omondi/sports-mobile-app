import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../../../data/models/fixtures_model.dart';
import '../clubs/controller/clubs_controller.dart';

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
        _buildTeamNamesSection(fixture),
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

  Widget _buildTeamNamesSection(Fixture fixture) {
    String team1Name = clubController.clubsTeamsData
            .firstWhereOrNull((team) => team.id == fixture.team1Id)
            ?.name ??
        'Team 1';
    String team2Name = clubController.clubsTeamsData
            .firstWhereOrNull((team) => team.id == fixture.team2Id)
            ?.name ??
        'Team 2';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blue[100],
          ),
          child: Text(
            'Team 1: $team1Name',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(width: 20),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.blue[100],
          ),
          child: Text(
            'Team 2: $team2Name',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
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
