import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'admin_announcments_list.dart';
import 'package:flutter/material.dart';
import 'controller/admin_controller.dart';
import '../../data/models/events_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import '../users/clubs/controller/clubs_controller.dart';

class CreateEventsScreen extends StatefulWidget {
  @override
  _CreateEventsScreenState createState() => _CreateEventsScreenState();
}

class _CreateEventsScreenState extends State<CreateEventsScreen> {
  final AdminController controller = Get.find<AdminController>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController targetAudienceController =
      TextEditingController();
  final TextEditingController offerDetailsController = TextEditingController();
  final TextEditingController campaignGoalsController = TextEditingController();
  final RxString selectedType = 'match'.obs;
  final RxString selectedFixtureId = ''.obs;
  final RxList<String> selectedChannels = <String>[].obs;
  final Rx<DateTime> startDate = DateTime.now().obs;
  final Rx<DateTime> endDate = DateTime.now().add(Duration(days: 7)).obs;

  final List<String> channelOptions = [
    'Email',
    'Social Media',
    'Push Notification'
  ];

  bool _showEventsText = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Announcement', style: GoogleFonts.nunito()),
        centerTitle: true,
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
                SizedBox(height: 16),
                DropdownButton<String>(
                  value: selectedType.value,
                  items: ['match', 'promotion', 'campaign']
                      .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value.capitalize!),
                          ))
                      .toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      selectedType.value = newValue;
                    }
                  },
                ),
                SizedBox(height: 16),
                Obx(() => selectedType.value == 'match'
                    ? DropdownButton<String>(
                        value: selectedFixtureId.value.isNotEmpty
                            ? selectedFixtureId.value
                            : null,
                        hint: Text("Select a match"),
                        items: [
                          DropdownMenuItem<String>(
                            value: null,
                            child: Text("Select a match"),
                          ),
                          ...controller.clubController.fixtures.map((fixture) {
                            String team1Name = controller.clubController
                                .getTeamName(fixture.team1Id);
                            String team2Name = controller.clubController
                                .getTeamName(fixture.team2Id);
                            return DropdownMenuItem<String>(
                              value: fixture.fixtureId,
                              child: Text('$team1Name vs $team2Name'),
                            );
                          }).toList(),
                        ],
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            selectedFixtureId.value = newValue;
                          }
                        },
                      )
                    : SizedBox()),
                SizedBox(height: 16),
                Obx(() => selectedType.value != 'match'
                    ? Column(
                        children: [
                          TextField(
                            controller: targetAudienceController,
                            decoration:
                                InputDecoration(labelText: 'Target Audience'),
                          ),
                          SizedBox(height: 16),
                          if (selectedType.value == 'promotion')
                            TextField(
                              controller: offerDetailsController,
                              decoration:
                                  InputDecoration(labelText: 'Offer Details'),
                            ),
                          if (selectedType.value == 'campaign')
                            TextField(
                              controller: campaignGoalsController,
                              decoration:
                                  InputDecoration(labelText: 'Campaign Goals'),
                            ),
                          SizedBox(height: 16),
                          Text('Select Channels:'),
                          ...channelOptions.map((channel) => CheckboxListTile(
                                title: Text(channel),
                                value: selectedChannels.contains(channel),
                                onChanged: (bool? value) {
                                  if (value == true) {
                                    selectedChannels.add(channel);
                                  } else {
                                    selectedChannels.remove(channel);
                                  }
                                },
                              )),
                        ],
                      )
                    : SizedBox()),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: startDate.value,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                    );
                    if (picked != null) startDate.value = picked;
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Select Start Date'),
                      Text('${formatDate(startDate.value)}'),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: endDate.value,
                      firstDate: startDate.value,
                      lastDate: DateTime.now().add(Duration(days: 365)),
                    );
                    if (picked != null) endDate.value = picked;
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Select End Date'),
                      Text('${formatDate(endDate.value)}'),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    final announcement = Announcement(
                      id: '', // This will be set in the controller
                      title: titleController.text,
                      description: descriptionController.text,
                      type: selectedType.value,
                      startDate: startDate.value,
                      endDate: endDate.value,
                      createdBy:
                          controller.auth.currentUser?.email ?? 'Unknown',
                      fixtureId: selectedType.value == 'match'
                          ? selectedFixtureId.value
                          : null,
                      targetAudience: selectedType.value != 'match'
                          ? targetAudienceController.text
                          : null,
                      offerDetails: selectedType.value == 'promotion'
                          ? offerDetailsController.text
                          : null,
                      campaignGoals: selectedType.value == 'campaign'
                          ? campaignGoalsController.text
                          : null,
                      channels: selectedType.value != 'match'
                          ? selectedChannels
                          : null,
                    );
                    controller.createAnnouncement(announcement);
                  },
                  child: Text('Create Announcement'),
                ),
              ],
            ),
          ),
          if (_showEventsText)
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton.extended(
                onPressed: () {
                  Get.to(() => AnnouncementsScreen());
                },
                label: Text('All Events'),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Events',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.settings),
          //   label: 'Settings',
          // ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              // Navigate to Home screen
              Get.back();
              break;
            case 1:
              Get.to(() => AnnouncementsScreen());
              break;
            // case 2:
            //   // Navigate to Settings screen
            //   break;
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _showEventsText = !_showEventsText;
          });
        },
        child: Icon(Icons.toggle_on),
        tooltip: 'Toggle Events',
      ),
    );
  }

  String formatDate(DateTime date) {
    return DateFormat('MMM d, y').format(date);
  }
}


/*
class CreateEventsScreen extends StatelessWidget {
  final AdminController controller = Get.find<AdminController>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController targetAudienceController =
      TextEditingController();
  final TextEditingController offerDetailsController = TextEditingController();
  final TextEditingController campaignGoalsController = TextEditingController();
  final RxString selectedType = 'match'.obs;
  final RxString selectedFixtureId = ''.obs;
  final RxList<String> selectedChannels = <String>[].obs;
  final Rx<DateTime> startDate = DateTime.now().obs;
  final Rx<DateTime> endDate = DateTime.now().add(Duration(days: 7)).obs;

  final List<String> channelOptions = [
    'Email',
    'Social Media',
    'Push Notification'
  ];

  CreateEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Announcement', style: GoogleFonts.nunito()),
        centerTitle: true,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Processing...'),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(titleController, 'Title'),
              _buildTextField(descriptionController, 'Description',
                  maxLines: 3),
              SizedBox(height: 16),
              _buildTypeDropdown(),
              SizedBox(height: 16),
              Obx(() => selectedType.value == 'match'
                  ? _buildFixtureDropdown()
                  : SizedBox()),
              SizedBox(height: 16),
              Obx(() => selectedType.value != 'match'
                  ? _buildAdditionalFields()
                  : SizedBox()),
              SizedBox(height: 16),
              Row(
                children: [
                  _buildDateButton(
                      context, 'Select Start Date', startDate, true),
                  SizedBox(width: 8),
                  Expanded(
                      child: Text(
                          startDate.value.toLocal().toString().split(' ')[0])),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  _buildDateButton(context, 'Select End Date', endDate, false),
                  SizedBox(width: 8),
                  Expanded(
                      child: Text(
                          endDate.value.toLocal().toString().split(' ')[0])),
                ],
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  final announcement = Announcement(
                    id: '', // This will be set in the controller
                    title: titleController.text,
                    description: descriptionController.text,
                    type: selectedType.value,
                    startDate: startDate.value,
                    endDate: endDate.value,
                    createdBy: controller.auth.currentUser?.email ?? 'Unknown',
                    fixtureId: selectedType.value == 'match'
                        ? selectedFixtureId.value
                        : null,
                    targetAudience: selectedType.value != 'match'
                        ? targetAudienceController.text
                        : null,
                    offerDetails: selectedType.value == 'promotion'
                        ? offerDetailsController.text
                        : null,
                    campaignGoals: selectedType.value == 'campaign'
                        ? campaignGoalsController.text
                        : null,
                    channels:
                        selectedType.value != 'match' ? selectedChannels : null,
                  );
                  controller.createAnnouncement(announcement);
                },
                child: Text('Create Announcement'),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      maxLines: maxLines,
    );
  }

  Widget _buildTypeDropdown() {
    return DropdownButton<String>(
      value: selectedType.value,
      items: ['match', 'promotion', 'campaign']
          .map((String value) => DropdownMenuItem<String>(
                value: value,
                child: Text(value.capitalize!),
              ))
          .toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          selectedType.value = newValue;
        }
      },
    );
  }

  Widget _buildFixtureDropdown() {
    return DropdownButton<String>(
      value:
          selectedFixtureId.value.isNotEmpty ? selectedFixtureId.value : null,
      hint: Text("Select a match"),
      items: [
        DropdownMenuItem<String>(
          value: null,
          child: Text("Select a match"),
        ),
        ...controller.clubController.fixtures.map((fixture) {
          String team1Name =
              controller.clubController.getTeamName(fixture.team1Id);
          String team2Name =
              controller.clubController.getTeamName(fixture.team2Id);
          return DropdownMenuItem<String>(
            value: fixture.fixtureId,
            child: Text('$team1Name vs $team2Name'),
          );
        }).toList(),
      ],
      onChanged: (String? newValue) {
        if (newValue != null) {
          selectedFixtureId.value = newValue;
        }
      },
    );
  }

  Widget _buildAdditionalFields() {
    return Column(
      children: [
        _buildTextField(targetAudienceController, 'Target Audience'),
        SizedBox(height: 16),
        if (selectedType.value == 'promotion')
          _buildTextField(offerDetailsController, 'Offer Details'),
        if (selectedType.value == 'campaign')
          _buildTextField(campaignGoalsController, 'Campaign Goals'),
        SizedBox(height: 16),
        Text('Select Channels:'),
        ...channelOptions.map((channel) => CheckboxListTile(
              title: Text(channel),
              value: selectedChannels.contains(channel),
              onChanged: (bool? value) {
                if (value == true) {
                  selectedChannels.add(channel);
                } else {
                  selectedChannels.remove(channel);
                }
              },
            )),
      ],
    );
  }

  Widget _buildDateButton(
      BuildContext context, String text, Rx<DateTime> date, bool isStartDate) {
    return ElevatedButton(
      onPressed: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: date.value,
          firstDate: isStartDate ? DateTime.now() : startDate.value,
          lastDate: DateTime.now().add(Duration(days: 365)),
        );
        if (picked != null) date.value = picked;
      },
      child: Text(text),
    );
  }
}
*/