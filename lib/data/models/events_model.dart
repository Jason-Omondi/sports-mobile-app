import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement {
  final String id;
  final String title;
  final String description;
  final String type; // 'match', 'promotion', 'campaign'
  final DateTime startDate;
  final DateTime endDate;
  final String createdBy;
  final String? fixtureId; // Only for match announcements
  final String? targetAudience; // For promotions and campaigns
  final String? offerDetails; // For promotions
  final String? campaignGoals; // For campaigns
  final List<String>? channels; // For promotions and campaigns

  Announcement({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.createdBy,
    this.fixtureId,
    this.targetAudience,
    this.offerDetails,
    this.campaignGoals,
    this.channels,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: json['type'],
      startDate: (json['startDate'] as Timestamp).toDate(),
      endDate: (json['endDate'] as Timestamp).toDate(),
      createdBy: json['createdBy'],
      fixtureId: json['fixtureId'],
      targetAudience: json['targetAudience'],
      offerDetails: json['offerDetails'],
      campaignGoals: json['campaignGoals'],
      channels: List<String>.from(json['channels'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'type': type,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'createdBy': createdBy,
      'fixtureId': fixtureId,
      'targetAudience': targetAudience,
      'offerDetails': offerDetails,
      'campaignGoals': campaignGoals,
      'channels': channels,
    };
  }
}

/*

//2
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


//3
class ClubTeamsData {
  String? id;
  String? name;
  String? logoUrl;
  bool? isJuniorTeam;
  String? sport;
  String? county;
  String? postalZip;
  String? contactEmail;
  bool?
      hasPaidRegistrationFee; // New property to indicate if the team has paid registration fee
  String? paymentTransactionId; // Transaction ID for the payment
  String? paymentMethod; // Payment method (e.g., M-Pesa)
  String? paymentStatus; // Payment status (e.g., Paid, Pending, Failed)

  ClubTeamsData({
    this.id,
    this.name,
    this.logoUrl,
    this.isJuniorTeam,
    this.sport,
    this.county,
    this.postalZip,
    this.contactEmail,
    this.hasPaidRegistrationFee,
    this.paymentTransactionId,
    this.paymentMethod,
    this.paymentStatus,
  });

  factory ClubTeamsData.fromJson(Map<String, dynamic> json) {
    return ClubTeamsData(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      logoUrl: json['logoUrl'] ?? '',
      isJuniorTeam: json['isJuniorTeam'] ?? false,
      sport: json['sport'] ?? '',
      county: json['county'] ?? '',
      postalZip: json['postalZip'] ?? '',
      contactEmail: json['contactEmail'] ?? '',
      hasPaidRegistrationFee: json['hasPaidRegistrationFee'] ?? false,
      paymentTransactionId: json['paymentTransactionId'],
      paymentMethod: json['paymentMethod'],
      paymentStatus: json['paymentStatus'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logoUrl': logoUrl,
      'isJuniorTeam': isJuniorTeam,
      'sport': sport,
      'county': county,
      'postalZip': postalZip,
      'contactEmail': contactEmail,
      'hasPaidRegistrationFee': hasPaidRegistrationFee,
      'paymentTransactionId': paymentTransactionId,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
    };
  }
}
*/