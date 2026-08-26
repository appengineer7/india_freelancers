class ChatMessage {
  const ChatMessage({
    required this.text,
    required this.fromMe,
    required this.time,
    this.imageUrl,
    this.replyText,
    this.replySenderInitials,
    this.replySenderName,
    this.isEdited = false,
  });

  final String text;
  final bool fromMe;
  final String time;
  final String? imageUrl;
  final String? replyText;
  final String? replySenderInitials;
  final String? replySenderName;
  final bool isEdited;
}

class ChatThread {
  const ChatThread({
    required this.name,
    required this.company,
    required this.project,
    required this.preview,
    required this.time,
    required this.initials,
    required this.starred,
    required this.online,
    required this.budget,
    required this.messages,
  });

  final String name;
  final String company;
  final String project;
  final String preview;
  final String time;
  final String initials;
  final bool starred;
  final bool online;
  final String budget;
  final List<ChatMessage> messages;
}