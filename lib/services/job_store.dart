import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostedJob {
  PostedJob({
    required this.id,
    required this.title,
    required this.description,
    this.deliverables = '',
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
    this.questionOne = '',
    this.questionTwo = '',
    this.questionThree = '',
  });

  final int id;
  final String title;
  final String description;
  final String deliverables;
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
  final String questionOne;
  final String questionTwo;
  final String questionThree;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'deliverables': deliverables,
      'timeAgo': timeAgo,
      'location': location,
      'category': category,
      'projectType': projectType,
      'fixedBudget': fixedBudget,
      'hourlyMin': hourlyMin,
      'hourlyMax': hourlyMax,
      'experienceLevel': experienceLevel,
      'expectedDuration': expectedDuration,
      'weeklyHours': weeklyHours,
      'visibility': visibility,
      'timezone': timezone,
      'skills': skills,
      'questionOne': questionOne,
      'questionTwo': questionTwo,
      'questionThree': questionThree,
    };
  }

  factory PostedJob.fromJson(Map<String, dynamic> json) {
    return PostedJob(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      deliverables: json['deliverables'] as String? ?? '',
      timeAgo: json['timeAgo'] as String? ?? 'Just now',
      location: json['location'] as String? ?? 'Anywhere',
      category: json['category'] as String? ?? 'Select a category',
      projectType: json['projectType'] as String? ?? 'Fixed price',
      fixedBudget: json['fixedBudget'] as String? ?? '',
      hourlyMin: json['hourlyMin'] as String? ?? '',
      hourlyMax: json['hourlyMax'] as String? ?? '',
      experienceLevel: json['experienceLevel'] as String? ?? 'Intermediate',
      expectedDuration: json['expectedDuration'] as String? ?? 'Not sure yet',
      weeklyHours: json['weeklyHours'] as String? ?? '',
      visibility: json['visibility'] as String? ?? 'Public - listed in search',
      timezone: json['timezone'] as String? ?? '',
      skills: (json['skills'] as List<dynamic>? ?? const [])
          .map((skill) => skill.toString())
          .toList(),
      questionOne: json['questionOne'] as String? ?? '',
      questionTwo: json['questionTwo'] as String? ?? '',
      questionThree: json['questionThree'] as String? ?? '',
    );
  }
}

class JobStore extends ChangeNotifier {
  JobStore._();

  static final JobStore instance = JobStore._();
  static const _storageKey = 'posted_jobs';

  final List<PostedJob> _jobs = [];
  bool _loaded = false;

  List<PostedJob> get jobs => List.unmodifiable(_jobs);

  Future<void> load() async {
    if (_loaded) return;
    _loaded = true;

    final prefs = await SharedPreferences.getInstance();
    final rawJobs = prefs.getStringList(_storageKey) ?? const [];
    _jobs
      ..clear()
      ..addAll(rawJobs.map(_decodeJob).whereType<PostedJob>());
    notifyListeners();
  }

  void addJob(PostedJob job) {
    _jobs.insert(0, job);
    _save();
    notifyListeners();
  }

  void clear() {
    _jobs.clear();
    _save();
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final rawJobs = _jobs.map((job) => jsonEncode(job.toJson())).toList();
    await prefs.setStringList(_storageKey, rawJobs);
  }

  PostedJob? _decodeJob(String rawJob) {
    try {
      final decoded = jsonDecode(rawJob);
      if (decoded is! Map<String, dynamic>) return null;
      return PostedJob.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }
}
