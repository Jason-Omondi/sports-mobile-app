import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'controller/admin_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'controller/admin_controller.dart'; // Import your AdminController
import '../../../data/models/equipment_model.dart'; // Import your Equipment model


class EquipmentScreen extends StatefulWidget {
  final String teamId; // Add teamId as a parameter
  const EquipmentScreen({Key? key, required this.teamId}) : super(key: key);

  @override
  State<EquipmentScreen> createState() => _EquipmentScreenState();
}

class _EquipmentScreenState extends State<EquipmentScreen> {
  final AdminController adminController = Get.find();
  final _formKey = GlobalKey<FormState>();
  TextEditingController equipmentNameController = TextEditingController();
  TextEditingController equipmentTypeController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  @override
  void dispose() {
    equipmentNameController.dispose();
    equipmentTypeController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  void _createEquipment() {
    if (_formKey.currentState!.validate()) {
      // Create equipment instance
      // Equipment equipment = Equipment(
      //   teamId: widget.teamId,
      //   equipmentName: equipmentNameController.text.trim(),
      //   equipmentType: equipmentTypeController.text.trim(),
      //   quantity: int.parse(quantityController.text.trim()),
      //   // You may add more fields here as needed
      // );

      // Call controller method to create equipment
     // adminController.createEquipment(equipment);

      // Optionally, you can navigate back or show a success message
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Equipment',
          style: GoogleFonts.nunito(),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notification_add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: equipmentNameController,
                decoration: InputDecoration(labelText: 'Equipment Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter equipment name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: equipmentTypeController,
                decoration: InputDecoration(labelText: 'Equipment Type'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter equipment type';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter quantity';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: _createEquipment,
                child: Text('Create Equipment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
