import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PrescriptionViewer extends StatelessWidget {
  final List<String> urls;
  final int initialIndex;

  const PrescriptionViewer({
    super.key,
    required this.urls,
    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context) {
    final controller = PageController(initialPage: initialIndex);

    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          PhotoViewGallery.builder(
            pageController: controller,
            itemCount: urls.length,
            backgroundDecoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            builder: (context, index) {
              final url = urls[index];
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(url),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 3.5,
                heroAttributes: PhotoViewHeroAttributes(tag: '$url-$index'),
                errorBuilder: (_, __, ___) => Center(
                  child: Text(
                    'Failed to load image',
                    style: TextStyle(fontSize: 14.sp, color: Colors.white),
                  ),
                ),
              );
            },
            loadingBuilder: (context, event) {
              return Center(
                child: SizedBox(
                  width: 28.w,
                  height: 28.w,
                  child: const CircularProgressIndicator(strokeWidth: 3),
                ),
              );
            },
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 10.h,
            right: 12.w,
            child: InkWell(
              onTap: Get.back,
              borderRadius: BorderRadius.circular(999),
              child: Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.35),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, size: 20.sp, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
