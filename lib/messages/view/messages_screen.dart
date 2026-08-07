import 'package:flutter/material.dart';

import '../../core/site_shell.dart';
import '../../home/view/home_screen.dart';
import '../bindings/messages_binding.dart';
import '../models/message_model.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MessagesBinding(
      child: Builder(
        builder: (context) {
          final controller = MessagesBinding.of(context);
          return ListenableBuilder(
            listenable: controller,
            builder: (context, _) {
              final selectedChat = controller.selectedChat;

              return LayoutBuilder(
                builder: (context, constraints) {
                  final isWideScreen = constraints.maxWidth >= 768;

                  if (isWideScreen) {
                    // Desktop / Web Split View
                    final activeChat = selectedChat ?? controller.chats.first;

                    return AppScaffold(
                      currentRoute: '/messages',
                      body: Container(
                        color: Colors.white,
                        child: Row(
                          children: [
                            // Left Chat Sidebar
                            SizedBox(
                              width: 360,
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    right: BorderSide(
                                      color: AppColors.cardBorder,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: _MessagesSidebar(
                                  searchController: controller.searchController,
                                  filteredChats: controller.filteredChats,
                                  selectedChat: activeChat,
                                  onSearchChanged: controller.updateSearch,
                                  onOpenChat: controller.openChat,
                                ),
                              ),
                            ),

                            // Right Conversation Detail Pane
                            Expanded(
                              child: Container(
                                color: Colors.white,
                                child: _ChatDetailPane(
                                  chat: activeChat,
                                  replyController: controller.replyController,
                                  isDesktop: true,
                                  onBack: controller.closeChat,
                                  onSend: controller.clearReply,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Mobile Single-Pane View
                  return PopScope(
                    canPop: selectedChat == null,
                    onPopInvokedWithResult: (didPop, _) {
                      if (!didPop && selectedChat != null) {
                        controller.closeChat();
                      }
                    },
                    child: selectedChat == null
                        ? AppScaffold(
                            currentRoute: '/messages',
                            body: _MessagesSidebar(
                              searchController: controller.searchController,
                              filteredChats: controller.filteredChats,
                              selectedChat: null,
                              onSearchChanged: controller.updateSearch,
                              onOpenChat: controller.openChat,
                            ),
                          )
                        : Scaffold(
                            backgroundColor: Colors.white,
                            body: SafeArea(
                              child: _ChatDetailPane(
                                chat: selectedChat,
                                replyController: controller.replyController,
                                isDesktop: false,
                                onBack: controller.closeChat,
                                onSend: controller.clearReply,
                              ),
                            ),
                          ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _MessagesSidebar extends StatefulWidget {
  const _MessagesSidebar({
    required this.searchController,
    required this.filteredChats,
    required this.selectedChat,
    required this.onSearchChanged,
    required this.onOpenChat,
  });

  final TextEditingController searchController;
  final List<ChatThread> filteredChats;
  final ChatThread? selectedChat;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<ChatThread> onOpenChat;

  @override
  State<_MessagesSidebar> createState() => _MessagesSidebarState();
}

class _MessagesSidebarState extends State<_MessagesSidebar> {
  String _activeTab = 'Inbox';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Sidebar Top Header
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: AppColors.cardBorder)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Field Row with Filter Icon
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.cream50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: TextField(
                        controller: widget.searchController,
                        onChanged: widget.onSearchChanged,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.navy,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search messages',
                          hintStyle: const TextStyle(
                            color: AppColors.ink500,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            color: AppColors.ink500,
                            size: 19,
                          ),
                          suffixIcon: widget.searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.close_rounded, size: 16),
                                  color: AppColors.ink500,
                                  onPressed: () {
                                    widget.searchController.clear();
                                    widget.onSearchChanged('');
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.tune_rounded, size: 22),
                    color: AppColors.green,
                    tooltip: 'Filter chats',
                    onPressed: () => _openFilterModal(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Filter Tabs (Inbox / Rooms / Starred)
              Row(
                children: [
                  _buildTabPill('Inbox'),
                  const SizedBox(width: 6),
                  _buildTabPill('Rooms'),
                  const SizedBox(width: 6),
                  _buildTabPill('Starred'),
                ],
              ),
            ],
          ),
        ),

        // Chat List
        Expanded(
          child: widget.filteredChats.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline_rounded,
                          size: 40,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'No messages found',
                          style: TextStyle(
                            color: AppColors.ink500,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: widget.filteredChats.length,
                  itemBuilder: (context, index) {
                    final chat = widget.filteredChats[index];
                    final isSelected = widget.selectedChat?.name == chat.name;

                    return _ChatListTile(
                      chat: chat,
                      isSelected: isSelected,
                      onTap: () => widget.onOpenChat(chat),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _openFilterModal(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black12,
      builder: (ctx) {
        return Dialog(
          alignment: Alignment.topRight,
          insetPadding: const EdgeInsets.only(top: 110, right: 16, left: 60),
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: _FilterMenuModalSheet(
            onSelectFilter: (filterName) {
              Navigator.of(ctx).pop();
              if (filterName == 'Starred') {
                setState(() => _activeTab = 'Starred');
              } else if (filterName == 'Unread') {
                setState(() => _activeTab = 'Inbox');
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildTabPill(String label) {
    final isActive = _activeTab == label;
    return GestureDetector(
      onTap: () => setState(() => _activeTab = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: isActive ? AppColors.green.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? AppColors.green : AppColors.cardBorder,
            width: isActive ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? AppColors.green : AppColors.ink700,
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _ChatListTile extends StatelessWidget {
  const _ChatListTile({
    required this.chat,
    required this.isSelected,
    required this.onTap,
  });

  final ChatThread chat;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? const Color(0xfff0f7f2) : Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: const BorderSide(color: AppColors.cardBorder, width: 0.8),
              left: isSelected
                  ? const BorderSide(color: AppColors.green, width: 4)
                  : BorderSide.none,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ChatAvatar(initials: chat.initials, online: chat.online, radius: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (chat.starred) ...[
                          const Icon(
                            Icons.star_rounded,
                            color: AppColors.saffron,
                            size: 15,
                          ),
                          const SizedBox(width: 4),
                        ],
                        Expanded(
                          child: Text(
                            '${chat.name}, ${chat.company}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.navy,
                              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          chat.time,
                          style: const TextStyle(
                            color: AppColors.ink500,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      chat.project,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.ink500,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      chat.preview,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isSelected ? AppColors.navy : AppColors.ink900,
                        fontSize: 12.5,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatDetailPane extends StatelessWidget {
  const _ChatDetailPane({
    required this.chat,
    required this.replyController,
    required this.isDesktop,
    required this.onBack,
    required this.onSend,
  });

  final ChatThread chat;
  final TextEditingController replyController;
  final bool isDesktop;
  final VoidCallback onBack;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Chat Detail Top Bar (Matches exact image: Back Arrow, Avatar, Name, Time, 3-dots)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: AppColors.cardBorder, width: 0.8)),
          ),
          child: Row(
            children: [
              if (!isDesktop) ...[
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, size: 24),
                  color: AppColors.navy,
                  onPressed: onBack,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 12),
              ],
              _ChatAvatar(
                initials: chat.initials,
                online: chat.online,
                radius: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      chat.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.navy,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      chat.name == 'David Courtney'
                          ? '5:13 am GMT'
                          : chat.name == 'Kevin Ross'
                              ? '2:06 am GMT-05:00'
                              : chat.messages.first.time,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xff777777),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert_rounded, size: 24),
                color: AppColors.navy,
                onPressed: () {},
              ),
            ],
          ),
        ),

        // Chat Message Thread (No Container boxes around text, plain clean text matching image)
        Expanded(
          child: Container(
            color: Colors.white,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: chat.messages.length,
              itemBuilder: (context, index) {
                final message = chat.messages[index];

                bool showDateDivider = false;
                String dateLabel = '';
                bool showSender = false;

                if (chat.name == 'David Courtney') {
                  if (index == 0) {
                    showSender = false;
                  } else if (index == 1) {
                    showSender = false;
                  } else if (index == 2) {
                    showDateDivider = true;
                    dateLabel = 'Yesterday';
                    showSender = true;
                  } else if (index == 3) {
                    showSender = true;
                  } else if (index == 4) {
                    showDateDivider = true;
                    dateLabel = 'Today';
                    showSender = true;
                  }
                } else if (chat.name == 'Kevin Ross') {
                  if (index == 0) {
                    showSender = false;
                  } else if (index == 1) {
                    showDateDivider = true;
                    dateLabel = 'Jul 27';
                    showSender = true;
                  }
                } else {
                  if (index == 0) {
                    showDateDivider = true;
                    dateLabel = 'Jul 15';
                    showSender = true;
                  } else if (index == chat.messages.length - 1) {
                    showDateDivider = true;
                    dateLabel = 'Jul 27';
                    showSender = true;
                  } else {
                    showSender = true;
                  }
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (showDateDivider) ...[
                      const SizedBox(height: 12),
                      _DateDivider(label: dateLabel),
                      const SizedBox(height: 16),
                    ],
                    _PlainMessageItem(
                      message: message,
                      chat: chat,
                      showSender: showSender,
                    ),
                  ],
                );
              },
            ),
          ),
        ),

        // Bottom Chat Composer (Matching exact image layout)
        _ChatComposer(controller: replyController, onSend: onSend),
      ],
    );
  }
}

class _PlainMessageItem extends StatelessWidget {
  const _PlainMessageItem({
    required this.message,
    required this.chat,
    this.showSender = false,
  });

  final ChatMessage message;
  final ChatThread chat;
  final bool showSender;

  @override
  Widget build(BuildContext context) {
    final senderName = message.fromMe ? 'Pavan Kumar' : chat.name;
    final senderInitials = message.fromMe ? 'PK' : chat.initials;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sender Header Row with Avatar if showSender is true
          if (showSender) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (message.fromMe)
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const CircleAvatar(
                        radius: 18,
                        backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&q=80&w=120',
                        ),
                      ),
                      Positioned(
                        right: -1,
                        bottom: -1,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: AppColors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  _ChatAvatar(
                    initials: senderInitials,
                    online: chat.online,
                    radius: 18,
                  ),
                const SizedBox(width: 10),
                Text(
                  senderName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  message.time,
                  style: const TextStyle(
                    color: Color(0xff777777),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],

          // Plain Message Text - No container box, no background color, no border
          SelectableText(
            message.text,
            style: const TextStyle(
              color: Color(0xff202020),
              fontSize: 15,
              fontWeight: FontWeight.w500,
              height: 1.45,
            ),
          ),

          // Image Attachment if present
          if (message.imageUrl != null) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                message.imageUrl!,
                width: 240,
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 240,
                    height: 150,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.broken_image_rounded, color: Colors.grey),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DateDivider extends StatelessWidget {
  const _DateDivider({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xff777777),
            fontSize: 12.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Divider(color: Color(0xffdfdfdf), thickness: 1),
        ),
      ],
    );
  }
}

class _ChatComposer extends StatelessWidget {
  const _ChatComposer({required this.controller, required this.onSend});

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.cardBorder)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.videocam_outlined, size: 24),
            color: AppColors.ink700,
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.attach_file_rounded, size: 22),
            color: AppColors.ink700,
            onPressed: () {},
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.cream100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: controller,
                minLines: 1,
                maxLines: 4,
                style: const TextStyle(fontSize: 14.5, color: AppColors.navy),
                decoration: const InputDecoration(
                  hintText: 'Send a message',
                  hintStyle: TextStyle(
                    color: AppColors.ink300,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          IconButton(
            icon: const Icon(Icons.send_rounded, size: 24),
            color: AppColors.green,
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                onSend();
              }
            },
          ),
        ],
      ),
    );
  }
}

class _ChatAvatar extends StatelessWidget {
  const _ChatAvatar({
    required this.initials,
    required this.online,
    this.radius = 20,
  });

  final String initials;
  final bool online;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: AppColors.navy,
          child: Text(
            initials,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: radius * 0.65,
            ),
          ),
        ),
        Positioned(
          right: -1,
          bottom: -1,
          child: Container(
            width: 11,
            height: 11,
            decoration: BoxDecoration(
              color: online ? AppColors.green : Colors.grey.shade400,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

class _FilterMenuModalSheet extends StatefulWidget {
  const _FilterMenuModalSheet({required this.onSelectFilter});

  final ValueChanged<String> onSelectFilter;

  @override
  State<_FilterMenuModalSheet> createState() => _FilterMenuModalSheetState();
}

class _FilterMenuModalSheetState extends State<_FilterMenuModalSheet> {
  bool _contractsExpanded = true;
  bool _otherExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMenuItem(
                icon: Icons.mail_outline_rounded,
                title: 'Unread',
                onTap: () => widget.onSelectFilter('Unread'),
              ),
              _buildMenuItem(
                icon: Icons.star_outline_rounded,
                title: 'Favorites',
                onTap: () => widget.onSelectFilter('Starred'),
              ),
              _buildExpandableHeader(
                icon: Icons.article_outlined,
                title: 'Contracts',
                isExpanded: _contractsExpanded,
                onToggle: () => setState(() => _contractsExpanded = !_contractsExpanded),
              ),
              if (_contractsExpanded) ...[
                _buildSubMenuItem(
                  icon: Icons.near_me_outlined,
                  title: 'All Contracts',
                  onTap: () => widget.onSelectFilter('All Contracts'),
                ),
                _buildSubMenuItem(
                  icon: Icons.label_outlined,
                  title: 'Fixed-price contracts',
                  onTap: () => widget.onSelectFilter('Fixed-price'),
                ),
                _buildSubMenuItem(
                  icon: Icons.access_time_rounded,
                  title: 'Hourly contracts',
                  onTap: () => widget.onSelectFilter('Hourly'),
                ),
              ],
              _buildExpandableHeader(
                icon: Icons.chat_bubble_outline_rounded,
                title: 'Other',
                isExpanded: _otherExpanded,
                onToggle: () => setState(() => _otherExpanded = !_otherExpanded),
              ),
              if (_otherExpanded) ...[
                _buildSubMenuItem(
                  icon: Icons.work_outline_rounded,
                  title: 'Interviews',
                  onTap: () => widget.onSelectFilter('Interviews'),
                ),
                _buildSubMenuItem(
                  icon: Icons.do_not_disturb_on_outlined,
                  title: 'Hidden & archived',
                  onTap: () => widget.onSelectFilter('Hidden'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      leading: Icon(icon, color: AppColors.navy, size: 20),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.navy,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildExpandableHeader({
    required IconData icon,
    required String title,
    required bool isExpanded,
    required VoidCallback onToggle,
  }) {
    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      leading: Icon(icon, color: AppColors.navy, size: 20),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.navy,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
      trailing: Icon(
        isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
        color: AppColors.navy,
        size: 22,
      ),
      onTap: onToggle,
    );
  }

  Widget _buildSubMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 28),
      child: ListTile(
        dense: true,
        visualDensity: VisualDensity.compact,
        leading: Icon(icon, color: AppColors.ink700, size: 18),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColors.ink700,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
