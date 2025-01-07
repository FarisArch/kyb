import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

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
        stream: FirebaseFirestore.instance
            .collection('barcodes')
            .where('approved', isEqualTo: false)
            .snapshots(),
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
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.image_not_supported), // Fallback icon
                  )
                      : Icon(Icons.image_not_supported), // Default icon
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
    final companyName =
    (data['companyName'] ?? '').toLowerCase().replaceAll(' ', '');
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
    final evidenceLink = data['evidenceLink'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Brand Details'),
        backgroundColor: Colors.yellow[700],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (logoURL != null)
              Image.network(
                logoURL,
                height: 100,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.image_not_supported), // Fallback
              )
            else
              Text('No logo available',
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Barcode: ${data['barcodeNum'] ?? 'N/A'}',
                  style: TextStyle(fontSize: 18)),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Brand Type: ${data['brandType'] ?? 'N/A'}',
                  style: TextStyle(fontSize: 18)),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Category: ${data['category'] ?? 'N/A'}',
                  style: TextStyle(fontSize: 18)),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Company Name: ${data['companyName'] ?? 'N/A'}',
                  style: TextStyle(fontSize: 18)),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  if (evidenceLink.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                          appBar: AppBar(title: Text('Evidence Link')),
                          body: InAppWebView(
                            initialUrlRequest: URLRequest(
                              url: WebUri(evidenceLink),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('No evidence link available.')),
                    );
                  }
                },
                child: Text('View Evidence'),
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('barcodes')
                        .doc(docId)
                        .update({'approved': true});
                    Navigator.pop(context);
                  },
                  child: Text('Approve'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('barcodes')
                        .doc(docId)
                        .delete();
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
      if (logoData is String && logoData.isNotEmpty) {
        return logoData;
      }
      if (logoData is List && logoData.isNotEmpty) {
        return logoData.first;
      }
    }
    final companyName =
    (data['companyName'] ?? '').toLowerCase().replaceAll(' ', '');
    return 'https://img.logo.dev/$companyName.com?token=pk_AEpg6u4jSUiuT_wJxuISUQ';
  }
}
