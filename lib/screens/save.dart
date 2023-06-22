import 'package:client/layouts/layouts.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../services/mysql.dart';
import '../utils/client.dart';

class SaveScreen extends StatefulWidget {
  const SaveScreen({Key? key}) : super(key: key);

  @override
  State<SaveScreen> createState() => _SaveScreenState();
}

class _SaveScreenState extends State<SaveScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController= TextEditingController();
  final _ageController = TextEditingController();
  final MySQL _mySql = MySQL();

  Function? refreshClients;
  Client? _client;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      if (args != null && args['id'] != null) {
        _getClient(args['id']);
      }
      refreshClients = args!['refreshClients'];
    });
  }

  Future<void> _getClient(int id) async {
    try {
      final client = await _mySql.getById(id);
      setState(() {
        _client = client;
        _nameController.text = client.name;
        _ageController.text = client.age.toString();
      });
    } catch (e) {
      makeToast('Failed to get client', true);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final client = Client(
        name: _nameController.text,
        age: _ageController.text,
      );

      try {
        if (_client != null) {
          client.id = _client!.id;
          await _mySql.update(client.id!, client);
        } else {
          await _mySql.create(client);
        }
        makeToast(
            'Client ${_client == null ? 'created' : 'updated'} successfully',
            false);
        refreshClients!();
        Navigator.pop(context);
      } catch (e) {
        makeToast(
            'Failed to ${_client == null ? 'create' : 'update'} client', true);
      }
    }
  }

  void makeToast(String message, bool isError) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: isError ? Colors.red[400] : Colors.green[600],
        textColor: Colors.white,
        fontSize: 16);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainLayout(
        title: Text(
          _client == null ? 'Create Client' : 'Update Client',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              Text(
                _client == null ? 'Create Client' : 'Update Client',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Name'),                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Age'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an age';
                          }
                          final age = int.tryParse(value);
                          if (age.toString().length > 2 ||
                              age == null ||
                              age < 10) {
                            return 'Please enter a valid age (10-99)';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () async => await _submitForm(context),
                        child: Text(_client == null ? 'Create' : 'Update'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
