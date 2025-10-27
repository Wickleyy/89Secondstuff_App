import 'package:flutter/material.dart';

class AccountView extends StatelessWidget {
  const AccountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Account'), centerTitle: true),
      body: Center(
        child: Text(
          'Account Page',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
