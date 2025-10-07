import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme.dart';

class ChatPanel extends StatefulWidget {
  final String personaName;
  final String personaIcon;

  const ChatPanel({
    super.key,
    required this.personaName,
    required this.personaIcon,
  });

  @override
  State<ChatPanel> createState() => _ChatPanelState();
}

class _ChatPanelState extends State<ChatPanel> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<MockMessage> _messages = [
    MockMessage(
      role: 'user',
      content: 'Hey, should I build Last.fm 2025 or focus on finishing WGU?',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    MockMessage(
      role: 'assistant',
      content: 'That\'s a classic founder trap—shiny new idea vs finishing the boring thing.\n\nReal talk: WGU is a finite problem with a clear deadline (June 2025). Last.fm is infinite scope with no forcing function.\n\nHere\'s the tactical play:\n1. Finish WGU (45% done, need +34pts/month).\n2. Spend 2 hours THIS WEEK validating Last.fm:\n   - Talk to 5 music heads. Would they pay?\n   - Check Spotify API limitations.\n3. If validation is weak → kill it and move on.\n   If strong → build MVP after WGU (don\'t split focus).\n\nWhat\'s the REAL reason you want to start Last.fm now?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 59)),
    ),
    MockMessage(
      role: 'user',
      content: 'You\'re right. I think it\'s avoidance—WGU feels boring compared to new projects.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    MockMessage(
      role: 'assistant',
      content: 'Boom. That\'s the real insight.\n\nBoredom is just your brain looking for novelty. But finishing WGU is proof you can close loops—that\'s the skill that separates founders from wantrepreneurs.\n\nHere\'s a tactical hack: gamify WGU. Set a 30-day sprint to knock out D315 and D276 back-to-back. Make it feel urgent.\n\nThen reward yourself with 1 weekend to prototype Last.fm v0.1.\n\nDeal?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 29)),
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Text(
                  widget.personaIcon,
                  style: const TextStyle(fontSize: 22),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.personaName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Active conversation',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(LucideIcons.search, size: 18),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Search coming soon!')),
                    );
                  },
                  color: AppColors.textSecondary,
                  tooltip: 'Search chats',
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz, size: 18),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Options coming soon!')),
                    );
                  },
                  color: AppColors.textSecondary,
                  tooltip: 'More options',
                ),
              ],
            ),
          ),

          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessage(_messages[index]);
              },
            ),
          ),

          // Input area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.background,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 150),
                    child: TextField(
                      controller: _messageController,
                      maxLines: null,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        hintStyle: const TextStyle(color: AppColors.textTertiary),
                        filled: true,
                        fillColor: AppColors.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: AppColors.primary, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: () {
                    if (_messageController.text.trim().isEmpty) return;

                    setState(() {
                      _messages.add(MockMessage(
                        role: 'user',
                        content: _messageController.text.trim(),
                        timestamp: DateTime.now(),
                      ));
                    });

                    _messageController.clear();

                    // Scroll to bottom
                    Future.delayed(const Duration(milliseconds: 100), () {
                      _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('AI response coming soon!')),
                    );
                  },
                  icon: const Icon(LucideIcons.send),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(12),
                  ),
                  tooltip: 'Send message',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(MockMessage message) {
    final isUser = message.role == 'user';
    final timeStr = DateFormat('h:mm a').format(message.timestamp);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Text(
              widget.personaIcon,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isUser
                    ? AppColors.primary.withOpacity(0.1)
                    : AppColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isUser
                      ? AppColors.primary.withOpacity(0.3)
                      : AppColors.border,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!isUser) ...[
                    Text(
                      widget.personaName,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  Text(
                    message.content,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        timeStr,
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      if (!isUser) ...[
                        const SizedBox(width: 12),
                        InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Copy coming soon!')),
                            );
                          },
                          child: const Text(
                            'Copy',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.accent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Tag coming soon!')),
                            );
                          },
                          child: const Text(
                            'Tag',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.accent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MockMessage {
  final String role;
  final String content;
  final DateTime timestamp;

  MockMessage({
    required this.role,
    required this.content,
    required this.timestamp,
  });
}

