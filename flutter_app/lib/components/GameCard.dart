import 'package:flutter/material.dart';
import '../screens/game_detail_screen.dart';

class GameCard extends StatelessWidget {
  final String documentId;
  final String title;
  final String price;
  final double? rating;
  final String thumbnailUrl;

  const GameCard({
    super.key,
    required this.documentId,
    required this.title,
    required this.price,
    required this.rating,
    required this.thumbnailUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 400),
            pageBuilder: (_, __, ___) =>
                GameDetailScreen(documentId: documentId),
          ),
        );
      },
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF333333)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Thumbnail with safe fallback
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Hero(
                tag: 'thumbnail_$documentId',
                child: thumbnailUrl.isNotEmpty
                    ? Image.network(
                        thumbnailUrl,
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildImageError(),
                        loadingBuilder: (_, child, progress) {
                          if (progress == null) return child;
                          return _buildImageLoading();
                        },
                      )
                    : _buildImageError(),
              ),
            ),

            // Game Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFFFFD9F5),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (rating != null)
                    Row(
                      children: [
                        const Icon(Icons.star,
                            color: Color(0xFFFAB4E5), size: 16),
                        const SizedBox(width: 4),
                        Text(
                          rating!.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Color(0xFF60D3F3),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),
                  Text(
                    price,
                    style: const TextStyle(
                      color: Color(0xFFFAB4E5),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageLoading() => Container(
        height: 100,
        width: double.infinity,
        color: Colors.grey[900],
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );

  Widget _buildImageError() => Container(
        height: 100,
        width: double.infinity,
        color: Colors.grey[800],
        child: const Icon(Icons.broken_image, color: Colors.white),
      );
}
