import 'package:flutter/material.dart';

import '../models/message_model.dart';

class MessagesController extends ChangeNotifier {
  MessagesController();

  final searchController = TextEditingController();
  final replyController = TextEditingController();

  String _searchQuery = '';
  int? _selectedChatIndex;

  String get searchQuery => _searchQuery;
  int? get selectedChatIndex => _selectedChatIndex;

  List<ChatThread> get chats => _sampleChats;

  List<ChatThread> get filteredChats {
    final query = _searchQuery.toLowerCase();
    if (query.isEmpty) return chats;

    return chats.where((chat) {
      return chat.name.toLowerCase().contains(query) ||
          chat.company.toLowerCase().contains(query) ||
          chat.project.toLowerCase().contains(query) ||
          chat.preview.toLowerCase().contains(query);
    }).toList();
  }

  ChatThread? get selectedChat {
    final index = _selectedChatIndex;
    if (index == null || index < 0 || index >= chats.length) return null;
    return chats[index];
  }

  void updateSearch(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  void openChat(ChatThread chat) {
    _selectedChatIndex = chats.indexOf(chat);
    replyController.clear();
    notifyListeners();
  }

  void closeChat() {
    _selectedChatIndex = null;
    notifyListeners();
  }

  void clearReply() {
    replyController.clear();
  }

  @override
  void dispose() {
    searchController.dispose();
    replyController.dispose();
    super.dispose();
  }
}

const _sampleChats = [
  ChatThread(
    name: 'David Courtney',
    company: 'Independent Client',
    project: 'Smart Home IoT App Development',
    preview: 'You: Yes its possible and will do.',
    time: '9:43 AM',
    initials: 'DC',
    starred: false,
    online: true,
    budget: 'Hourly | ₹1,500/hr',
    messages: [
      ChatMessage(
        text: 'Hi David',
        fromMe: true,
        time: '9:40 AM',
      ),
      ChatMessage(
        text: 'How are you?',
        fromMe: true,
        time: '9:41 AM',
      ),
      ChatMessage(
        text: 'Hi Pavan,\n\nI have a new app for you.\n\nSimple app that needs to control a heater to turn it on and off',
        fromMe: false,
        time: '03:22 PM',
      ),
      ChatMessage(
        text: 'But you will need to buy a ESP32 wifi / bluetooth board to test it and connect to it\n\nDo you think this is something you can do?',
        fromMe: false,
        time: '03:25 PM',
        imageUrl: 'https://images.unsplash.com/photo-1555664424-778a1e5e1b48?auto=format&fit=crop&q=80&w=250',
      ),
      ChatMessage(
        text: 'Yes its possible and will do.\n\nI will buy',
        fromMe: true,
        time: '06:13 AM',
        isEdited: true,
        replyText: 'But you will need to buy a ESP32 wifi / bluetooth board to test it and connect to it',
        replySenderInitials: 'DC',
        replySenderName: 'David Courtney',
      ),
    ],
  ),
  ChatThread(
    name: 'William Christofi',
    company: 'Trojan Smart Locks',
    project: 'Create website for Trojan smart locks',
    preview: 'William: Thanks mate',
    time: 'Tuesday',
    initials: 'WC',
    starred: false,
    online: true,
    budget: 'Fixed-price | ₹42,000',
    messages: [
      ChatMessage(
        text: 'Hi, can you update the smart lock landing page today?',
        fromMe: false,
        time: '9:42 AM',
      ),
      ChatMessage(
        text: 'Yes William, I can start with the hero and pricing sections.',
        fromMe: true,
        time: '9:46 AM',
      ),
      ChatMessage(text: 'Thanks mate', fromMe: false, time: '9:48 AM'),
    ],
  ),
  ChatThread(
    name: 'Greg Quinn',
    company: 'Pixacast',
    project: 'Mobile App Development Agreement - Pure Edge',
    preview: 'You: How are you?',
    time: 'Monday',
    initials: 'GQ',
    starred: true,
    online: true,
    budget: 'Hourly | ₹1,200/hr',
    messages: [
      ChatMessage(
        text: 'Can we review the agreement before kickoff?',
        fromMe: false,
        time: 'Mon',
      ),
      ChatMessage(
        text: 'Sure. I will mark the delivery milestones clearly.',
        fromMe: true,
        time: 'Mon',
      ),
      ChatMessage(text: 'How are you?', fromMe: true, time: 'Mon'),
    ],
  ),
  ChatThread(
    name: 'Jackson Davis',
    company: 'Jackson D',
    project: 'CloudKit storage debug and completion',
    preview: 'You: How are you?',
    time: 'Monday',
    initials: 'JD',
    starred: true,
    online: false,
    budget: 'Hourly | ₹950/hr',
    messages: [
      ChatMessage(
        text: 'The CloudKit sync is failing on fresh installs.',
        fromMe: false,
        time: 'Mon',
      ),
      ChatMessage(
        text: 'I found the issue. It is in the container entitlement.',
        fromMe: true,
        time: 'Mon',
      ),
    ],
  ),
  ChatThread(
    name: 'Esma Platnumz',
    company: 'Esma P',
    project: 'Roofing',
    preview: 'You: can we have call here?',
    time: '30/7/2026',
    initials: 'EP',
    starred: false,
    online: true,
    budget: 'Fixed-price | ₹18,000',
    messages: [
      ChatMessage(
        text: 'I need a clean quote page for roofing leads.',
        fromMe: false,
        time: '30 Jul',
      ),
      ChatMessage(text: 'Can we have call here?', fromMe: true, time: '30 Jul'),
    ],
  ),
  ChatThread(
    name: 'Kevin Ross',
    company: 'Independent client',
    project: 'Relationship & Coaching App Build',
    preview: 'You: Hi Kevin, I reviewed the scope.',
    time: '27/7/2026',
    initials: 'KR',
    starred: true,
    online: false,
    budget: 'Milestone | ₹72,000',
    messages: [
      ChatMessage(
        text:
            'Build.gradle.kts.bak was removed from the repository.\n\nVerified that flutter test passes successfully.\n\nTerminal Output:\nThe following plugins do not support Swift Package Manager for iOS:\n- printing\n- open_filex\n- flutter_tts\n- flutter_local_notifications\n- flutter_facebook_auth\n\nThe following plugins do not support Swift Package Manager for macOS:\n- printing\n- flutter_tts\n- flutter_local_notifications\n- facebook_auth_desktop\n\nThese are plugin maintainer warnings for future Flutter versions and do not affect the current build.\n\nTest Result:\n00:02 +4: All tests passed!\n\nBest,\nPavan',
        fromMe: false,
        time: '2:06 am GMT-05:00',
      ),
      ChatMessage(
        text:
            'Hi Kevin,\n\nI noticed that my access to both the GitHub repository and the Railway project is no longer available.\n\nCould you please confirm that you removed my access from both GitHub and Railway?\n\nThanks!',
        fromMe: true,
        time: '11:40 am',
      ),
    ],
  ),
];
