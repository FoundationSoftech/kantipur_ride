import 'package:flutter/material.dart';


class RideHistory extends StatelessWidget {
  final List<Map<String, dynamic>> rides = [
    {
      'date': '30 Aug at 09:56',
      'from': 'Budhanilkantha',
      'to': 'Softech Foundation Pvt.Ltd.',
      'price': 'Rs165.00',
    },
    {
      'date': '25 Aug at 10:32',
      'from': 'Budhanilkantha',
      'to': 'National Law College',
      'price': 'Rs297.00',
      'status': 'Delivery',
    },
    {
      'date': '23 Aug at 16:18',
      'from': 'Bag Bazar Sadak',
      'to': 'Gongabu Bus Park',
      'price': 'Rs501.00',
    },
    {
      'date': '10 Aug at 10:09',
      'from': 'Budhanilkantha',
      'to': 'Sukedhara chok',
      'price': 'Rs95.00',
    },
    {
      'date': '10 Aug at 10:00',
      'from': 'Budhanilkantha',
      'to': 'Hattigauda',
      'price': 'Rs0.00',
      'status': 'You cancelled',
    },
    {
      'date': '3 Aug at 13:41',
      'from': 'Budhanilkantha',
      'to': 'Handball sports and clothing station',
      'price': 'Rs70.00',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Rides'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: rides.length,
        itemBuilder: (context, index) {
          final ride = rides[index];
          return ListTile(
            title: Text(
              ride['from'],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ride['to']),
                SizedBox(height: 4),
                if (ride.containsKey('status'))
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      ride['status'],
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
              ],
            ),
            trailing: Text(ride['price']),
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.circle, color: Colors.blue, size: 10),
                SizedBox(height: 4),
                Icon(Icons.more_vert, size: 16, color: Colors.grey.shade400),
                SizedBox(height: 4),
                Icon(Icons.circle, color: Colors.green, size: 10),
              ],
            ),
          );
        },
      ),
    );
  }
}
