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





// class ClubTeamsData {
//   String? id;
//   String? name;
//   String? logoUrl;
//   bool? isJuniorTeam;
//   String? sport;
//   String? county;
//   String? postalZip;
//   String? contactEmail;
//   //String clubType;

//   ClubTeamsData({
//     this.id,
//     this.name,
//     this.logoUrl,
//     this.isJuniorTeam,
//     this.sport,
//     this.county,
//     this.postalZip,
//     this.contactEmail,
//     //required this.clubType,
//   });

//   factory ClubTeamsData.fromJson(Map<String, dynamic> json) {
//     return ClubTeamsData(
//       id: json['id'] ?? '',
//       name: json['name'] ?? '',
//       logoUrl: json['logoUrl'] ?? '',
//       isJuniorTeam: json['isJuniorTeam'] ?? false,
//       sport: json['sport'] ?? '',
//       county: json['county'] ?? '',
//       postalZip: json['postalZip'] ?? '',
//       contactEmail: json['contactEmail'] ?? '',
//       //clubType: json['clubType'] ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'logoUrl': logoUrl,
//       'isJuniorTeam': isJuniorTeam,
//       'sport': sport,
//       'county': county,
//       'postalZip': postalZip,
//       'contactEmail': contactEmail,
//       //'clubType': clubType,
//     };
//   }
// }
