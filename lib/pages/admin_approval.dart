import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:url_launcher/url_launcher.dart';

class AdminApprovalPage extends StatelessWidget {
  const AdminApprovalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Brand Approvals'),
        backgroundColor: Colors.yellow[700],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('barcodes').where('approved', isEqualTo: false).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final documents = snapshot.data!.docs;

          if (documents.isEmpty) {
            return Center(child: Text('No pending approvals'));
          }

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final doc = documents[index];

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: ListTile(
                  title: Text(doc['companyName'] ?? 'No Name'),
                  subtitle: Text(doc['category'] ?? 'No Category'),
                  leading: (doc['logoURL'] != null && doc['logoURL'].isNotEmpty) ? Image.network(doc['logoURL'], width: 50, height: 50) : Icon(Icons.image_not_supported),
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ApprovalDetailPage(doc.id, doc.data() as Map<String, dynamic>),
                      ),
                    ),
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

class ApprovalDetailPage extends StatelessWidget {
  final String docId;
  final Map<String, dynamic> data;

  const ApprovalDetailPage(this.docId, this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Brand Details'),
        backgroundColor: Colors.yellow[700],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Barcode: ${data['barcodeNum'] ?? 'N/A'}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Brand Type: ${data['brandType'] ?? 'N/A'}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Category: ${data['category'] ?? 'N/A'}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Company Name: ${data['companyName'] ?? 'N/A'}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            InkWell(
              child: Text('Evidence Link', style: TextStyle(fontSize: 18, color: Colors.blue, decoration: TextDecoration.underline)),
              onTap: () {
                final link = data['evidenceLink'] ?? '';
                if (link.isNotEmpty) {
                  // launchUrl(Uri.parse(link));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('No evidence link available.')),
                  );
                }
              },
            ),
            SizedBox(height: 20),
            if (data['logoURL'] != null && data['logoURL'].isNotEmpty) Image.network(data['logoURL'], height: 100) else Text('No logo available', style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () async {
                    await FirebaseFirestore.instance.collection('barcodes').doc(docId).update({
                      'approved': true
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Approve'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () async {
                    await FirebaseFirestore.instance.collection('barcodes').doc(docId).delete();
                    Navigator.pop(context);
                  },
                  child: Text('Reject'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
