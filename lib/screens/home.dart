import 'package:client/components/components.dart';
import 'package:client/layouts/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../services/mysql.dart';
import '../utils/client.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MySQL _mySql = MySQL();
  List<Client> _clients = [];

  @override
  void initState() {
    super.initState();
    _loadClients();
  }

  Future<void> _loadClients() async {
    try {
      final clients = await _mySql.getAll();
      setState(() {
        _clients = clients;
      });
    } catch (e) {
      makeToast(e.toString(), true);
    }
  }

  Future<void> _deleteClient(int id, BuildContext context) async {
    try {
      CupertinoAlertDialog dialog = CupertinoAlertDialog(
        content:
            Text('Are you sure want to delete the client with the id" $id'),
        actions: [
          TextButton(
              onPressed: () {},
              child: const Text(
                'cancel',
                style: TextStyle(color: Colors.blue),
              )),
          TextButton(
              onPressed: () async => await _mySql.delete(_clients[id].id!),
              child: const Text(
                'delete',
                style: TextStyle(color: Colors.red),
              )),
        ],
      );

      dialog.build(context);

      setState(() {
        _clients.removeAt(id);
      });
      makeToast('client deleted successfully', false);
    } catch (e) {
      makeToast('Failed to delete client', true);
    }
  }

  void _refreshClients() {
    _loadClients();
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
    int olderClients =
        _clients.where((client) => int.parse(client.age) >= 18).length;
    int youngerClients =
        _clients.where((client) => int.parse(client.age) < 18).length;

    return Scaffold(
      body: MainLayout(
        title: const Text('Home',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Older Clients: $olderClients',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20, height: 2)),
                Text('Younger Clients: $youngerClients',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20, height: 2)),
              ],
            ),
            const Divider(
              height: 20,
              thickness: 5,
              indent: 20,
              endIndent: 20,
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: _clients.length,
                itemBuilder: (BuildContext context, int index) {
                  final client = _clients[index];
                  return MyCard(
                    id: client.id!,
                    name: client.name,
                    age: client.age,
                    hireDate: client.hiredDate!,
                    onPress: () async => await _deleteClient(index, context),
                    refreshClients: _refreshClients,
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, 'save', arguments: {
          'refreshClients': _refreshClients,
        }),
        child: const Icon(
          Icons.person_add_rounded,
        ),
      ),
    );
  }
}
