import 'package:flutter/material.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                Navigator.pushNamed(context, '/report_wrongcategory');
              },
            ),
            SizedBox(height: 10),
            _buildReportButton(
              context,
              'Product is in wrong classification',
              Colors.white,
                  () {
                Navigator.pushNamed(context, '/report_wrongclass');
              },
            ),
            SizedBox(height: 10),
            _buildReportButton(
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportButton(
      BuildContext context, String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
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
    );
  }
}
