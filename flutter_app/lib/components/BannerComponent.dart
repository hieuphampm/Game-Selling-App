import 'package:flutter/material.dart';

class BannerComponent extends StatelessWidget {
  const BannerComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [Color(0xFFFFD9F5), Color(0xFFFAB4E5), Color(0xFF60D3F3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 20,
            top: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SUMMER SALE',
                  style: TextStyle(
                    color: Color(0xFF0D0D0D),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Up to 70% OFF',
                  style: TextStyle(
                    color: Color(0xFF0D0D0D),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 20,
            bottom: 20,
            child: Icon(
              Icons.videogame_asset,
              size: 80,
              color: Color(0xFF0D0D0D).withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}
