import 'package:flutter/foundation.dart';

class PostedJob {
  PostedJob({
    required this.id,
    required this.title,
    required this.description,
    required this.timeAgo,
    required this.location,
    required this.category,
    required this.projectType,
    required this.fixedBudget,
    required this.hourlyMin,
    required this.hourlyMax,
    required this.experienceLevel,
    required this.expectedDuration,
    required this.weeklyHours,
    required this.visibility,
    required this.timezone,
    required this.skills,
  });

  final int id;
  final String title;
  final String description;
  final String timeAgo;
  final String location;

  // Additional fields captured from the post form
  final String category;
  final String projectType;
  final String fixedBudget;
  final String hourlyMin;
  final String hourlyMax;
  final String experienceLevel;
  final String expectedDuration;
  final String weeklyHours;
  final String visibility;
  final String timezone;
  final List<String> skills;
}

class JobStore extends ChangeNotifier {
  JobStore._();

  static final JobStore instance = JobStore._();

  final List<PostedJob> _jobs = [];

  List<PostedJob> get jobs => List.unmodifiable(_jobs);

  void addJob(PostedJob job) {
    _jobs.insert(0, job);
    notifyListeners();
  }

  void clear() {
    _jobs.clear();
    notifyListeners();
  }
}
