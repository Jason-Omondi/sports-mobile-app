import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../login_screen/login_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sportsapp/presentations/register_screen/controller/register_controller.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  final RegisterController controller = Get.put(RegisterController());

  final _formKey = GlobalKey<FormState>();

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmpasswordFocusNode = FocusNode();
  final FocusNode lnameFocusNode = FocusNode();
  final FocusNode fnameFocusNode = FocusNode();
  final FocusNode phoneNumberFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Obx(() {
                return controller.isLoading.value
                    ? CircularProgressIndicator()
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              height: 26,
                            ),
                            Center(
                              child: Text("Welcome to Sports Center",
                                  style: GoogleFonts.sanchez(fontSize: 25)),
                            ),
                            TextFormField(
                              controller: controller.firstnameController,
                              decoration: InputDecoration(
                                labelText: 'First Name',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: fnameFocusNode.hasFocus
                                        ? Colors.blue
                                        : Colors.grey.shade400,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 2.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your first name';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.0),
// Add similar TextFormField for Last Name
                            TextFormField(
                              controller: controller.lastnameController,
                              decoration: InputDecoration(
                                labelText: 'Last Name',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: lnameFocusNode.hasFocus
                                        ? Colors.blue
                                        : Colors.grey.shade400,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 2.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your last name';
                                }
                                return null;
                              },
                            ),

                            SizedBox(height: 16.0),
                            // Add similar TextFormField for Email
                            TextFormField(
                              controller: controller.emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: emailFocusNode.hasFocus
                                        ? Colors.blue
                                        : Colors.grey.shade400,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 2.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!GetUtils.isEmail(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.0),
                            // Add similar TextFormField for Phone Number
                            TextFormField(
                              controller: controller.phonenumberController,
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: phoneNumberFocusNode.hasFocus
                                        ? Colors.blue
                                        : Colors.grey.shade400,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 2.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your phone number';
                                }
                                // You can add additional validation for phone number here
                                return null;
                              },
                            ),
                            SizedBox(height: 16.0),
                            // Add similar TextFormField for Password
                            TextFormField(
                              controller: controller.passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: passwordFocusNode.hasFocus
                                        ? Colors.blue
                                        : Colors.grey.shade400,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 2.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(controller.obscurePassword.value
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    controller.obscurePassword.toggle();
                                  },
                                ),
                              ),
                              obscureText: controller.obscurePassword.value,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                // You can add additional validation for password here
                                return null;
                              },
                            ),
                            SizedBox(height: 16.0),
                            // Add similar TextFormField for Confirm Password
                            TextFormField(
                              controller: controller.confirmPasswordController,
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: confirmpasswordFocusNode.hasFocus
                                        ? Colors.blue
                                        : Colors.grey.shade400,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 2.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                      controller.obscureConfirmPassword.value
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                  onPressed: () {
                                    controller.obscureConfirmPassword.toggle();
                                  },
                                ),
                              ),
                              obscureText:
                                  controller.obscureConfirmPassword.value,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (value !=
                                    controller.passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.0),
                            // Add similar button for selecting profile picture
                            Center(
                                child: Text(
                              'Select a profile photo',
                              style: GoogleFonts.nunito(fontSize: 15),
                            )),
                            SizedBox(height: 10.0),
                            FloatingActionButton(
                              // Call method to pick image
                              onPressed: () async {
                                final XFile? pickedImage = await ImagePicker()
                                    .pickImage(source: ImageSource.gallery);
                                if (pickedImage == null) {
                                  // Handle case where no image is selected
                                  Get.snackbar(
                                    'Info!',
                                    'No image has been selected! Please select a profile picture to proceed!',
                                    duration: Duration(seconds: 7),
                                  );
                                } else {
                                  // Call method to upload image and save image URL
                                  final File imageFile = File(pickedImage.path);
                                  final String? uploadedImageUrl =
                                      await controller
                                          .uploadImageToFirebaseStorage(
                                              imageFile);
                                  if (uploadedImageUrl != null) {
                                    controller.imageUrl = uploadedImageUrl;
                                  } else {
                                    controller.isLoading = false as RxBool;
                                  }
                                  if (controller.imageUrl != null) {
                                    // Image uploaded successfully, save the image url somewere in a variable to use it during registeration
                                    Get.snackbar('Info!',
                                        'Photo uploaded! Proceed to login!');
                                  }
                                }
                              },

                              child: Icon(Icons.person_2_outlined),
                            ),
                            SizedBox(height: 16.0),
                            Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    // String? imageUrl = this.imageUrl;
                                    if (controller.imageUrl != null) {
                                      controller.register(
                                        controller.emailController.text,
                                        controller.passwordController.text,
                                        controller.imageUrl,
                                        controller.firstnameController.text,
                                        controller.lastnameController.text,
                                        controller.phonenumberController.text,
                                      );
                                      // controller.register(
                                      //   controller.emailController.text,
                                      //   controller.passwordController.text,
                                      //   imageUrl,
                                      //   controller.firstnameController.text,
                                      //   controller.lastnameController.text,
                                      //   controller.phonenumberController.text,
                                      // );
                                    }
                                  }
                                },
                                child: Text('Register'),
                              ),
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Already a member? ",
                                    style: GoogleFonts.nunito(fontSize: 16)),
                                TextButton(
                                  onPressed: () {
                                    Get.to(LoginScreen());
                                  },
                                  child: Text(
                                    'Login',
                                    style: GoogleFonts.nunito(
                                        color: Colors.blue, fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 26,
                            ),
                          ],
                        ),
                      );
              }),
            ),
          ),
        ),
      ),
    );
  }
}



// class RegisterScreen extends StatelessWidget {
//   RegisterScreen({Key? key}) : super(key: key);

//   final RegisterController controller = Get.put(RegisterController());

//   final _formKey = GlobalKey<FormState>();
//   String? imageUrl;
//   final FocusNode emailFocusNode = FocusNode();
//   final FocusNode passwordFocusNode = FocusNode();
//   final FocusNode confirmpasswordFocusNode = FocusNode();
//   final FocusNode lnameFocusNode = FocusNode();
//   final FocusNode fnameFocusNode = FocusNode();
//   final FocusNode phoneNumberFocusNode = FocusNode();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.grey, Colors.white],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Form(
//               key: _formKey,
//               child: Obx(() {
//                 return controller.isLoading.value
//                     ? CircularProgressIndicator()
//                     : SingleChildScrollView(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: [
//                             TextFormField(
//                               controller: controller.firstnameController,
//                               decoration: InputDecoration(
//                                 labelText: 'First Name',
//                                 enabledBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                     color: fnameFocusNode.hasFocus
//                                         ? Colors.blue
//                                         : Colors.grey.shade400,
//                                     width: 1.0,
//                                   ),
//                                   borderRadius: BorderRadius.circular(10.0),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                       color: Colors.blue, width: 2.0),
//                                   borderRadius: BorderRadius.circular(10.0),
//                                 ),
//                               ),
//                               keyboardType: TextInputType.text,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter your first name';
//                                 }
//                                 return null;
//                               },
//                             ),
//                             SizedBox(height: 16.0),
//                             // Add similar TextFormField for Last Name
//                             TextFormField(
//                               controller: controller.lastnameController,
//                               decoration: InputDecoration(
//                                 labelText: 'Last Name',
//                                 enabledBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                     color: lnameFocusNode.hasFocus
//                                         ? Colors.blue
//                                         : Colors.grey.shade400,
//                                     width: 1.0,
//                                   ),
//                                   borderRadius: BorderRadius.circular(10.0),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                       color: Colors.blue, width: 2.0),
//                                   borderRadius: BorderRadius.circular(10.0),
//                                 ),
//                               ),
//                               keyboardType: TextInputType.text,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter your last name';
//                                 }
//                                 return null;
//                               },
//                             ),
//                             SizedBox(height: 16.0),
//                             // Add similar TextFormField for Email
//                             TextFormField(
//                               controller: controller.emailController,
//                               decoration: InputDecoration(
//                                 labelText: 'Email',
//                                 enabledBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                     color: emailFocusNode.hasFocus
//                                         ? Colors.blue
//                                         : Colors.grey.shade400,
//                                     width: 1.0,
//                                   ),
//                                   borderRadius: BorderRadius.circular(10.0),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                       color: Colors.blue, width: 2.0),
//                                   borderRadius: BorderRadius.circular(10.0),
//                                 ),
//                               ),
//                               keyboardType: TextInputType.emailAddress,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter your email';
//                                 }
//                                 if (!GetUtils.isEmail(value)) {
//                                   return 'Please enter a valid email address';
//                                 }
//                                 return null;
//                               },
//                             ),
//                             SizedBox(height: 16.0),
//                             // Add similar TextFormField for Phone Number
//                             TextFormField(
//                               controller: controller.phonenumberController,
//                               decoration: InputDecoration(
//                                 labelText: 'Phone Number',
//                                 enabledBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                     color: phoneNumberFocusNode.hasFocus
//                                         ? Colors.blue
//                                         : Colors.grey.shade400,
//                                     width: 1.0,
//                                   ),
//                                   borderRadius: BorderRadius.circular(10.0),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                       color: Colors.blue, width: 2.0),
//                                   borderRadius: BorderRadius.circular(10.0),
//                                 ),
//                               ),
//                               keyboardType: TextInputType.phone,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter your phone number';
//                                 }
//                                 // You can add additional validation for phone number here
//                                 return null;
//                               },
//                             ),
//                             SizedBox(height: 16.0),
//                             // Add similar TextFormField for Password
//                             TextFormField(
//                               controller: controller.passwordController,
//                               decoration: InputDecoration(
//                                 labelText: 'Password',
//                                 enabledBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                     color: passwordFocusNode.hasFocus
//                                         ? Colors.blue
//                                         : Colors.grey.shade400,
//                                     width: 1.0,
//                                   ),
//                                   borderRadius: BorderRadius.circular(10.0),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                       color: Colors.blue, width: 2.0),
//                                   borderRadius: BorderRadius.circular(10.0),
//                                 ),
//                                 suffixIcon: IconButton(
//                                   icon: Icon(controller.obscurePassword.value
//                                       ? Icons.visibility
//                                       : Icons.visibility_off),
//                                   onPressed: () {
//                                     controller.obscurePassword.toggle();
//                                   },
//                                 ),
//                               ),
//                               obscureText: controller.obscurePassword.value,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please enter your password';
//                                 }
//                                 // You can add additional validation for password here
//                                 return null;
//                               },
//                             ),
//                             SizedBox(height: 16.0),
//                             // Add similar TextFormField for Confirm Password
//                             TextFormField(
//                               controller: controller.confirmPasswordController,
//                               decoration: InputDecoration(
//                                 labelText: 'Confirm Password',
//                                 enabledBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                     color: confirmpasswordFocusNode.hasFocus
//                                         ? Colors.blue
//                                         : Colors.grey.shade400,
//                                     width: 1.0,
//                                   ),
//                                   borderRadius: BorderRadius.circular(10.0),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                       color: Colors.blue, width: 2.0),
//                                   borderRadius: BorderRadius.circular(10.0),
//                                 ),
//                                 suffixIcon: IconButton(
//                                   icon: Icon(
//                                       controller.obscureConfirmPassword.value
//                                           ? Icons.visibility
//                                           : Icons.visibility_off),
//                                   onPressed: () {
//                                     controller.obscureConfirmPassword.toggle();
//                                   },
//                                 ),
//                               ),
//                               obscureText:
//                                   controller.obscureConfirmPassword.value,
//                               validator: (value) {
//                                 if (value == null || value.isEmpty) {
//                                   return 'Please confirm your password';
//                                 }
//                                 if (value !=
//                                     controller.passwordController.text) {
//                                   return 'Passwords do not match';
//                                 }
//                                 return null;
//                               },
//                             ),
//                             SizedBox(height: 16.0),
//                             // Add similar button for selecting profile picture
//                             Center(
//                                 child: Text(
//                               'Select a profile photo',
//                               style: GoogleFonts.nunito(fontSize: 15),
//                             )),
//                             SizedBox(height: 10.0),
//                             FloatingActionButton(
//                               onPressed: () async {
//                                 // Call method to upload image and save image URL
//                                 imageUrl = await controller
//                                     .uploadImageToFirebaseStorage();
//                                 if (imageUrl != null) {
//                                   // Image uploaded successfully, you can save the URL or handle it accordingly
//                                 } else {
//                                   // Handle case where no image is selected
//                                   Get.snackbar('Info!',
//                                       'No image has been selected! Please select a profile picture to proceed!',
//                                       duration: Duration(seconds: 7));
//                                 }
//                               },
//                               child: Icon(Icons.person_2_outlined),
//                             ),
//                             SizedBox(height: 16.0),
//                             Container(
//                               decoration: BoxDecoration(
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.grey.withOpacity(0.5),
//                                     spreadRadius: 1,
//                                     blurRadius: 5,
//                                     offset: Offset(
//                                         0, 3), // changes position of shadow
//                                   ),
//                                 ],
//                               ),
//                               child: ElevatedButton(
//                                 onPressed: () {
//                                   if (controller.isLoading.value) {
//                                     return;
//                                   }
//                                   if (_formKey.currentState!.validate()) {
//                                     // Call method to register user
//                                     // controller.registerUser();
//                                   }
//                                 },
//                                 child: Text('Register'),
//                               ),
//                             ),
//                             SizedBox(height: 16),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text("Already a member? ",
//                                     style: GoogleFonts.nunito(fontSize: 16)),
//                                 TextButton(
//                                   onPressed: () {
//                                     // Add action for navigating to signup screen
//                                     Get.to(LoginScreen());
//                                   },
//                                   child: Text(
//                                     'Login',
//                                     style: GoogleFonts.nunito(
//                                         color: Colors.blue, fontSize: 16),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       );
//               }),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }





/*
class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  final RegisterController controller = Get.put(RegisterController());

  final _formKey = GlobalKey<FormState>();
  String? imageUrl;
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmpasswordFocusNode = FocusNode();
  final FocusNode lnameFocusNode = FocusNode();
  final FocusNode fnameFocusNode = FocusNode();
  final FocusNode phoneNumberFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.grey, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Obx(() {
                return controller.isLoading.value
                    ? CircularProgressIndicator()
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              controller: controller.firstnameController,
                              decoration: InputDecoration(
                                labelText: 'First Name',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: fnameFocusNode.hasFocus
                                        ? Colors.blue
                                        : Colors.grey.shade400,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 2.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your first name';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.0),
                            // Add similar TextFormField for Last Name
                            TextFormField(
                              controller: controller.lastnameController,
                              decoration: InputDecoration(
                                labelText: 'Last Name',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: lnameFocusNode.hasFocus
                                        ? Colors.blue
                                        : Colors.grey.shade400,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 2.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your last name';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.0),
                            // Add similar TextFormField for Email
                            TextFormField(
                              controller: controller.emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: emailFocusNode.hasFocus
                                        ? Colors.blue
                                        : Colors.grey.shade400,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 2.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!GetUtils.isEmail(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.0),
                            // Add similar TextFormField for Phone Number
                            TextFormField(
                              controller: controller.phonenumberController,
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: phoneNumberFocusNode.hasFocus
                                        ? Colors.blue
                                        : Colors.grey.shade400,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 2.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your phone number';
                                }
                                // You can add additional validation for phone number here
                                return null;
                              },
                            ),
                            SizedBox(height: 16.0),
                            // Add similar TextFormField for Password
                            TextFormField(
                              controller: controller.passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: passwordFocusNode.hasFocus
                                        ? Colors.blue
                                        : Colors.grey.shade400,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 2.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(controller.obscurePassword.value
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    controller.obscurePassword.toggle();
                                  },
                                ),
                              ),
                              obscureText: controller.obscurePassword.value,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                // You can add additional validation for password here
                                return null;
                              },
                            ),
                            SizedBox(height: 16.0),
                            // Add similar TextFormField for Confirm Password
                            TextFormField(
                              controller: controller.confirmPasswordController,
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: confirmpasswordFocusNode.hasFocus
                                        ? Colors.blue
                                        : Colors.grey.shade400,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 2.0),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                      controller.obscureConfirmPassword.value
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                  onPressed: () {
                                    controller.obscureConfirmPassword.toggle();
                                  },
                                ),
                              ),
                              obscureText:
                                  controller.obscureConfirmPassword.value,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (value !=
                                    controller.passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.0),
                            // Add similar button for selecting profile picture
                            Center(
                                child: Text(
                              'Select a profile photo',
                              style: GoogleFonts.nunito(fontSize: 15),
                            )),
                            SizedBox(height: 10.0),
                            FloatingActionButton(
                              onPressed: () async {
                                // Call method to upload image and save image URL
                                imageUrl = await controller
                                    .uploadImageToFirebaseStorage();
                                if (imageUrl != null) {
                                  // Image uploaded successfully, you can save the URL or handle it accordingly
                                } else {
                                  // Handle case where no image is selected
                                  Get.snackbar('Info!',
                                      'No image has been selected! Please select a profile picture to proceed!',
                                      duration: Duration(seconds: 7));
                                }
                              },
                              child: Icon(Icons.person_2_outlined),
                            ),
                            SizedBox(height: 16.0),
                            Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (controller.isLoading.value) {
                                    return;
                                  }
                                  if (_formKey.currentState!.validate()) {
                                    // Call method to register user
                                    // controller.registerUser();
                                  }
                                },
                                child: Text('Register'),
                              ),
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Already a member? ",
                                    style: GoogleFonts.nunito(fontSize: 16)),
                                TextButton(
                                  onPressed: () {
                                    // Add action for navigating to signup screen
                                    Get.to(LoginScreen());
                                  },
                                  child: Text(
                                    'Login',
                                    style: GoogleFonts.nunito(
                                        color: Colors.blue, fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
*/