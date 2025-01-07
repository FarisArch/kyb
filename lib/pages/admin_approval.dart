import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
              final data = doc.data() as Map<String, dynamic>;
              final companyName = data['companyName'] ?? 'No Name';
              final category = data['category'] ?? 'No Category';
              final logoURL = _getLogoUrl(data);

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: ListTile(
                  title: Text(companyName),
                  subtitle: Text(category),
                  leading: logoURL != null
                      ? Image.network(
                          logoURL,
                          width: 50,
                          height: 50,
                          errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported), // Fallback icon on error
                        )
                      : Icon(Icons.image_not_supported), // Default icon if no logo
                  trailing: IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ApprovalDetailPage(doc.id, data),
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

  // Logo Logic
  String? _getLogoUrl(Map<String, dynamic> data) {
    if (data.containsKey('logoURL') && data['logoURL'] != null) {
      final logoData = data['logoURL'];

      // Check if logoURL is a string
      if (logoData is String && logoData.isNotEmpty) {
        return logoData; // Return the single logo
      }

      // Check if logoURL is an array and not empty
      if (logoData is List && logoData.isNotEmpty) {
        return logoData.first; // Return the first logo in the array
      }
    }

    // Fallback URL
    final companyName = (data['companyName'] ?? '').toLowerCase().replaceAll(' ', '');
    return 'https://img.logo.dev/$companyName.com?token=pk_AEpg6u4jSUiuT_wJxuISUQ';
  }
}

class ApprovalDetailPage extends StatelessWidget {
  final String docId;
  final Map<String, dynamic> data;

  const ApprovalDetailPage(this.docId, this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    final logoURL = _getLogoUrl(data);

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
            logoURL != null
                ? Image.network(
                    logoURL,
                    height: 100,
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported), // Fallback
                  )
                : Text('No logo available', style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
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

  // Logo Logic
  String? _getLogoUrl(Map<String, dynamic> data) {
    if (data.containsKey('logoURL') && data['logoURL'] != null) {
      final logoData = data['logoURL'];

      // Check if logoURL is an array
      if (logoData is List && logoData.isNotEmpty) {
        // Match the domain with the company's domain in the data
        final domain = (data['companyName'] ?? '').toLowerCase().replaceAll(' ', '') + '.com';

        // Find the logo by matching the domain
        final matchedLogo = logoData.firstWhere((logo) => logo['domain'] == domain, orElse: () => null);

        // Return the logo_url if a match is found
        if (matchedLogo != null) {
          return matchedLogo['logo_url'];
        }
      }
    }

    // Fallback URL (if no match found)
    final companyName = (data['companyName'] ?? '').toLowerCase().replaceAll(' ', '');
    return 'https://img.logo.dev/$companyName.com?token=pk_AEpg6u4jSUiuT_wJxuISUQ';
  }
}
