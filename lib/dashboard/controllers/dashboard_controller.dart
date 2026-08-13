import 'package:flutter/material.dart';

import '../models/dashboard_page_model.dart';

class DashboardController extends ChangeNotifier {
  DashboardController(this.page);

  final DashboardPageModel page;

  final jobTitleController = TextEditingController();
  final jobDescriptionController = TextEditingController();
  final deliverablesController = TextEditingController();
  final fixedBudgetController = TextEditingController();
  final hourlyMinController = TextEditingController();
  final hourlyMaxController = TextEditingController();
  final weeklyHoursController = TextEditingController();
  final timezoneController = TextEditingController();
  final questionOneController = TextEditingController();
  final questionTwoController = TextEditingController();
  final questionThreeController = TextEditingController();

  final freelancerNameController = TextEditingController(
    text: 'Creative UI/UX Designer',
  );
  final professionalTitleController = TextEditingController();
  final freelancerOverviewController = TextEditingController();
  final hourlyRateController = TextEditingController();
  final weeklyCapacityController = TextEditingController();

  final clientProfileNameController = TextEditingController();
  final companyNameController = TextEditingController();
  final websiteController = TextEditingController();
  final industryController = TextEditingController();
  final clientAboutController = TextEditingController();

  String jobCategory = 'Select a category';
  String projectType = 'Fixed price';
  String experienceLevel = 'Intermediate';
  String expectedDuration = 'Not sure yet';
  String freelancerLocation = 'Anywhere';
  String visibility = 'Public - listed in search';
  String availability = 'Available now';
  String preferredProjectSize = 'Any';
  String primaryCategory = 'Select a category';
  String companySize = 'Select one';

  final Set<String> selectedJobSkills = {};
  final Set<String> selectedFreelancerSkills = {};

  void setProjectType(String value) {
    projectType = value;
    notifyListeners();
  }

  void setValue(String field, String value) {
    switch (field) {
      case 'jobCategory':
        jobCategory = value;
      case 'experienceLevel':
        experienceLevel = value;
      case 'expectedDuration':
        expectedDuration = value;
      case 'freelancerLocation':
        freelancerLocation = value;
      case 'visibility':
        visibility = value;
      case 'availability':
        availability = value;
      case 'preferredProjectSize':
        preferredProjectSize = value;
      case 'primaryCategory':
        primaryCategory = value;
      case 'companySize':
        companySize = value;
    }
    notifyListeners();
  }

  void toggleJobSkill(String skill, bool? selected) {
    _toggle(selectedJobSkills, skill, selected);
  }

  void toggleFreelancerSkill(String skill, bool? selected) {
    _toggle(selectedFreelancerSkills, skill, selected);
  }

  void _toggle(Set<String> target, String skill, bool? selected) {
    if (selected ?? false) {
      target.add(skill);
    } else {
      target.remove(skill);
    }
    notifyListeners();
  }

  void seedClientExample() {
    clientProfileNameController.text = 'Creative UI/UX Designer';
    companyNameController.text = 'Independent designer';
    industryController.text = 'Design and creative services';
    companySize = '2-10';
    clientAboutController.text =
        'Creative UI/UX Designer specializing in modern, user-friendly web and mobile app designs. Experienced in creating clean interfaces wireframes, prototypes, and responsive designs focused on delivering a great user experience.';
    notifyListeners();
  }

  @override
  void dispose() {
    jobTitleController.dispose();
    jobDescriptionController.dispose();
    deliverablesController.dispose();
    fixedBudgetController.dispose();
    hourlyMinController.dispose();
    hourlyMaxController.dispose();
    weeklyHoursController.dispose();
    timezoneController.dispose();
    questionOneController.dispose();
    questionTwoController.dispose();
    questionThreeController.dispose();
    freelancerNameController.dispose();
    professionalTitleController.dispose();
    freelancerOverviewController.dispose();
    hourlyRateController.dispose();
    weeklyCapacityController.dispose();
    clientProfileNameController.dispose();
    companyNameController.dispose();
    websiteController.dispose();
    industryController.dispose();
    clientAboutController.dispose();
    super.dispose();
  }
}
