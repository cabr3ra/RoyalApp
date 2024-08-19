import 'package:flutter/material.dart';
import 'package:royal_app/constants/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class Donation extends StatelessWidget {
  final String donationUrl = "https://www.paypal.com/donate/?hosted_button_id=5BGTT564JX6PS";

  // Método para abrir la URL en un navegador
  Future<void> _launchURL() async {
    if (await canLaunch(donationUrl)) {
      await launch(donationUrl);
    } else {
      throw 'No se puede abrir la URL: $donationUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Apoya el proyecto:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _launchURL,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.colorCrown,
            ),
            child: Text(
              'Donar',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.colorPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
