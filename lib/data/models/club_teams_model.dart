class ClubTeamsData {
  String id;
  String name;
  String logoUrl;
  bool isJuniorTeam;
  String sport;
  String county;
  String postalZip;
  String contactEmail;
  //String clubType;

  ClubTeamsData({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.isJuniorTeam,
    required this.sport,
    required this.county,
    required this.postalZip,
    required this.contactEmail,
    //required this.clubType,
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
      //clubType: json['clubType'] ?? '',
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
      //'clubType': clubType,
    };
  }
}
