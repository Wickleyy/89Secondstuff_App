import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _controller = TextEditingController();

  // gunakan server WebSocket publik (untuk testing)
  final _channel = WebSocketChannel.connect(
    Uri.parse('wss://echo.websocket.events'),
  );

  final List<String> _messages = [];

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    final message = _controller.text.trim();
    _channel.sink.add(message);

    setState(() {
      _messages.insert(0, 'Kamu: $message');
    });

    _controller.clear();
  }

  @override
  void initState() {
    super.initState();

    // dengarkan pesan dari server
    _channel.stream.listen((data) {
      if (data != null && data.toString().isNotEmpty) {
        setState(() {
          _messages.insert(0, 'Server: $data');
        });
      }
    });
  }

  @override
  void dispose() {
    _channel.sink.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Realtime (Tanpa Firebase)'),
        centerTitle: true,
        backgroundColor: Colors.brown,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(_messages[index]),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.grey.shade200,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Ketik pesan...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: Colors.brown,
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
