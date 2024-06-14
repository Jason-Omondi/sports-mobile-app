import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateUserScreen extends StatelessWidget {
  const CreateUserScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create New Admin',
          style: GoogleFonts.nunito(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildFormField('First Name', Colors.indigo, Colors.white),
            SizedBox(height: 24),
            _buildFormField('Last Name', Colors.indigo, Colors.white),
            SizedBox(height: 24),
            _buildFormField('Email', Colors.indigo, Colors.white),
            SizedBox(height: 24),
            _buildFormField('Phone Number', Colors.indigo, Colors.white),
            SizedBox(height: 24),
            //_buildFormField('Image URL', Colors.indigo, Colors.white),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Handle user creation logic here
              },
              child: Text(
                'Create Admin',
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 60),
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField(String labelText, Color bgColor, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: bgColor.withOpacity(0.2),
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
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: TextStyle(
                color: textColor.withOpacity(0.7),
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
              border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: textColor,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(40),
              ),
              prefixIcon: Icon(
                Icons.edit,
                color: textColor,
                size: 24,
              ),
            ),
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}
