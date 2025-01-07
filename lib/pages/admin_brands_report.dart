import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kyb/pages/admin_edit_page.dart';

class AdminBrandsReport extends StatefulWidget {
  @override
  _AdminBrandsReportState createState() => _AdminBrandsReportState();
}

String toTitleCase(String text) {
  if (text.isEmpty) return text;
  return text
      .split(' ') // Split the text by spaces
      .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase()) // Capitalize each word
      .join(' '); // Join them back with spaces
}

class _AdminBrandsReportState extends State<AdminBrandsReport> {
  // Function to mark a report as reviewed and remove it from the list
  Future<void> _markAsReviewed(String reportId) async {
    try {
      await FirebaseFirestore.instance.collection('report_list').doc(reportId).update({
        'reviewed': true,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Report marked as reviewed and removed from view.')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to mark report as reviewed: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 220, 80, 1), // Yellow background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black), // Black icons
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('report_list').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error fetching reports.'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No reports found.',
                style: TextStyle(color: Colors.black), // Black text
              ),
            );
          }

          // Filter unreviewed reports
          final reports = snapshot.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data['reviewed'] != true; // Include only unreviewed reports
          }).toList();

          if (reports.isEmpty) {
            return Center(
              child: Text(
                'No reports found.',
                style: TextStyle(color: Colors.black), // Black text
              ),
            );
          }

          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              final data = report.data() as Map<String, dynamic>;
              final companyName = data['companyName'] ?? '';
              final barcodeNum = data['barcodeNum'] ?? '';

              return FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('barcodes')
                    .where('companyName', isEqualTo: companyName)
                    .where('barcodeNum', isEqualTo: barcodeNum)
                    .limit(1) // Limit to 1 document
                    .get(), // Execute query
                builder: (context, barcodeSnapshot) {
                  if (barcodeSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (barcodeSnapshot.hasError || !barcodeSnapshot.hasData) {
                    return Center(child: Text('Error fetching brand details.'));
                  }

                  final barcodeData = barcodeSnapshot.data!.docs.isNotEmpty ? barcodeSnapshot.data!.docs.first.data() as Map<String, dynamic> : {};

                  // Compare fields and prepare display
                  List<Widget> changes = [];

                  // Compare Category
                  final currentCategory = barcodeData['category'] ?? 'N/A';
                  final reportCategory = data['category'] ?? 'N/A';
                  if (currentCategory != reportCategory) {
                    changes.add(
                      Text(
                        'Current Category: ${toTitleCase(currentCategory)}\nChange Category to: ${toTitleCase(reportCategory)}',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    );
                  }

                  // Compare BrandType
                  final currentBrandType = barcodeData['brandType'] ?? 'N/A';
                  final reportBrandType = data['brandType'] ?? 'N/A';
                  if (currentBrandType != reportBrandType) {
                    changes.add(
                      Text(
                        'Current BrandType: $currentBrandType\nChange BrandType to: $reportBrandType',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    );
                  }

                  // Compare Evidence Link
                  final currentEvidenceLink = barcodeData['link'] ?? 'N/A';
                  final reportEvidenceLink = data['link'] ?? 'N/A';
                  if (currentEvidenceLink != reportEvidenceLink) {
                    changes.add(
                      Text(
                        'Current Evidence Link: $currentEvidenceLink\nChange Evidence Link to: $reportEvidenceLink',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    );
                  }

                  return Card(
                    color: Colors.white, // White card background
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Display company name
                          Text(
                            'Company Name: ${toTitleCase(companyName)}',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                          SizedBox(height: 8),
                          ...changes, // Display changes
                          SizedBox(height: 10),
                          // Buttons for admin actions
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Mark as Reviewed Button
                              ElevatedButton(
                                onPressed: () async {
                                  await _markAsReviewed(report.id);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black, // Black button background
                                  foregroundColor: Colors.white, // White text on button
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                ),
                                child: Text('Mark as Reviewed'),
                              ),
                              // Update Brand Details Button
                              ElevatedButton(
                                onPressed: () {
                                  final String companyName = data['companyName'] ?? ''; // Get company name from the report
                                  if (companyName.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Company name is missing.')),
                                    );
                                    return;
                                  }

                                  // Fetch all documents with the same companyName
                                  FirebaseFirestore.instance
                                      .collection('barcodes')
                                      .where('companyName', isEqualTo: companyName) // Query by companyName
                                      .get()
                                      .then((querySnapshot) {
                                    if (querySnapshot.docs.isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('No matching brand details found.')),
                                      );
                                      return;
                                    }

                                    for (var doc in querySnapshot.docs) {
                                      final data = doc.data() as Map<String, dynamic>;

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditBrandPage(
                                            documentId: doc.id,
                                            companyName: data['companyName'] ?? '',
                                            brandType: data['brandType'] ?? '',
                                            category: data['category'] ?? '',
                                            approved: data['approved'] ?? false,
                                            evidenceLink: data['link'] ?? '',
                                            logoURL: data['logoURL'] ?? '',
                                            barcodeNum: data['barcodeNum'] ?? '',
                                          ),
                                        ),
                                      );
                                    }
                                  }).catchError((e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Failed to load brand details: $e')),
                                    );
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                ),
                                child: const Text('Update Brand Details'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
