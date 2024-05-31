import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../presentations/users/clubs/new_club.dart';
import '../../presentations/login_screen/controller/login_controller.dart';

class CustomDrawer extends StatelessWidget {
  //final String imageUrl;
  BuildContext? context;

  CustomDrawer({required context, super.key});
  final LoginController loginController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              'Welcome, ${GetStorage().read('first_name') ?? ""} ${GetStorage().read('last_name') ?? ""}!',
              style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
            ),
            accountEmail: null,
            currentAccountPicture: CircleAvatar(
              backgroundImage:
                  NetworkImage(GetStorage().read('image_url') ?? ""),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text(
              'Clubs',
              style: GoogleFonts.nunito(),
            ),
            onTap: () {
              // Navigate to Clubs screen
              Get.to(() => CreateNewClub(loginController: loginController));
            },
          ),
          ListTile(
            title: Text(
              'News',
              style: GoogleFonts.nunito(),
            ),
            onTap: () {
              // Navigate to News screen
            },
          ),
          ListTile(
            title: Text(
              'Settings',
              style: GoogleFonts.nunito(),
            ),
            onTap: () {
              // Navigate to Settings screen
            },
          ),
          ListTile(
            title: Text(
              'FAQs',
              style: GoogleFonts.nunito(),
            ),
            onTap: () {
              // Navigate to FAQs screen
            },
          ),
          ListTile(
            title: Text(
              'Logout',
              style: GoogleFonts.nunito(),
            ),
            onTap: () {
              // Perform logout
            },
          ),
        ],
      ),
    );
  }
}
