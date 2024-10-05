import 'package:flutter/material.dart';

import 'home.dart';

class SearchlocationScreen extends StatefulWidget {
  const SearchlocationScreen({super.key});

  @override
  State<SearchlocationScreen> createState() => _SearchlocationScreenState();
}

class _SearchlocationScreenState extends State<SearchlocationScreen> {
  final _cityController = TextEditingController();
  String _latitude = '';
  String _longitude = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        centerTitle: true,
        title: Text(
          'Search Your Location',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.only(left: 20),
            margin: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 10),
            height: 50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.grey[200],
            ),
            child: TextField(
              controller: _cityController,
              decoration: InputDecoration(
                  suffixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  hintText: 'Enter location'),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_cityController.text.isNotEmpty) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please enter a location'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text('Use current location'),
          ),
          SizedBox(height: 25),
          GestureDetector(
            onTap: () {
              if (_cityController.text.isNotEmpty) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please enter a location'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              height: 47,
              width: 150,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(50)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 8),
                  Text(
                    'Next',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
