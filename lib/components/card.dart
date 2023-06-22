import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  final int id;
  final String name;
  final String age;
  final String hireDate;
  final Function? onPress;
  final Function? refreshClients;

  const MyCard({
    Key? key,
    required this.id,
    required this.name,
    required this.age,
    required this.hireDate,
    this.onPress,
    this.refreshClients,
  }) : super(key: key);

  Color randomColor() {
    final List<Color> colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.teal,
      Colors.indigo,
      Colors.cyan,
      Colors.amber,
      Colors.lime,
      Colors.lightBlue,
      Colors.lightGreen,
      Colors.deepOrange,
      Colors.deepPurple,
      Colors.brown,
      Colors.grey,
    ];
    return colors[DateTime.now().microsecond % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 10,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsetsDirectional.all(6),
            width: 110,
            height: 110,
            child: CircleAvatar(
              radius: 40,
              backgroundColor: randomColor(),
              child: Text(
                name.toUpperCase().substring(0, 1),
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(width: 10),
                    Text(
                      'Age: $age',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 2,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Hire: ${hireDate.split(' ').first}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 2,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        'save',
                        arguments: {'id': id, 'refreshClients': refreshClients},
                      ),
                      icon: Icon(Icons.mode_edit_outline_sharp,
                          color: Colors.blue[400]),
                    ),
                    IconButton(
                      onPressed: () => onPress!(),
                      icon: Icon(Icons.delete_forever_rounded,
                          color: Colors.red[400]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
