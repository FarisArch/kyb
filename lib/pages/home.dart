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
// NEWS PAGE COLUMN
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Text(
                    'Flash news',
                    style: TextStyle(color: Color.fromRGBO(255, 220, 80, 1), fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                FutureBuilder(
                  future: Article.fetchArticles('general'), // fetch general news
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final articles = snapshot.data;
                      return Column(
                        children: articles != null
                            ? [
                                SizedBox(
                                  height: 233, // adjust this value to fit your needs
                                  child: NewsCard(
                                    article: articles.first,
                                    backgroundColor: Colors.white,
                                  ),
                                )
                              ]
                            : [],
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
