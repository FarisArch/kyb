import 'package:flutter/material.dart';

class ResultFalsePage extends StatelessWidget {
  final String companyName;
  final String brandType;
  final String category;
  final String link;

  const ResultFalsePage({
    super.key,
    required this.companyName,
    required this.brandType,
    required this.category,
    required this.link,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(companyName), // Dynamic title using companyName
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/marrybrown.png', height: 100), // Replace with appropriate image for each brand
            const SizedBox(height: 20),
            Text(
              '$companyName is safe!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Text(
                    "$companyName is categorized under $category. Brand type: $brandType.\n\nEvidence: $link",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Add action for viewing proof (e.g., open a URL or show more details)
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Proof for $companyName'),
                          content: Text('Proof link: $link'),
                          actions: [
                            TextButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('View proof'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Navigate back to the previous page
                  },
                  child: const Text('Report'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
