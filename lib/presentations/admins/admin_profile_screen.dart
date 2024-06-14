import 'package:get/get.dart';
import 'create_admin_screen.dart';
import 'package:flutter/material.dart';
import '../../data/models/users_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sportsapp/presentations/login_screen/controller/login_controller.dart';


class ManageAdmins extends StatefulWidget {
  const ManageAdmins({Key? key});

  @override
  State<ManageAdmins> createState() => _ManageAdminsState();
}

class _ManageAdminsState extends State<ManageAdmins> {
  final LoginController loginController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Users> adminUsers = loginController.adminUsersList;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Admins',
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
            Expanded(
              child: ListView.builder(
                itemCount: adminUsers.length + 1,
                itemBuilder: (context, index) {
                  if (index == adminUsers.length) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Get.to(() => CreateUserScreen());
                        },
                        icon: Icon(Icons.add),
                        label: Text('Create New Admin'),
                      ),
                    );
                  }

                  Users user = adminUsers[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(user.imageUrl),
                                ),
                                SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${user.firstName} ${user.lastName}',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      user.email,
                                      style: GoogleFonts.nunito(),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Phone: ${user.phoneNumber}',
                                      style: GoogleFonts.nunito(),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'User Role: ${user.userRole}',
                                      style: GoogleFonts.nunito(),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: Icon(Icons.edit),
                                  label: Text('Edit'),
                                ),
                                SizedBox(width: 8),
                                ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: Icon(Icons.delete),
                                  label: Text('Delete'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
