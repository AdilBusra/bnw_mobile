import 'package:flutter/material.dart';

class AiChatScreen extends StatefulWidget {
  final String tripTitle;
  const AiChatScreen({super.key, required this.tripTitle});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _chatController = TextEditingController();
  final List<Map<String, String>> _messages = [];

  @override
  void initState() {
    super.initState();
    _messages.add({
      'sender': 'ai',
      'text': 'Hi Kayla! 🌺 I am your AI Travel Assistant. Want to know more about ${widget.tripTitle}?'
    });
    _messages.add({
      'sender': 'ai',
      'text': 'You can ask me about the itinerary, weather, what to bring, or photo spot recommendations!'
    });
  }

  void _sendMessage() {
    if (_chatController.text.trim().isNotEmpty) {
      final userText = _chatController.text.trim();
      setState(() {
        _messages.add({'sender': 'user', 'text': userText});
        _chatController.clear();
      });

      // Dummy AI Reply
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _messages.add({
            'sender': 'ai',
            'text': 'That is a great question! ${widget.tripTitle} features breathtaking views, comfortable pacing, and amazing photo spots for your summer feed. ✨ Let me know if you need specific tips!'
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7DF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF164C55), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(color: Color(0xFFFFD1DC), shape: BoxShape.circle),
              child: const Icon(Icons.smart_toy_rounded, color: Color(0xFFF5427D), size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'AI Assistant',
                style: const TextStyle(color: Color(0xFF164C55), fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isAi = msg['sender'] == 'ai';
                return Align(
                  alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.75),
                    decoration: BoxDecoration(
                      color: isAi ? Colors.white : const Color(0xFFF5427D),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(20),
                        topRight: const Radius.circular(20),
                        bottomLeft: isAi ? const Radius.circular(4) : const Radius.circular(20),
                        bottomRight: isAi ? const Radius.circular(20) : const Radius.circular(4),
                      ),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2)),
                      ],
                    ),
                    child: Text(
                      msg['text']!,
                      style: TextStyle(
                        fontSize: 14,
                        color: isAi ? const Color(0xFF164C55) : Colors.white,
                        height: 1.4,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chatController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      hintStyle: const TextStyle(fontSize: 14),
                      filled: true,
                      fillColor: const Color(0xFFFFF7DF),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(999), borderSide: BorderSide.none),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(color: Color(0xFFF5427D), shape: BoxShape.circle),
                    child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}