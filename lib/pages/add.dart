import 'package:flutter/material.dart';
import '../database_helper.dart';


class AddContactPage extends StatefulWidget {
  @override
  _AddContactPageState createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
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
      _showSnackbar('Please enter name and phone number');
      return;
    }

    Map<String, dynamic> contact = {
      'name': name,
      'phone_number': phoneNumber,
    };

    int result = await _dbHelper.saveContact(contact);
    if (result != 0) {
      _showSnackbar('Contact added successfully');
      _nameController.clear();
      _phoneNumberController.clear();
      _fetchContacts();
    } else {
      _showSnackbar('Failed to add contact');
    }
  }

  Future<void> _deleteContact(int id) async {
    int result = await _dbHelper.deleteContact(id);
    if (result != 0) {
      _showSnackbar('Contact deleted successfully');
      _fetchContacts();
    } else {
      _showSnackbar('Failed to delete contact');
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Contact', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _phoneNumberController,
                    decoration: InputDecoration(labelText: 'Phone Number'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: _addContact,
                    child: Text('Add Contact', style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _contacts.length,
                itemBuilder: (context, index) {
                  final contact = _contacts[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.grey.shade300
                      ),
                      child: ListTile(
                        title: Text(contact['name'], style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),),
                        subtitle: Text(contact['phone_number']),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red,),
                          onPressed: () => _deleteContact(contact['id']),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
