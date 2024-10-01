import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:media_scanner/media_scanner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:posterify/constants/constants.dart';
import 'package:posterify/constants/shimmer.dart';
import 'package:posterify/service/web_service.dart';
import 'package:http/http.dart' as http;
import 'package:posterify/view/Nav_pages/home/edit.dart';

// ignore: must_be_immutable
class ScreenPreview extends StatelessWidget {
  String image;
  ScreenPreview({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        bottom: const PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: Divider(
              height: 0,
            )),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () => _saveNetworkImage(image, context),
        child: Container(
          decoration: BoxDecoration(
              color: lightPrimaryColor,
              borderRadius: BorderRadius.circular(20)),
          margin: EdgeInsets.all(12),
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Download',
                style: TextStyle(
                    color: white, fontSize: 18, fontWeight: FontWeight.w700),
              ),
              SizedBox(
                width: size40(context),
              ),
              Icon(
                BoxIcons.bx_cloud_download,
                color: white,
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: FittedBox(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  WebService().projectUrl + image,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return ShimmerLoading(
                        isLoading: true,
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors
                              .grey, // Placeholder color until image loads
                        ),
                      );
                    }
                  },
                )),
          ),
        ),
      ),
    );
  }

  Future<void> _saveNetworkImage(String image, BuildContext context) async {
    // Request storage permission
    await requestPermission();
    final isSavedNotifier = ValueNotifier<bool>(false);

    // Show the loader dialog with the notifier
    showLoaderDialog(context, isSavedNotifier);

    // Fetch the image data
    final response = await http.get(Uri.parse(WebService().projectUrl + image));

    if (response.statusCode == 200) {
      // Get the custom directory for saving the image
      String customPath = await getCustomDirectory();

      log("customPath: $customPath");

      // Get the base name and extension of the image
      String baseName = image.split('.').first; // e.g., "picture"
      String extension = image.split('.').last; // e.g., "jpg"

      // Define the file name and create the file path
      String filePath = '$customPath/$image';
      int counter = 1;

      // Check if the file exists and modify the file name
      while (await File(filePath).exists()) {
        // If the file exists, append the counter to the file name
        filePath = '$customPath/$baseName($counter).$extension';
        counter++;
      }
      // Save the file temporarily
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      MediaScanner.loadMedia(path: file.path);

      // Update the state
      isSavedNotifier.value = true;

      await Future.delayed(const Duration(seconds: 1));

      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } else {
      // Handle error
      print("Failed to download image.");
    }
  }

  Future<void> requestPermission() async {
    if (await Permission.storage.request().isGranted) {
      print("Storage Permission granted");
    } else {
      print("Storage Permission denied");
    }
  }

  Future<String> getCustomDirectory() async {
    Directory? directory;

    // // Check if the platform is Android or iOS
    if (Platform.isAndroid) {
      // For Android, use external storage
      directory = Directory('/storage/emulated/0/Pictures/Posterify');
    } else if (Platform.isIOS) {
      // For iOS, use the app's documents directory
      directory = await getApplicationDocumentsDirectory();
    } else {
      throw UnsupportedError("Unsupported platform");
    }

    // Create the directory if it doesn't exist
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    return directory.path;
  }
}
