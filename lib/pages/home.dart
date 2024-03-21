import 'package:flutter/material.dart';
import 'package:background_sms/background_sms.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:women_safety_app/pages/add.dart';
import 'package:women_safety_app/pages/helpline.dart';
import 'package:women_safety_app/pages/howtouse.dart';
import 'package:women_safety_app/pages/login.dart';
import '../database_helper.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  List<Map<String, dynamic>> _contacts = [];

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future<void> _fetchContacts() async {
    List<Map<String, dynamic>> contacts = await _dbHelper.getAllContacts();
    setState(() {
      _contacts = contacts;
    });
  }

  Future<void> _addContact() async {
    final name = _nameController.text.trim();
    final phoneNumber = _phoneNumberController.text.trim();

    if (name.isEmpty || phoneNumber.isEmpty) {
      _showSnackbar('Please enter name and phone number', Colors.blueAccent);
      return;
    }

    Map<String, dynamic> contact = {
      'name': name,
      'phone_number': phoneNumber,
    };

    int result = await _dbHelper.saveContact(contact);
    if (result != 0) {
      _showSnackbar('Contact added successfully', Colors.green);
      _nameController.clear();
      _phoneNumberController.clear();
      _fetchContacts();
    } else {
      _showSnackbar('Failed to add contact', Colors.red);
    }
  }

  Future<void> _deleteContact(int id) async {
    int result = await _dbHelper.deleteContact(id);
    if (result != 0) {
      _showSnackbar('Contact deleted successfully', Colors.green);
      _fetchContacts();
    } else {
      _showSnackbar('Failed to delete contact', Colors.red);
    }
  }

  Future<void> _getPermission() async {
    await [Permission.sms, Permission.location].request();
    await Permission.location.request();
  }

  Future<bool> _isPermissionGranted() async {
    var permissionStatuses = await Future.wait([
      Permission.sms.status,
      Permission.location.status,
    ]);
    return permissionStatuses.every((status) => status.isGranted);
  }

  Future<void> _sendMessage(String phoneNumber, String message) async {
    var permissionGranted = await _isPermissionGranted();
    if (!permissionGranted) {
      _showSnackbar('Permission not granted', Colors.green);
      return;
    }

    // Get device's current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    String url = 'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}';
    // Construct the message with geolocation information
    String fullMessage = '$message\n'
        'Latitude: ${position.latitude}\n'
        'Longitude: ${position.longitude} \n'
    'Location : ${url}';

    var result = await BackgroundSms.sendMessage(
      phoneNumber: phoneNumber,
      message: fullMessage,
    );

    if (result == SmsStatus.sent) {
      _showSnackbar('Message sent', Colors.green);
    } else {
      _showSnackbar('Failed to send message', Colors.redAccent);
    }
  }

  void _showSnackbar(String message, Color a) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: a,
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.settings),
            )
          ],
          title: const Text(
            'Women Safety',
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 30),
            child: Column(
                children: [
            Center(
            child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green.shade200,
              shape: BoxShape.circle,
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                backgroundColor: Colors.green,
              ),
              onPressed: () async {
                if (await _isPermissionGranted()) {
                  // Fetch contacts from the database
                  List<Map<String, dynamic>> contacts =
                  await _dbHelper.getAllContacts();
                  // Send SMS to each contact
                  contacts.forEach((contact) {
                    _sendMessage(contact['phone_number'], "Help is needed!!! , My is location :");
                  });
                } else {
                  _getPermission();
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(58.0),
                child: Icon(
                  Icons.sos,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 40),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddContactPage()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey.shade300,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(28.0),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.contact_page, color: Colors.green, size: 40,),
                          Text(
                            'Add Contacts',
                            style: TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20,),
            Expanded(
              child: InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp2()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey.shade300,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(28.0),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.emergency, color: Colors.green, size: 40,),
                          Text(
                            'Helpline',
                            style: TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: InkWell(
                onTap: (){
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.shade300
                      ),
                      child: const Padding(
                              padding: EdgeInsets.all(28.0),
                              child: Center(
                                  child: Column(
                                    children: [
                                      Icon(Icons.logout, color: Colors.green,size: 40,),
                                      Text(
                                        'Exit',
                                        style: TextStyle(color: Colors.green),
                                      ),
                                    ],
                                  )),
                            ),
                          ),
              )),
                    SizedBox(width: 20,),
                    Expanded(
                        child: InkWell(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => HowtoUse()),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.grey.shade300),
                            child: const Padding(
                              padding: EdgeInsets.all(28.0),
                              child: Center(
                                  child: Column(
                                    children: [
                                      Icon(Icons.help, color: Colors.green,size: 40,),
                                      Text(
                                        'How to use',
                                        style: TextStyle(color: Colors.green),
                                      ),
                                    ],
                                  )),
                            ),
                          ),
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
