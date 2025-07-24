import 'package:flutter/cupertino.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Color(0xFF60D3F3).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFF60D3F3).withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Color(0xFF60D3F3), size: 30),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: Color(0xFF60D3F3),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
