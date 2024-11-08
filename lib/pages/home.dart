// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:kyb/navigation/navigation_bar.dart';
import 'package:kyb/pages/pages.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationControl(),
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
                padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                child: Text(
                  'Support Local-la!',
                  style: TextStyle(color: Color.fromRGBO(255, 220, 80, 1), fontSize: 25, fontWeight: FontWeight.bold),
                ),
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
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Text(
                    'Flash news',
                    style: TextStyle(color: Color.fromRGBO(255, 220, 80, 1), fontSize: 25, fontWeight: FontWeight.bold),
                  ),
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
