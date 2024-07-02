import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/models/club_teams_model.dart';
import 'controller/clubs_controller.dart'; // Import your ClubController

class CreateSingleTeam extends StatelessWidget {
  CreateSingleTeam({Key? key}) : super(key: key);

  final ClubController clubController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Club',
          style: GoogleFonts.nunito(),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {}, icon: Icon(Icons.notifications_active_outlined))
        ],
      ),
      body: Obx(() {
        if (clubController.isLoading.value) {
          return Center(
              child: Column(
            children: [
              Text(
                "Processing request...",
                style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 15,
              ),
              CircularProgressIndicator(),
            ],
          ));
        } else {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 40),
                  // Text field for club name
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: clubController.nameController,
                      decoration: InputDecoration(
                        hintText:
                            'Name of your team, club, or organization (max 30 characters)',
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: clubController.nameFocusNode.hasFocus
                                ? Colors.blue
                                : Colors.grey.shade400,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Logo selection row
                  Row(
                    children: [
                      Text('Add Logo',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Spacer(),
                      FloatingActionButton(
                        onPressed: () async {
                          final pickedFile = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (pickedFile != null) {
                            final image = File(pickedFile.path);
                            final imageUrl = await clubController
                                .uploadImageToFirebaseStorage(image);
                            if (imageUrl != null) {
                              clubController.logoUrl = imageUrl;
                            } else {
                              Get.snackbar("Info!", "Something went wrong!");
                            }
                          }
                        },
                        tooltip: 'Pick Image',
                        child: Icon(Icons.add_a_photo),
                      ),
                      SizedBox(width: 16),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: clubController.logoUrl != null
                              ? Image.network(
                                  clubController.logoUrl!,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : Icon(Icons.image, size: 50, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Switch for junior/youth team
                  Row(
                    children: [
                      Text(
                        'This is a junior/youth team',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Switch(
                        value: clubController.isJuniorTeam.value,
                        onChanged: (value) {
                          clubController.isJuniorTeam.value = value;
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Dropdown for sport selection
                  Row(
                    children: [
                      Text(
                        'Sport Selection',
                        style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      // Inside the Obx widget where the dropdowns are built
                      Obx(() {
                        print(
                            'Selected Sport: ${clubController.selectedSport.value}');
                        print(
                            'Selected County: ${clubController.selectedCounty.value}');

                        return DropdownButton<String>(
                          value: clubController.selectedSport.value,
                          items: clubController.sportsTypes.map((sport) {
                            return DropdownMenuItem<String>(
                              value: sport,
                              child: Text(
                                sport,
                                style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.w400),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            clubController.selectedSport.value = value!;
                          },
                          hint: Text(
                            'Select Sport',
                            style:
                                GoogleFonts.nunito(fontWeight: FontWeight.w600),
                          ),
                        );
                      }),

                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        'County of school',
                        style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Obx(() {
                        return DropdownButton<String>(
                          value: clubController.selectedCounty.value,
                          items: clubController.counties.map((county) {
                            return DropdownMenuItem<String>(
                              value: county,
                              child: Text(
                                county,
                                style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.w200),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            clubController.selectedCounty.value = value!;
                          },
                          hint: Text(
                            'Select County',
                            style:
                                GoogleFonts.nunito(fontWeight: FontWeight.w600),
                          ),
                        );
                      }),
                    ],
                  ),

                  SizedBox(height: 20),
                  // Text field for postal code
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: clubController.postalCodeController,
                      decoration: InputDecoration(
                        hintText: 'Postal Zip',
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: clubController.postalCodeFocusNode.hasFocus
                                ? Colors.blue
                                : Colors.grey.shade400,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Text field for contact email
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: clubController.clubEmailController,
                      decoration: InputDecoration(
                        hintText: 'Contact Email',
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: clubController.contactEmailFocusNode.hasFocus
                                ? Colors.blue
                                : Colors.grey.shade400,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  SizedBox(height: 40),
                  // Button to create club
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        // Generate a random ID for the new club
                        String randomId = clubController.generateRandomString();

                        // Show the dialog to enter or confirm the phone number
                        showDialog(
                          context: context,
                          builder: (context) {
                            TextEditingController phoneNumberController =
                                TextEditingController(
                                    text: GetStorage().read('phone_number') ??
                                        "");
                            return AlertDialog(
                              title: Text('Phone Number'),
                              content: TextField(
                                controller: phoneNumberController,
                                // controller: phoneNumberController,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  hintText: 'Enter phone number (2547******)',
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.blue),
                                  ),
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Use Saved Number'),
                                  onPressed: () {
                                    // Use the number saved in GetStorage
                                    String savedNumber =
                                        GetStorage().read('phone_number') ?? "";
                                    if (savedNumber.isNotEmpty &&
                                        _isValidPhoneNumber(savedNumber)) {
                                      _createNewClub(savedNumber);
                                      Navigator.of(context).pop();
                                    } else {
                                      Get.snackbar("Invalid Number!",
                                          "Please provide a valid phone number in the format '2547******'.");
                                    }
                                  },
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Get the entered phone number
                                    String enteredNumber =
                                        phoneNumberController.text.trim();
                                    if (_isValidPhoneNumber(enteredNumber)) {
                                      _createNewClub(enteredNumber);
                                      Navigator.of(context).pop();
                                    } else {
                                      Get.snackbar("Invalid Number!",
                                          "Please provide a valid phone number in the format '2547******'.");
                                    }
                                  },
                                  child: Text('Proceed'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text(
                        'Create',
                        style: GoogleFonts.nunito(),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7)),
                        textStyle: GoogleFonts.nunito(
                            fontSize: 16, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }),
    );
  }

  bool _isValidPhoneNumber(String phoneNumber) {
    // Validate phone number format: '2547******'
    final RegExp regExp = RegExp(r'^2547\d{6}$');
    return regExp.hasMatch(phoneNumber);
  }

  Future<void> _createNewClub(String phoneNumber) async {
    // Generate a random ID for the new club
    String randomId = clubController.generateRandomString();

    // Create a new ClubTeamsData object with the form data
    final clubData = ClubTeamsData(
      id: randomId,
      contactEmail: clubController.clubEmailController!.text,
      logoUrl: clubController.logoUrl!,
      county: clubController.selectedCounty.value,
      isJuniorTeam: clubController.isJuniorTeam.value,
      name: clubController.nameController!.text,
      postalZip: clubController.postalCodeController!.text,
      sport: clubController.selectedSport.value,
    );

    // Call the method to create a new club
    await clubController.createNewClub(clubData, phoneNumber);
  }
}


// class CreateSingleTeam extends StatelessWidget {
//   CreateSingleTeam({Key? key}) : super(key: key);

//   final ClubController clubController = Get.find();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'New Club',
//           style: GoogleFonts.nunito(),
//         ),
//         centerTitle: true,
//         elevation: 0,
//         actions: [
//           IconButton(
//               onPressed: () {}, icon: Icon(Icons.notifications_active_outlined))
//         ],
//       ),
//       body: Obx(() {
//         if (clubController.isLoading.value) {
//           return Center(
//               child: Column(
//             children: [
//               Text(
//                 "Processing request...",
//                 style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               CircularProgressIndicator(),
//             ],
//           ));
//         } else {
//           return SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   SizedBox(height: 40),
//                   // Text field for club name
//                   Container(
//                     decoration: BoxDecoration(
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.5),
//                           spreadRadius: 1,
//                           blurRadius: 5,
//                           offset: Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     child: TextField(
//                       controller: clubController.nameController,
//                       decoration: InputDecoration(
//                         hintText:
//                             'Name of your team, club, or organization (max 30 characters)',
//                         border: OutlineInputBorder(),
//                         enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(
//                             color: clubController.nameFocusNode.hasFocus
//                                 ? Colors.blue
//                                 : Colors.grey.shade400,
//                             width: 1.0,
//                           ),
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide:
//                               BorderSide(color: Colors.blue, width: 2.0),
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   // Logo selection row
//                   Row(
//                     children: [
//                       Text('Add Logo',
//                           style: TextStyle(fontWeight: FontWeight.bold)),
//                       Spacer(),
//                       FloatingActionButton(
//                         onPressed: () async {
//                           final pickedFile = await ImagePicker()
//                               .pickImage(source: ImageSource.gallery);
//                           if (pickedFile != null) {
//                             final image = File(pickedFile.path);
//                             final imageUrl = await clubController
//                                 .uploadImageToFirebaseStorage(image);
//                             if (imageUrl != null) {
//                               clubController.logoUrl = imageUrl;
//                             } else {
//                               Get.snackbar("Info!", "Something went wrong!");
//                             }
//                           }
//                         },
//                         tooltip: 'Pick Image',
//                         child: Icon(Icons.add_a_photo),
//                       ),
//                       SizedBox(width: 16),
//                       Container(
//                         width: 100,
//                         height: 100,
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.grey),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Center(
//                           child: clubController.logoUrl != null
//                               ? Image.network(
//                                   clubController.logoUrl!,
//                                   width: 50,
//                                   height: 50,
//                                   fit: BoxFit.cover,
//                                 )
//                               : Icon(Icons.image, size: 50, color: Colors.grey),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 20),
//                   // Switch for junior/youth team
//                   Row(
//                     children: [
//                       Text(
//                         'This is a junior/youth team',
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       Spacer(),
//                       Switch(
//                         value: clubController.isJuniorTeam.value,
//                         onChanged: (value) {
//                           clubController.isJuniorTeam.value = value;
//                         },
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 20),
//                   // Dropdown for sport selection
//                   Row(
//                     children: [
//                       Text(
//                         'Sport Selection',
//                         style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
//                       ),
//                       Spacer(),
//                       // Inside the Obx widget where the dropdowns are built
//                       Obx(() {
//                         print(
//                             'Selected Sport: ${clubController.selectedSport.value}');
//                         print(
//                             'Selected County: ${clubController.selectedCounty.value}');

//                         return DropdownButton<String>(
//                           value: clubController.selectedSport.value,
//                           items: clubController.sportsTypes.map((sport) {
//                             return DropdownMenuItem<String>(
//                               value: sport,
//                               child: Text(
//                                 sport,
//                                 style: GoogleFonts.nunito(
//                                     fontWeight: FontWeight.w400),
//                               ),
//                             );
//                           }).toList(),
//                           onChanged: (value) {
//                             clubController.selectedSport.value = value!;
//                           },
//                           hint: Text(
//                             'Select Sport',
//                             style:
//                                 GoogleFonts.nunito(fontWeight: FontWeight.w600),
//                           ),
//                         );
//                       }),

//                       Icon(Icons.arrow_forward_ios),
//                     ],
//                   ),
//                   SizedBox(height: 20),
//                   Row(
//                     children: [
//                       Text(
//                         'County of school',
//                         style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
//                       ),
//                       Spacer(),
//                       Obx(() {
//                         return DropdownButton<String>(
//                           value: clubController.selectedCounty.value,
//                           items: clubController.counties.map((county) {
//                             return DropdownMenuItem<String>(
//                               value: county,
//                               child: Text(
//                                 county,
//                                 style: GoogleFonts.nunito(
//                                     fontWeight: FontWeight.w200),
//                               ),
//                             );
//                           }).toList(),
//                           onChanged: (value) {
//                             clubController.selectedCounty.value = value!;
//                           },
//                           hint: Text(
//                             'Select County',
//                             style:
//                                 GoogleFonts.nunito(fontWeight: FontWeight.w600),
//                           ),
//                         );
//                       }),
//                     ],
//                   ),

//                   SizedBox(height: 20),
//                   // Text field for postal code
//                   Container(
//                     decoration: BoxDecoration(
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.5),
//                           spreadRadius: 1,
//                           blurRadius: 5,
//                           offset: Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     child: TextField(
//                       controller: clubController.postalCodeController,
//                       decoration: InputDecoration(
//                         hintText: 'Postal Zip',
//                         border: OutlineInputBorder(),
//                         enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(
//                             color: clubController.postalCodeFocusNode.hasFocus
//                                 ? Colors.blue
//                                 : Colors.grey.shade400,
//                             width: 1.0,
//                           ),
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide:
//                               BorderSide(color: Colors.blue, width: 2.0),
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   // Text field for contact email
//                   Container(
//                     decoration: BoxDecoration(
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.5),
//                           spreadRadius: 1,
//                           blurRadius: 5,
//                           offset: Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     child: TextField(
//                       controller: clubController.clubEmailController,
//                       decoration: InputDecoration(
//                         hintText: 'Contact Email',
//                         border: OutlineInputBorder(),
//                         enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(
//                             color: clubController.contactEmailFocusNode.hasFocus
//                                 ? Colors.blue
//                                 : Colors.grey.shade400,
//                             width: 1.0,
//                           ),
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide:
//                               BorderSide(color: Colors.blue, width: 2.0),
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                       ),
//                       keyboardType: TextInputType.emailAddress,
//                     ),
//                   ),
//                   SizedBox(height: 40),
//                   // Button to create club
//                   Container(
//                     decoration: BoxDecoration(
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.5),
//                           spreadRadius: 1,
//                           blurRadius: 5,
//                           offset: Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     child: ElevatedButton(
//                       onPressed: () async {
//                         // Generate a random ID for the new club
//                         String randomId = clubController.generateRandomString();

//                         // Create a new ClubTeamsData object with the form data
//                         final clubData = ClubTeamsData(
//                           id: randomId,
//                           //clubType: clubController.clubType!,
//                           contactEmail:
//                               clubController.clubEmailController!.text,
//                           logoUrl: clubController.logoUrl!,
//                           county: clubController.selectedCounty.value,
//                           isJuniorTeam: clubController.isJuniorTeam.value,
//                           name: clubController.nameController!.text,
//                           postalZip: clubController.postalCodeController!.text,
//                           sport: clubController.selectedSport.value,
//                         );

//                         // Call the method to create a new club
//                         await clubController.createNewClub(
//                             clubData, GetStorage().read('phone_number') ?? "");
//                       },
//                       child: Text(
//                         'Create',
//                         style: GoogleFonts.nunito(),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         padding: EdgeInsets.symmetric(vertical: 10),
//                         elevation: 4,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(7)),
//                         textStyle: GoogleFonts.nunito(
//                             fontSize: 16, fontWeight: FontWeight.w900),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }
//       }),
//     );
//   }
// }





/*
class CreateSingleTeam extends StatelessWidget {
  CreateSingleTeam({Key? key}) : super(key: key);

  final ClubController clubController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Club',
          style: GoogleFonts.nunito(),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {}, icon: Icon(Icons.notifications_active_outlined))
        ],
      ),
      body: Obx(() {
        if (clubController.isLoading.value) {
          return Center(
              child: Column(
            children: [
              Text(
                "Processing request...",
                style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 15,
              ),
              CircularProgressIndicator(),
            ],
          ));
        } else {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 40),
                  // Text field for club name
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: clubController.nameController,
                      decoration: InputDecoration(
                        hintText:
                            'Name of your team, club, or organization (max 30 characters)',
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: clubController.nameFocusNode.hasFocus
                                ? Colors.blue
                                : Colors.grey.shade400,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Logo selection row
                  Row(
                    children: [
                      Text('Add Logo',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Spacer(),
                      FloatingActionButton(
                        onPressed: () async {
                          final pickedFile = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (pickedFile != null) {
                            final image = File(pickedFile.path);
                            final imageUrl = await clubController
                                .uploadImageToFirebaseStorage(image);
                            if (imageUrl != null) {
                              clubController.logoUrl = imageUrl;
                            } else {
                              Get.snackbar("Info!", "Something went wrong!");
                            }
                          }
                        },
                        tooltip: 'Pick Image',
                        child: Icon(Icons.add_a_photo),
                      ),
                      SizedBox(width: 16),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: clubController.logoUrl != null
                              ? Image.network(
                                  clubController.logoUrl!,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : Icon(Icons.image, size: 50, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Switch for junior/youth team
                  Row(
                    children: [
                      Text(
                        'This is a junior/youth team',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Switch(
                        value: clubController.isJuniorTeam.value,
                        onChanged: (value) {
                          clubController.isJuniorTeam.value = value;
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Dropdown for sport selection
                  Row(
                    children: [
                      Text(
                        'Sport Selection',
                        style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      // Inside the Obx widget where the dropdowns are built
                      Obx(() {
                        print(
                            'Selected Sport: ${clubController.selectedSport.value}');
                        print(
                            'Selected County: ${clubController.selectedCounty.value}');

                        return DropdownButton<String>(
                          value: clubController.selectedSport.value,
                          items: clubController.sportsTypes.map((sport) {
                            return DropdownMenuItem<String>(
                              value: sport,
                              child: Text(
                                sport,
                                style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.w400),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            clubController.selectedSport.value = value!;
                          },
                          hint: Text(
                            'Select Sport',
                            style:
                                GoogleFonts.nunito(fontWeight: FontWeight.w600),
                          ),
                        );
                      }),

                      Icon(Icons.arrow_forward_ios),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        'County of school',
                        style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Obx(() {
                        return DropdownButton<String>(
                          value: clubController.selectedCounty.value,
                          items: clubController.counties.map((county) {
                            return DropdownMenuItem<String>(
                              value: county,
                              child: Text(
                                county,
                                style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.w200),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            clubController.selectedCounty.value = value!;
                          },
                          hint: Text(
                            'Select County',
                            style:
                                GoogleFonts.nunito(fontWeight: FontWeight.w600),
                          ),
                        );
                      }),
                    ],
                  ),

                  SizedBox(height: 20),
                  // Text field for postal code
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: clubController.postalCodeController,
                      decoration: InputDecoration(
                        hintText: 'Postal Zip',
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: clubController.postalCodeFocusNode.hasFocus
                                ? Colors.blue
                                : Colors.grey.shade400,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Text field for contact email
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: clubController.clubEmailController,
                      decoration: InputDecoration(
                        hintText: 'Contact Email',
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: clubController.contactEmailFocusNode.hasFocus
                                ? Colors.blue
                                : Colors.grey.shade400,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  SizedBox(height: 40),
                  // Button to create club
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () async {
                        // Generate a random ID for the new club
                        String randomId = clubController.generateRandomString();

                        // Create a new ClubTeamsData object with the form data
                        final clubData = ClubTeamsData(
                          id: randomId,
                          //clubType: clubController.clubType!,
                          contactEmail:
                              clubController.clubEmailController!.text,
                          logoUrl: clubController.logoUrl!,
                          county: clubController.selectedCounty.value,
                          isJuniorTeam: clubController.isJuniorTeam.value,
                          name: clubController.nameController!.text,
                          postalZip: clubController.postalCodeController!.text,
                          sport: clubController.selectedSport.value,
                        );

                        // Call the method to create a new club
                        await clubController.createNewClub(
                            clubData, GetStorage().read('phone_number') ?? "");
                      },
                      child: Text(
                        'Create',
                        style: GoogleFonts.nunito(),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7)),
                        textStyle: GoogleFonts.nunito(
                            fontSize: 16, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }),
    );
  }
}
*/

