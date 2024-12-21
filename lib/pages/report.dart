import 'package:flutter/material.dart';
import 'package:kyb/pages/pages.dart';
import 'package:kyb/pages/report_wrongcategory.dart';

class ReportPage extends StatelessWidget {
  final String companyName;
  const ReportPage({super.key, required this.companyName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 220, 80, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Report this brand',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 30),
            _buildReportButton(
              context,
              'Product is in wrong category',
              Colors.white,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReportWrongCategory(companyName: companyName), // Replace with actual barcodeNum
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            _buildReportButton(
              context,
              'Product is in wrong classification',
              Colors.white,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReportWrongClass(companyName: companyName), // Replace with actual barcodeNum
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            /*_buildReportButton(
              context,
              "There's misinformation about the product",
              Colors.white,
                  () {
                Navigator.pushNamed(context, '/report_misinfo');
              },
            ),
            SizedBox(height: 10),
            _buildReportButton(
              context,
              'Others',
              Colors.white,
                  () {
                Navigator.pushNamed(context, '/report_misinfo');
              },
            ),*/
          ],
        ),
      ),
    );
  }

  Widget _buildReportButton(BuildContext context, String text, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity, // Make buttons take the full width
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.yellow[700],
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
