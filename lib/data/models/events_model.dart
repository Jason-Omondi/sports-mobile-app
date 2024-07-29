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
