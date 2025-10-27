import 'package:flutter/material.dart';

class ChatView extends StatelessWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat'), centerTitle: true),
      body: Center(
        child: Text(
          'Chat Page',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
