// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
                  style: TextStyle(color: Color.fromRGBO(238, 206, 77, 100), fontSize: 20, fontWeight: FontWeight.bold),
                ),
                padding: EdgeInsets.all(5),
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
                    style: TextStyle(color: Color.fromRGBO(238, 206, 77, 100), fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  padding: EdgeInsets.all(10),
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
                Center(child: Container(height: 40, width: 300, color: Colors.white, child: Text('These cases are perfectly simple and easy to distinguish.  ')))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
