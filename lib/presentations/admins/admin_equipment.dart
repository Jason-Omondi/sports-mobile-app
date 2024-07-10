import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../users/clubs/controller/clubs_controller.dart';
import '../../../data/models/equipment_model.dart'; // Import your ClubController

class EquipmentScreen extends StatelessWidget {
  final String teamId;
  final ClubController clubController = Get.find();

  EquipmentScreen({required this.teamId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Equipment Management',
          style: GoogleFonts.nunito(),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              'Issued Equipment:',
              style: GoogleFonts.nunito(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),

            Expanded(
              child: Obx(
                () {
                  if (clubController.isLoading.value) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Processing...'),
                        ],
                      ),
                    );
                  } else {
                    // Filter equipments by teamId
                    final teamEquipments = clubController.equipments
                        .where((equipment) => equipment.teamId == teamId)
                        .toList();

                    if (teamEquipments.isEmpty) {
                      return Center(
                        child: Text(
                          'No equipment issued to this team.',
                          style: GoogleFonts.nunito(),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: teamEquipments.length,
                        itemBuilder: (context, index) {
                          Equipment equipment = teamEquipments[index];
                          return _buildEquipmentItem(equipment, context);
                        },
                      );
                    }
                  }
                },
              ),
            ),

            // Expanded(
            //   child: Obx(
            //     () => clubController.isLoading.value
            //         ? Center(
            //             child: Column(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: [
            //                 CircularProgressIndicator(),
            //                 SizedBox(height: 16),
            //                 Text('Processing...'),
            //               ],
            //             ),
            //           )
            //         : clubController.equipments.isEmpty
            //             ? Center(
            //                 child: Text(
            //                   'No equipment issued to this team.',
            //                   style: GoogleFonts.nunito(),
            //                 ),
            //               )
            //               //only show equipment whose team Id == teamId variable of constructor.
            //             : ListView.builder(
            //                 itemCount: clubController.equipments.length,
            //                 itemBuilder: (context, index) {
            //                   Equipment equipment =
            //                       clubController.equipments[index];
            //                   return _buildEquipmentItem(equipment, context);
            //                 },
            //               ),
            //   ),
            // ),

            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _showCreateEquipmentDialog(context);
              },
              child: Text('Create Equipment'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEquipmentItem(Equipment equipment, BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          equipment.name ?? '',
          style: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text('Type: ${equipment.type ?? ''}'),
            Text('Condition: ${equipment.condition ?? ''}'),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    _showReturnConfirmationDialog(context, equipment);
                  },
                  child: Text(
                    equipment.isReturned ? 'Returned' : 'Return',
                    style: TextStyle(
                      color: equipment.isReturned ? Colors.grey : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateEquipmentDialog(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController typeController = TextEditingController();
    TextEditingController conditionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Create Equipment'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Equipment Name'),
              ),
              TextField(
                controller: typeController,
                decoration: InputDecoration(labelText: 'Equipment Type'),
              ),
              TextField(
                controller: conditionController,
                decoration: InputDecoration(labelText: 'Equipment Condition'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Create equipment based on input
              String name = nameController.text.trim();
              String type = typeController.text.trim();
              String condition = conditionController.text.trim();
              if (name.isNotEmpty && type.isNotEmpty && condition.isNotEmpty) {
                clubController.createEquipment(
                  Equipment(
                    name: name,
                    type: type,
                    teamId: teamId,
                    issuedDate: DateTime.now(),
                    isReturned: false,
                    condition: condition,
                  ),
                );
                Navigator.of(context).pop();
              } else {
                // Handle validation or empty fields
              }
            },
            child: Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showReturnConfirmationDialog(
      BuildContext context, Equipment equipment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Return Equipment'),
        content: Text('Are you sure you want to return ${equipment.name}?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              clubController.returnEquipment(equipment, equipment.condition!);
              Navigator.of(context).pop();
            },
            child: Text('Return', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}











// class EquipmentScreen extends StatelessWidget {
//   final String teamId;
//   final ClubController clubController = Get.find();

//   EquipmentScreen({required this.teamId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Equipment for Team',
//           style: GoogleFonts.nunito(),
//         ),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Obx(
//           () => clubController.isLoading.value
//               ? Center(
//                   child: CircularProgressIndicator(),
//                 )
//               : clubController.equipments.isEmpty
//                   ? Center(
//                       child: Text(
//                         'No equipment issued for this team.',
//                         style: GoogleFonts.nunito(),
//                       ),
//                     )
//                   : ListView.builder(
//                       itemCount: clubController.equipments.length,
//                       itemBuilder: (context, index) {
//                         Equipment equipment =
//                             clubController.equipments[index];
//                         return _buildEquipmentCard(context, equipment);
//                       },
//                     ),
//         ),
//       ),
//     );
//   }

//   Widget _buildEquipmentCard(BuildContext context, Equipment equipment) {
//     return Card(
//       elevation: 2,
//       margin: EdgeInsets.symmetric(vertical: 8),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Equipment ID: ${equipment.equipmentID}',
//               style: GoogleFonts.nunito(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 8),
//             Text(
//               'Name: ${equipment.name}',
//               style: GoogleFonts.nunito(),
//             ),
//             SizedBox(height: 4),
//             Text(
//               'Type: ${equipment.type}',
//               style: GoogleFonts.nunito(),
//             ),
//             SizedBox(height: 4),
//             Text(
//               'Issued Date: ${_formatDate(equipment.issuedDate)}',
//               style: GoogleFonts.nunito(),
//             ),
//             SizedBox(height: 4),
//             equipment.isReturned
//                 ? Text(
//                     'Return Date: ${_formatDate(equipment.returnDate!)}',
//                     style: GoogleFonts.nunito(),
//                   )
//                 : SizedBox.shrink(),
//             SizedBox(height: 4),
//             Text(
//               'Condition: ${equipment.condition}',
//               style: GoogleFonts.nunito(),
//             ),
//             SizedBox(height: 8),
//             if (!equipment.isReturned)
//               ElevatedButton(
//                 onPressed: () {
//                   _showReturnConfirmationDialog(context, equipment);
//                 },
//                 child: Text('Return Equipment'),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   String _formatDate(DateTime? dateTime) {
//     if (dateTime == null) return '';
//     return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
//   }

//   void _showReturnConfirmationDialog(
//       BuildContext context, Equipment equipment) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Return Equipment'),
//         content: Text('Are you sure you want to return this equipment?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//             //  clubController.returnEquipment(equipment.equipmentID!);
//               Navigator.of(context).pop();
//             },
//             child: Text('Return', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }
// }
