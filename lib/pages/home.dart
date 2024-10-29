// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:kyb/pages/news.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    int _currentIndex = 0;
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        height: 60,
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Home(),
              ),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewsPage(),
              ),
            );
          }
          setState(() => _currentIndex = index);
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.newspaper),
            label: 'News',
          ),
          NavigationDestination(
            icon: Icon(Icons.camera),
            label: 'Scan',
          ),
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_a_photo),
            label: 'Contribute',
          ),
        ],
      ),
      backgroundColor: const Color.fromRGBO(255, 220, 80, 1),
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Text(
                  'Support Local-la!',
                  style: TextStyle(color: Color.fromRGBO(255, 220, 80, 1), fontSize: 25, fontWeight: FontWeight.bold),
                ),
                padding: EdgeInsets.fromLTRB(20,5,20,5),
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Cosmetics',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              // Category  1 row list
              Column(children: [
                Text('item 1'),
                SizedBox(
                  height: 100,
                  width: 100,
                  child: TextButton(
                      onPressed: () {
                        print('I got clicked');
                      },
                      child: Image.asset('assets/1.jpg')),
                )
              ]),
              Column(children: [
                Text('item 1'),
                SizedBox(
                  height: 100,
                  width: 100,
                  child: TextButton(
                      onPressed: () {
                        print('I got clicked');
                      },
                      child: Image.asset('assets/1.jpg')),
                )
              ]),
              Column(children: [
                Text('item 1'),
                SizedBox(
                  height: 100,
                  width: 100,
                  child: TextButton(
                      onPressed: () {
                        print('I got clicked');
                      },
                      child: Image.asset('assets/1.jpg')),
                )
              ]),
            ]),
            SizedBox(height: 5),
            Text(
              'Food & Beverage',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              // Category 2 row list
              Column(children: [
                Text('item 1'),
                SizedBox(
                  height: 100,
                  width: 100,
                  child: TextButton(
                      onPressed: () {
                        print('I got clicked');
                      },
                      child: Image.asset('assets/1.jpg')),
                )
              ]),
              Column(children: [
                Text('item 1'),
                SizedBox(
                  height: 100,
                  width: 100,
                  child: TextButton(
                      onPressed: () {
                        print('I got clicked');
                      },
                      child: Image.asset('assets/1.jpg')),
                )
              ]),
              Column(children: [
                Text('item 1'),
                SizedBox(
                  height: 100,
                  width: 100,
                  child: TextButton(
                      onPressed: () {
                        print('I got clicked');
                      },
                      child: Image.asset('assets/1.jpg')),
                )
              ]),
            ]),
            Column(
              // NEWS PAGE COLUMN
              children: [
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                  child: Text(
                    'Flash news',
                    style: TextStyle(color: Color.fromRGBO(255, 220, 80, 1), fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  padding: EdgeInsets.fromLTRB(20,5,20,5),
                ),
                Container(
                  height: 140,
                  width: 200,
                  child: TextButton(
                      onPressed: () {
                        print('News was clicked');
                      },
                      child: Image.asset('assets/1.jpg')),
                ),
                Center(child: Container(height: 50, width: 350, color: Colors.white, child: Text('These cases are perfectly simple and easy to distinguish.')))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
