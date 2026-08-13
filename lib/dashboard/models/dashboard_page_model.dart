import 'package:flutter/material.dart';

enum DashboardPageKind {
  overview,
  myJobs,
  postJob,
  myProposals,
  invitations,
  offersReceived,
  offersSent,
  contracts,
  payouts,
  messages,
  notifications,
  freelancerProfile,
  clientProfile,
  securitySessions,
}

class DashboardNavItem {
  const DashboardNavItem({
    required this.label,
    required this.route,
    required this.kind,
  });

  final String label;
  final String route;
  final DashboardPageKind kind;
}

class DashboardPageModel {
  const DashboardPageModel({
    required this.kind,
    required this.title,
    required this.route,
    this.description,
    this.emptyIcon,
    this.emptyTitle,
    this.emptyBody,
    this.primaryActionLabel,
  });

  final DashboardPageKind kind;
  final String title;
  final String route;
  final String? description;
  final IconData? emptyIcon;
  final String? emptyTitle;
  final String? emptyBody;
  final String? primaryActionLabel;
}
