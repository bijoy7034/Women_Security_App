import 'package:flutter/material.dart';

class HowtoUse extends StatefulWidget {
  const HowtoUse({Key? key}) : super(key: key);

  @override
  State<HowtoUse> createState() => _HowtoUseState();
}

class _HowtoUseState extends State<HowtoUse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'How to use',
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '1. Add Emergency Contacts:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Navigate to the Emergency Contacts page and tap on the "+" button to add contacts you trust.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '2. Send SOS Message:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'In case of emergency, tap on the SOS button on the main screen. SOS messages containing your current location will be sent to your added emergency contacts.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              '3. Access Helpline Numbers:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Visit the Helpline Numbers page to find important helpline numbers such as police, ambulance, etc. Tap on any number to make a call directly from the app.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
