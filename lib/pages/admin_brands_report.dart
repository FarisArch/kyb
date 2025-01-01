import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kyb/pages/admin_edit_page.dart';

class AdminBrandsReport extends StatefulWidget {
  @override
  _AdminBrandsReportState createState() => _AdminBrandsReportState();
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

              return Card(
                color: Colors.white, // White card background
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display barcode number
                      Text(
                        'Company Name: ${data['companyName'] ?? 'N/A'}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      SizedBox(height: 8),
                      // Display category/brand type
                      Text(
                        'Category/Brand Type: ${data['category'] ?? data['brandType'] ?? 'N/A'}',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      SizedBox(height: 8),
                      // Display evidence link
                      Text(
                        'Evidence Link: ${data['link'] ?? 'N/A'}',
                        style: TextStyle(fontSize: 14, color: Colors.blue),
                      ),
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
      ),
    );
  }
}
