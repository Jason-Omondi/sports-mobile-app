import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'controller/admin_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';



class CreateUserScreen extends StatelessWidget {
  CreateUserScreen({Key? key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AdminController controller = Get.put(AdminController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Admin',
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 161, 190, 188), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildFormField(
                    'First Name',
                    Icons.person,
                    Colors.white24,
                    Colors.black,
                    controller.firstNameController,
                    controller.fnameFocusNode,
                  ),
                  SizedBox(height: 24),
                  _buildFormField(
                    'Last Name',
                    Icons.person_3_outlined,
                    Colors.white24,
                    Colors.black,
                    controller.lastNameController,
                    controller.lnameFocusNode,
                  ),
                  SizedBox(height: 24),
                  _buildFormField(
                    'Email',
                    Icons.email,
                    Colors.white24,
                    Colors.black,
                    controller.emailController,
                    controller.emailFocusNode,
                  ),
                  SizedBox(height: 24),
                  _buildFormField(
                    'Phone Number',
                    Icons.phone,
                    Colors.white24,
                    Colors.black,
                    controller.phoneNumberController,
                    controller.phoneNumberFocusNode,
                  ),
                  SizedBox(height: 24),
                  _buildPasswordFormField(
                    'Password',
                    controller.passwordController,
                    controller.passwordFocusNode,
                    controller.obscurePassword,
                  ),
                  SizedBox(height: 16.0),
                  _buildPasswordFormField(
                    'Confirm Password',
                    controller.confirmPasswordController,
                    controller.confirmpasswordFocusNode,
                    controller.obscureConfirmPassword,
                  ),
                  SizedBox(height: 16.0),
                  Center(
                    child: Text(
                      'Select a profile photo',
                      style: GoogleFonts.nunito(fontSize: 15),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  FloatingActionButton(
                    onPressed: () async {
                      final XFile? pickedImage = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      if (pickedImage == null) {
                        Get.snackbar(
                          'Info!',
                          'No image has been selected! Please select a profile picture to proceed!',
                          duration: Duration(seconds: 7),
                        );
                      } else {
                        final File imageFile = File(pickedImage.path);
                        final String? uploadedImageUrl = await controller
                            .uploadImageToFirebaseStorage(imageFile);
                        if (uploadedImageUrl != null) {
                          controller.imageUrl = uploadedImageUrl;
                        } else {
                          controller.isLoading = false as RxBool;
                        }
                        if (controller.imageUrl != null) {
                          Get.snackbar(
                              'Info!', 'Photo uploaded! Proceed to login!');
                        }
                      }
                    },
                    child: Icon(Icons.person_2_outlined),
                  ),
                  SizedBox(height: 16.0),
                  SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          controller.createAdmin(
                            controller.emailController.text,
                            controller.passwordController.text,
                            controller.imageUrl,
                            controller.firstNameController.text,
                            controller.lastNameController.text,
                            controller.phoneNumberController.text,
                          );
                        }
                      },
                      child: Text(
                        'Create Admin',
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 60),
                        backgroundColor: Colors.teal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField(
    String labelText,
    IconData prefixIcon,
    Color bgColor,
    Color textColor,
    TextEditingController controller,
    FocusNode focusNode,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
          color: bgColor,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: TextStyle(
                color: textColor.withOpacity(0.7),
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
              border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: textColor,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(40),
              ),
              prefixIcon: Icon(
                prefixIcon,
                color: textColor,
                size: 24,
              ),
            ),
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $labelText';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordFormField(
    String labelText,
    TextEditingController controller,
    FocusNode focusNode,
    RxBool obscureText,
  ) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
          color: Colors.white24,
        ),
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: labelText,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: focusNode.hasFocus ? Colors.blue : Colors.grey.shade400,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue, width: 2.0),
              borderRadius: BorderRadius.circular(10.0),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                  obscureText.value ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                obscureText.toggle();
              },
            ),
          ),
          obscureText: obscureText.value,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your $labelText';
            }
            if (labelText == 'Confirm Password' && value != controller.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
      ),
    );
  }
}


