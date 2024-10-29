// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/material.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: NavigationBar(
          height: 60,
          destinations: [
            // TODO: Add navigating capability and QR
            NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.newspaper), label: 'News'),
            NavigationDestination(icon: Icon(Icons.scanner), label: ''),
            NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
            NavigationDestination(icon: Icon(Icons.add_box), label: 'Contribute'),
          ],
        ),
        backgroundColor: Color.fromRGBO(238, 206, 77, 100),
        body: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  print('This buttonw was clicked');
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Text(
                    'All',
                    style: TextStyle(color: Color.fromRGBO(238, 206, 77, 100), fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  padding: EdgeInsets.all(5),
                ),
              ),
              GestureDetector(
                onTap: () {
                  print('This buttonw was clicked');
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Text(
                    'Food & Beverage',
                    style: TextStyle(color: Color.fromRGBO(238, 206, 77, 100), fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  padding: EdgeInsets.all(5),
                ),
              ),
              GestureDetector(
                onTap: () {
                  print('This buttonw was clicked');
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Text(
                    'Fashion',
                    style: TextStyle(color: Color.fromRGBO(238, 206, 77, 100), fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  padding: EdgeInsets.all(5),
                ),
              ),
              GestureDetector(
                onTap: () {
                  print('This buttonw was clicked');
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Text(
                    'Cosmetics',
                    style: TextStyle(color: Color.fromRGBO(238, 206, 77, 100), fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  padding: EdgeInsets.all(5),
                ),
              ),
            ],
          ),
        ));
  }
}
