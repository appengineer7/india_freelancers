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

// NOTE: All names, companies and messages below are 100% placeholder /
// anonymized demo content — nothing here refers to a real person, a real
// client, or the app owner. Safe to show in screenshots, demos, app-store
// review, etc.
const _sampleChats = [
  ChatThread(
    name: 'Client A',
    company: 'Independent Client',
    project: 'Smart Home App Development',
    preview: 'You: Yes, that\'s possible — I\'ll take care of it.',
    time: '9:43 AM',
    initials: 'CA',
    starred: false,
    online: true,
    budget: 'Hourly | ₹1,500/hr',
    messages: [
      ChatMessage(
        text: 'Hello!',
        fromMe: true,
        time: '9:40 AM',
      ),
      ChatMessage(
        text: 'How are you doing?',
        fromMe: true,
        time: '9:41 AM',
      ),
      ChatMessage(
        text: 'Hi,\n\nI have a new app requirement for you.\n\nA simple app to control a smart device — turn it on and off remotely.',
        fromMe: false,
        time: '03:22 PM',
      ),
      ChatMessage(
        text: 'You will need a small IoT dev board to test and connect to it.\n\nDo you think this is something you can take on?',
        fromMe: false,
        time: '03:25 PM',
        imageUrl: 'https://images.unsplash.com/photo-1555664424-778a1e5e1b48?auto=format&fit=crop&q=80&w=250',
      ),
      ChatMessage(
        text: 'Yes, that\'s possible — I\'ll take care of it.\n\nI\'ll order the board today.',
        fromMe: true,
        time: '06:13 AM',
        isEdited: true,
        replyText: 'You will need a small IoT dev board to test and connect to it.',
        replySenderInitials: 'CA',
        replySenderName: 'Client A',
      ),
    ],
  ),
  ChatThread(
    name: 'Client B',
    company: 'Sample Business Co.',
    project: 'Website Redesign Project',
    preview: 'Client B: Thanks a lot!',
    time: 'Tuesday',
    initials: 'CB',
    starred: false,
    online: true,
    budget: 'Fixed-price | ₹42,000',
    messages: [
      ChatMessage(
        text: 'Hi, can we get the landing page updated today?',
        fromMe: false,
        time: '9:42 AM',
      ),
      ChatMessage(
        text: 'Sure, I\'ll start with the hero and pricing sections.',
        fromMe: true,
        time: '9:46 AM',
      ),
      ChatMessage(text: 'Thanks a lot!', fromMe: false, time: '9:48 AM'),
    ],
  ),
  ChatThread(
    name: 'Client C',
    company: 'Demo Studio',
    project: 'Mobile App Development Agreement',
    preview: 'You: How are you?',
    time: 'Monday',
    initials: 'CC',
    starred: true,
    online: true,
    budget: 'Hourly | ₹1,200/hr',
    messages: [
      ChatMessage(
        text: 'Can we go over the agreement before kickoff?',
        fromMe: false,
        time: 'Mon',
      ),
      ChatMessage(
        text: 'Sure — I\'ll mark out the delivery milestones clearly.',
        fromMe: true,
        time: 'Mon',
      ),
      ChatMessage(text: 'How are you?', fromMe: true, time: 'Mon'),
    ],
  ),
  ChatThread(
    name: 'Client D',
    company: 'Sample Client',
    project: 'Cloud Storage Debug & Completion',
    preview: 'You: How are you?',
    time: 'Monday',
    initials: 'CD',
    starred: true,
    online: false,
    budget: 'Hourly | ₹950/hr',
    messages: [
      ChatMessage(
        text: 'The cloud sync is failing on fresh installs.',
        fromMe: false,
        time: 'Mon',
      ),
      ChatMessage(
        text: 'Found the issue — it\'s in the container entitlement.',
        fromMe: true,
        time: 'Mon',
      ),
    ],
  ),
  ChatThread(
    name: 'Client E',
    company: 'Sample Client',
    project: 'Landing Page Project',
    preview: 'You: Can we have a call here?',
    time: '30/7/2026',
    initials: 'CE',
    starred: false,
    online: true,
    budget: 'Fixed-price | ₹18,000',
    messages: [
      ChatMessage(
        text: 'I need a clean quote page for lead capture.',
        fromMe: false,
        time: '30 Jul',
      ),
      ChatMessage(text: 'Can we have a call here?', fromMe: true, time: '30 Jul'),
    ],
  ),
  ChatThread(
    name: 'Client F',
    company: 'Independent Client',
    project: 'App Build & Support',
    preview: 'You: Could you confirm the access change?',
    time: '27/7/2026',
    initials: 'CF',
    starred: true,
    online: false,
    budget: 'Milestone | ₹72,000',
    messages: [
      ChatMessage(
        text:
        'Repo cleanup is done.\n\nVerified that the test suite passes successfully.\n\nTest Result:\n00:02 +4: All tests passed!\n\nThanks,',
        fromMe: false,
        time: '2:06 am',
      ),
      ChatMessage(
        text:
        'Hi,\n\nI noticed my access to the repository and the hosting project is no longer available.\n\nCould you confirm the access change?\n\nThanks!',
        fromMe: true,
        time: '11:40 am',
      ),
    ],
  ),
];