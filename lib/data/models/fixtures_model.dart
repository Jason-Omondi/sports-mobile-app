class Fixture {
  String fixtureId;
  String team1Id;
  String team2Id;
  String sport;
  DateTime matchDateTime;
  String location;
  String? result; // Optional field for storing match result
  List<String>? playersList; // Optional field for storing list of players
  //recent matches will store match result, teamid 1 and teamid 2, locaton and matchDate time

  Fixture({
    required this.fixtureId,
    required this.team1Id,
    required this.team2Id,
    required this.sport,
    required this.matchDateTime,
    required this.location,
    this.result,
    this.playersList,
  });

  factory Fixture.fromJson(Map<String, dynamic> json) {
    return Fixture(
      fixtureId: json['fixtureId'],
      team1Id: json['team1Id'],
      team2Id: json['team2Id'],
      sport: json['sport'],
      matchDateTime: DateTime.parse(json['matchDateTime']),
      location: json['location'],
      result: json['result'],
      playersList: json['playersList'] != null
          ? List<String>.from(json['playersList'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fixtureId': fixtureId,
      'team1Id': team1Id,
      'team2Id': team2Id,
      'sport': sport,
      'matchDateTime': matchDateTime.toIso8601String(),
      'location': location,
      'result': result,
      'playersList': playersList,
    };
  }
}
