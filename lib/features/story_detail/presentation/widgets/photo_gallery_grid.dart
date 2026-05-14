import 'package:flutter/material.dart';
import '../../../../app/theme/app_theme.dart';
import '../../../../shared/widgets/shared_widgets.dart';

class PhotoGalleryGrid extends StatelessWidget {
  final List<String> images;

  const PhotoGalleryGrid({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: images.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (context, index) {
        final path = images[index];
        return GestureDetector(
          onTap: () {},
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: TrekAssetImage(
              assetPath: path,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
