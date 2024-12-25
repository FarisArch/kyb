import 'package:flutter/material.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

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
              'Welcome to Admin Dashboard',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 30),
            _buildReportButton(
              context,
              'Add a new brand',
              Colors.white,
              () {
                Navigator.pushNamed(context, '/admin_new_brand');
              },
            ),
            SizedBox(height: 10),
            _buildReportButton(
              context,
              'Update existing brand information',
              Colors.white,
              () {
                Navigator.pushNamed(context, '/admin_update_brand');
              },
            ),
            SizedBox(height: 10),
            _buildReportButton(
              context,
              "View brands report",
              Colors.white,
              () {
                Navigator.pushNamed(context, '/admin_view_reports');
              },
            ),
            SizedBox(height: 10),
            _buildReportButton(
              context,
              "Brand Approvals",
              Colors.white,
              () {
                Navigator.pushNamed(context, '/admin_approval');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportButton(BuildContext context, String text, Color color, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity, // Makes the button take full width
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
