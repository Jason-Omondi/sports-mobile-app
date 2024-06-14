import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../presentations/admins/admin_profile_screen.dart';
import '../../presentations/admins/news_articles_screen.dart';
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
          //if user role form get storage == admin show below widget
          ListTile(
            title: Text(
              'News',
              style: GoogleFonts.nunito(),
            ),
            onTap: () {
              Get.to(() => CreateEventsSCreen());
            },
          ),
          if (GetStorage().read('user_role') == 'admin')
            ListTile(
              title: Text(
                'Profile',
                style: GoogleFonts.nunito(),
              ),
              onTap: () {
                // Navigate to manage screen after cheking userRole == admin from get storage
                Get.to(() => ManageAdmins());

                // get to user profile if userRoler == user
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
