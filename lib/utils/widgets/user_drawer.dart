import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../presentations/users/clubs/club_categories.dart';
import 'package:sportsapp/presentations/intro_screen/splash_screen.dart';
import '../../presentations/login_screen/controller/login_controller.dart';

class CustomDrawer extends StatelessWidget {
  //final String imageUrl;
  BuildContext? context;

  CustomDrawer({required context, super.key});
  final LoginController loginController = Get.find();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _logout() async {
    try {
      await _auth.signOut();
      Get.offAll(SplashScreen());
      Get.snackbar(
        'Success',
        'You have been logged out',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        borderRadius: 10,
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 3),
        icon: Icon(Icons.logout, color: Colors.white),
        shouldIconPulse: true,
        isDismissible: true,
        forwardAnimationCurve: Curves.easeOutBack,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        borderRadius: 10,
        margin: EdgeInsets.all(10),
        duration: Duration(seconds: 3),
        icon: Icon(Icons.error, color: Colors.white),
        shouldIconPulse: true,
        isDismissible: true,
        forwardAnimationCurve: Curves.easeOutBack,
      );
    }
  }

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
              Get.to(() => ClubCategories(loginController: loginController));
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
            onTap: _logout,
          ),
        ],
      ),
    );
  }
}
