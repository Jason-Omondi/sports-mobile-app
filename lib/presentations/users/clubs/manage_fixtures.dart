import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'controller/clubs_controller.dart';
import '../../../data/models/fixtures_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For date formatting

class ManageFixtureScreen extends StatelessWidget {
  final ClubController clubController = Get.find();
  final String fixtureId;

  ManageFixtureScreen({Key? key, required this.fixtureId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Fixture'),
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
                _buildFixtureDetails(context),
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
          'Manage Fixture',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildFixtureDetails(BuildContext context) {
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
        _buildDateSection(fixture, context),
        SizedBox(height: 20),
        _buildResultSection(fixture),
        SizedBox(height: 20),
        _buildLocationSection(fixture),
        SizedBox(height: 20),
        _buildActionButtons(context),
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

  Widget _buildDateSection(Fixture fixture, BuildContext context) {
    return InkWell(
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: fixture.matchDateTime,
          firstDate: DateTime.now(),
          lastDate: DateTime(DateTime.now().year + 1),
        );
        if (pickedDate != null) {
          clubController.updateFixtureDate(
              fixtureId, pickedDate.toIso8601String());
        }
      },
      child: Container(
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

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blue[100],
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    _showUpdateResultDialog(context, fixtureId);
                  },
                  icon: Icon(Icons.edit_outlined),
                  label: Text('Update Result'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _showUpdateLocationDialog(context, fixtureId);
                  },
                  icon: Icon(Icons.edit_location_outlined),
                  label: Text('Update Location'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    clubController.deleteFixture(fixtureId);
                    Get.back();
                  },
                  icon: Icon(Icons.delete_outlined),
                  label: Text('Delete Fixture'),
                ),
              ],
            ),
          ],
        ),
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

  // Method to show dialog for updating match result
  void _showUpdateResultDialog(BuildContext context, String fixtureId) {
    String newResult = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Match Result'),
          content: TextFormField(
            onChanged: (value) {
              newResult = value;
            },
            decoration: InputDecoration(
              hintText: 'Enter match result',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                clubController.updateFixtureResult(fixtureId, newResult);
                Navigator.pop(context);
              },
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Method to show dialog for updating match location
  void _showUpdateLocationDialog(BuildContext context, String fixtureId) {
    String newLocation = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Match Location'),
          content: TextFormField(
            onChanged: (value) {
              newLocation = value;
            },
            decoration: InputDecoration(
              hintText: 'Enter match location',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                clubController.updateFixtureLocation(fixtureId, newLocation);
                Navigator.pop(context);
              },
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}



// class ManageFixtureScreen extends StatelessWidget {
//   final ClubController clubController = Get.find();
//   final String fixtureId;

//   ManageFixtureScreen({Key? key, required this.fixtureId}) : super(key: key);

//   Widget _buildHeader(String title) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Text(
//         title,
//         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//       ),
//     );
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         children: [
//           Text(
//             label,
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(width: 8),
//           Text(
//             value,
//             style: TextStyle(fontSize: 16),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionButton(
//       BuildContext context, String label, Function() onPressed) {
//     return Expanded(
//       child: ElevatedButton(
//         onPressed: onPressed,
//         child: Text(label),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Manage Fixture'),
//         centerTitle: true,
//       ),
//       body: Obx(() {
//         Fixture? fixture = clubController.fixtures.firstWhereOrNull(
//           (fixture) => fixture.fixtureId == fixtureId,
//         );

//         if (fixture == null) {
//           return Center(
//             child: Text('Fixture not found.'),
//           );
//         }

//         if (clubController.isLoading.value) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   "Processing request...",
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(
//                   height: 15,
//                 ),
//                 CircularProgressIndicator(),
//               ],
//             ),
//           );
//         } else {
//           // Find team names using team IDs
//           String team1Name = clubController.clubsTeamsData
//                   .firstWhereOrNull((team) => team.id == fixture.team1Id)
//                   ?.name ??
//               'Team 1';
//           String team2Name = clubController.clubsTeamsData
//                   .firstWhereOrNull((team) => team.id == fixture.team2Id)
//                   ?.name ??
//               'Team 2';

//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildHeader('Team 1:'),
//                 _buildDetailRow('Name:', team1Name),
//                 _buildHeader('Team 2:'),
//                 _buildDetailRow('Name:', team2Name),
//                 _buildHeader('Sport:'),
//                 _buildDetailRow('', fixture.sport),
//                 _buildHeader('Match Date:'),
//                 InkWell(
//                   onTap: () async {
//                     final DateTime? firstDate = DateTime.now();
//                     final DateTime? lastDate =
//                         DateTime(DateTime.now().year + 1);
//                     final DateTime? initialDate =
//                         fixture.matchDateTime.isBefore(firstDate!)
//                             ? firstDate
//                             : fixture.matchDateTime;
//                     final DateTime? pickedDate = await showDatePicker(
//                       context: context,
//                       initialDate: initialDate!,
//                       firstDate: firstDate,
//                       lastDate: lastDate!,
//                     );
//                     if (pickedDate != null) {
//                       clubController.updateFixtureDate(
//                           fixtureId, pickedDate.toIso8601String());
//                     }
//                   },
//                   child: Container(
//                     padding: EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[100],
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(Icons.date_range),
//                         SizedBox(width: 10),
//                         Text(
//                           'Match Date',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                         Spacer(),
//                         Text(
//                           DateFormat('dd/MM/yyyy')
//                               .format(fixture.matchDateTime),
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 _buildHeader('Match Result:'),
//                 _buildDetailRow('', fixture.result ?? 'No result available'),
//                 _buildHeader('Location:'),
//                 _buildDetailRow('', fixture.location),
//                 SizedBox(height: 20),
//                 Row(
//                   children: [
//                     _buildActionButton(context, 'Update Result', () {
//                       _showUpdateResultDialog(context, fixtureId);
//                     }),
//                     SizedBox(width: 20),
//                     _buildActionButton(context, 'Update Location', () {
//                       _showUpdateLocationDialog(context, fixtureId);
//                     }),
//                   ],
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     clubController.deleteFixture(fixtureId);
//                     Get.back();
//                   },
//                   child: Text('Delete Fixture'),
//                 ),
//               ],
//             ),
//           );
//         }
//       }),
//     );
//   }

//   Widget _buildFixtureDetails(BuildContext context) {
//     Fixture? fixture = clubController.fixtures.firstWhereOrNull(
//       (fixture) => fixture.fixtureId == fixtureId,
//     );

//     if (fixture == null) {
//       return Center(child: Text('Fixture not found.'));
//     }

//     if (clubController.isLoading.value) {
//       return _buildLoadingIndicator();
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildTeamNameSection(fixture),
//         SizedBox(height: 20),
//         _buildSportSection(fixture),
//         SizedBox(height: 20),
//         _buildDateSection(fixture, context),
//         SizedBox(height: 20),
//         _buildResultSection(fixture),
//         SizedBox(height: 20),
//         _buildLocationSection(fixture),
//         SizedBox(height: 20),
//         _buildActionButtons(context),
//       ],
//     );
//   }

//   Widget _buildLoadingIndicator() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             "Processing request...",
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           SizedBox(
//             height: 15,
//           ),
//           CircularProgressIndicator(),
//         ],
//       ),
//     );
//   }

//   Widget _buildTeamNameSection(Fixture fixture) {
//     String team1Name = clubController.clubsTeamsData
//             .firstWhereOrNull((team) => team.id == fixture.team1Id)
//             ?.name ??
//         'Team 1';
//     String team2Name = clubController.clubsTeamsData
//             .firstWhereOrNull((team) => team.id == fixture.team2Id)
//             ?.name ??
//         'Team 2';

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Team 1:',
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 10),
//         Text(
//           team1Name,
//           style: TextStyle(fontSize: 16),
//         ),
//         SizedBox(height: 20),
//         Text(
//           'Team 2:',
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 10),
//         Text(
//           team2Name,
//           style: TextStyle(fontSize: 16),
//         ),
//       ],
//     );
//   }

//   Widget _buildSportSection(Fixture fixture) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Sport:',
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 10),
//         Text(
//           fixture.sport,
//           style: TextStyle(fontSize: 16),
//         ),
//       ],
//     );
//   }

//   Widget _buildDateSection(Fixture fixture, BuildContext context) {
//     return InkWell(
//       onTap: () async {
//         final DateTime? firstDate = DateTime.now();
//         final DateTime? lastDate = DateTime(DateTime.now().year + 1);
//         final DateTime? initialDate = fixture.matchDateTime.isBefore(firstDate!)
//             ? firstDate
//             : fixture.matchDateTime;
//         final DateTime? pickedDate = await showDatePicker(
//           context: context,
//           initialDate: initialDate!,
//           firstDate: firstDate,
//           lastDate: lastDate!,
//         );
//         if (pickedDate != null) {
//           clubController.updateFixtureDate(
//               fixtureId, pickedDate.toIso8601String());
//         }
//       },
//       child: Container(
//         padding: EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.grey[100],
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Row(
//           children: [
//             Icon(Icons.date_range),
//             SizedBox(width: 10),
//             Text(
//               'Match Date',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey[600],
//               ),
//             ),
//             Spacer(),
//             Text(
//               DateFormat('dd/MM/yyyy').format(fixture.matchDateTime),
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildResultSection(Fixture fixture) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Match Result:',
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 10),
//         Text(
//           fixture.result ?? 'No result available',
//           style: TextStyle(fontSize: 16),
//         ),
//       ],
//     );
//   }

//   Widget _buildLocationSection(Fixture fixture) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Location:',
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 10),
//         Text(
//           fixture.location,
//           style: TextStyle(fontSize: 16),
//         ),
//       ],
//     );
//   }

//   Widget _buildActionButtons(BuildContext context) {
//     return Row(
//       children: [
//         Expanded(
//           child: ElevatedButton.icon(
//             onPressed: () {
//               _showUpdateResultDialog(context, fixtureId);
//             },
//             icon: Icon(Icons.edit),
//             label: Text('Update Result'),
//           ),
//         ),
//         SizedBox(width: 20),
//         Expanded(
//           child: ElevatedButton.icon(
//             onPressed: () {
//               _showUpdateLocationDialog(context, fixtureId);
//             },
//             icon: Icon(Icons.edit_location),
//             label: Text('Update Location'),
//           ),
//         ),
//         SizedBox(width: 20),
//         Expanded(
//           child: ElevatedButton.icon(
//             onPressed: () {
//               clubController.deleteFixture(fixtureId);
//               Get.back();
//             },
//             icon: Icon(Icons.delete),
//             label: Text('Delete Fixture'),
//           ),
//         ),
//       ],
//     );
//   }

//   // Method to show dialog for updating match result
//   void _showUpdateResultDialog(BuildContext context, String fixtureId) {
//     String newResult = '';
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Update Match Result'),
//           content: TextFormField(
//             onChanged: (value) {
//               newResult = value;
//             },
//             decoration: InputDecoration(
//               hintText: 'Enter match result',
//               border: OutlineInputBorder(),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 clubController.updateFixtureResult(fixtureId, newResult);
//                 Navigator.pop(context);
//               },
//               child: Text('Update'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('Cancel'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   // Method to show dialog for updating match location
//   void _showUpdateLocationDialog(BuildContext context, String fixtureId) {
//     String newLocation = '';
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Update Match Location'),
//           content: TextFormField(
//             onChanged: (value) {
//               newLocation = value;
//             },
//             decoration: InputDecoration(
//               hintText: 'Enter match location',
//               border: OutlineInputBorder(),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 clubController.updateFixtureLocation(fixtureId, newLocation);
//                 Navigator.pop(context);
//               },
//               child: Text('Update'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('Cancel'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }


/*
class ManageFixtureScreen extends StatelessWidget {
  final ClubController clubController = Get.find();
  final String fixtureId;

  ManageFixtureScreen({Key? key, required this.fixtureId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Fixture? fixture = clubController.fixtures.firstWhereOrNull(
      (fixture) => fixture.fixtureId == fixtureId,
    );

    if (fixture == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Fixture Not Found'),
        ),
        body: Center(
          child: Text('Fixture not found.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Fixture'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Match Date',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            InkWell(
              onTap: () async {
                final DateTime? firstDate = DateTime.now();
                final DateTime? lastDate = DateTime(DateTime.now().year + 1);
                final DateTime? initialDate =
                    fixture.matchDateTime.isBefore(firstDate!)
                        ? firstDate
                        : fixture.matchDateTime;
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: initialDate!,
                  firstDate: firstDate,
                  lastDate: lastDate!,
                );
                if (pickedDate != null) {
                  clubController.updateFixtureDate(
                      fixtureId, pickedDate.toIso8601String());
                }
              },
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.date_range),
                    SizedBox(width: 10),
                    Text(
                      'Match Date',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    Spacer(),
                    Text(
                      DateFormat('dd/MM/yyyy').format(fixture.matchDateTime),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Match Result',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextFormField(
              initialValue: fixture.result ?? '',
              onChanged: (value) {
                clubController.updateFixtureResult(fixtureId, value);
              },
              decoration: InputDecoration(
                hintText: 'Enter match result',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Location',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextFormField(
              initialValue: fixture.location,
              onChanged: (value) {
                clubController.updateFixtureLocation(fixtureId, value);
              },
              decoration: InputDecoration(
                hintText: 'Enter match location',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                clubController.deleteFixture(fixtureId);
                Get.back();
              },
              child: Text('Delete Fixture'),
            ),
          ],
        ),
      ),
    );
  }
}
*/