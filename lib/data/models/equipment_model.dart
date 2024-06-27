class Equipment {
  String? equipmentID; // Unique identifier for the equipment
  String? name; // Name of the equipment (e.g., Football, Jersey)
  String? type; // Type or category of the equipment
  String? teamId; // ID of the team to which the equipment is issued
  DateTime? issuedDate; // Date when the equipment was issued to the team
  DateTime? returnDate; // Date when the equipment was returned (if returned)
  bool isReturned; // Status indicating whether the equipment has been returned
  String?
      condition; // Condition of the equipment (e.g., Good, Damaged) when returned or checked

  Equipment({
    this.equipmentID,
    this.name,
    this.type,
    this.teamId,
    this.issuedDate,
    this.returnDate,
    this.isReturned = false,
    this.condition,
  });

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      equipmentID: json['equipmentID'],
      name: json['name'],
      type: json['type'],
      teamId: json['teamId'],
      issuedDate: json['issuedDate'] != null
          ? DateTime.parse(json['issuedDate'])
          : null,
      returnDate: json['returnDate'] != null
          ? DateTime.parse(json['returnDate'])
          : null,
      isReturned: json['isReturned'] ?? false,
      condition: json['condition'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'equipmentID': equipmentID,
      'name': name,
      'type': type,
      'teamId': teamId,
      'issuedDate': issuedDate?.toIso8601String(),
      'returnDate': returnDate?.toIso8601String(),
      'isReturned': isReturned,
      'condition': condition,
    };
  }
}
