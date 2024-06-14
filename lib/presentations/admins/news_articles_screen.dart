import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class CreateEventsSCreen extends StatelessWidget {
  const CreateEventsSCreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events Management',style: GoogleFonts.nunito(),),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(children: []),
    );
  }
}
