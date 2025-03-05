import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:matiz/app/widgets/bullet_point_widget.dart';
import 'package:matiz/core/data/services/analytics_service.dart';
import 'package:matiz/features/validation/widget/validation_modal.dart';
import 'package:matiz/utils/url_launcher_helper.dart';
import 'package:photo_view/photo_view.dart';
import 'package:matiz/features/albums/data/models/album_model.dart';

class AlbumCard extends StatelessWidget {
  final Album album;
  final bool isUserLoggedin;

  const AlbumCard(
      {super.key, required this.album, this.isUserLoggedin = false});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft:
                      Radius.circular(50), // Only top-left corner is rounded
                  topRight:
                      Radius.circular(50), // Only top-right corner is rounded
                ),
                child: GestureDetector(
                  onTap: () => _showFullScreenImage(context, album.image),
                  child: Image.network(
                    album.image,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Text(
                      album.title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      album.subtitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (album.validation != "completed" &&
                        (album.shopifyUrl != null &&
                            album.shopifyUrl!.isNotEmpty))
                      ElevatedButton(
                        onPressed: () {
                          // Log the event when the "COMPRA AHORA" button is clicked
                          AnalyticsService().logClickCompraAhora(
                            albumId: album.id,
                            albumTitle: album.title,
                            isUserLoggedin: isUserLoggedin,
                          );
                          // Open the Shopify URL
                          UrlLauncherHelper.openUrl(album.shopifyUrl!);
                        },
                        child: const Text('COMPRA AHORA'),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (isUserLoggedin)
            Positioned(
                bottom: 15,
                right: 40,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => (album.validation == null)
                          ? _showValidationModal(context, album)
                          : {},
                      child: Icon(
                        album.validation == "completed"
                            ? Icons.verified_sharp
                            : Icons.verified_outlined,
                        color: album.validation == "completed"
                            ? Colors.black
                            : album.validation == "pending"
                                ? Colors.grey
                                : Colors.blue,
                        size: 28, // Slightly larger for better visibility
                      ),
                    ),
                    if (album.validation == null)
                      Text(
                        "VÁLIDA",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.blue),
                      ),
                    if (album.validation == "pending")
                      Text(
                        "EN VALIDACIÓN",
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.grey),
                      )
                  ],
                )),
        ],
      ),
    );
  }

  /// **📸 Trigger Image Capture & Upload**
  void _validateMerch(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);

    if (pickedFile == null) {
      return;
    }

    File imageFile = File(pickedFile.path);

    Navigator.of(context).pop();

    // ✅ Open the preview modal
    _showValResultModal(context, imageFile);
  }

  void _showValResultModal(BuildContext context, File imageFile) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Full height modal behavior
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => ValidationModal(
        artistId: album.artistUid ?? '',
        imageFile: imageFile,
        merchId: album.id,
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      barrierColor: Colors.black.withAlpha(204),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Scaffold(
            backgroundColor: Colors.black.withAlpha(204),
            body: Center(
              child: PhotoView(
                imageProvider: NetworkImage(imageUrl),
                backgroundDecoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2.0,
              ),
            ),
          ),
        );
      },
    );
  }

  void _showValidationModal(BuildContext context, Album album) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows better height control
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return FractionallySizedBox(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        album.image,
                        width: 150, // Fixed width for consistency
                        height: 250, // Fixed height
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12), // Space between columns
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                              child: Text(
                            "VALIDA TU PÓSTER",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          )),
                          const SizedBox(height: 22),
                          Text("¿POR QUÉ VALIDAR TU PÓSTER?",
                              style: Theme.of(context).textTheme.displayMedium),
                          const SizedBox(height: 10),
                          const BulletPoint(text: "ASEGURAS SU AUTENTICIDAD"),
                          const BulletPoint(
                              text: "GANAS RECOMPENSAS EXCLUSIVAS"),
                          const BulletPoint(
                              text: "ENTRAS A LA COMUNIDAD DEL ARTISTA"),
                          const SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                _validateMerch(
                                    context); // Start validation process
                              },
                              child: const Text("VALIDAR PÓSTER"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
