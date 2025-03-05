// import 'dart:io';
// import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:image_picker/image_picker.dart';

// class MLService {
//   final TextRecognizer _textRecognizer = TextRecognizer();
//   final ImageLabeler _imageLabeler = GoogleMlKit.vision.imageLabeler();

//   /// **📸 Step 1: Capture Image**
//   Future<File?> pickImage() async {
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.camera);
//     return pickedFile != null ? File(pickedFile.path) : null;
//   }

//   /// **🔍 Step 2: Extract Text from Image**
//   Future<String?> extractTextFromImage(File imageFile) async {
//     try {
//       final inputImage = InputImage.fromFile(imageFile);
//       final RecognizedText recognizedText =
//           await _textRecognizer.processImage(inputImage);

//       // ✅ Combine all recognized text into a single string
//       String extractedText = recognizedText.text;
//       print("🔍 Extracted Text: $extractedText");

//       return extractedText.isNotEmpty ? extractedText : null;
//     } catch (e) {
//       print("🔥 Error processing image: $e");
//       return null;
//     }
//   }

//   /// **🔎 Step 3: Detect Matiz Logo using Image Labeling**
//   Future<bool> detectMatizLogo(File imageFile) async {
//     try {
//       final inputImage = InputImage.fromFile(imageFile);
//       final List<ImageLabel> labels =
//           await _imageLabeler.processImage(inputImage);

//       for (ImageLabel label in labels) {
//         print("🖼️ Detected: ${label.label} - Confidence: ${label.confidence}");

//         // **🔥 Check if "logo" or "brand" is detected in the image**
//         if (label.label.toLowerCase().contains("logo") ||
//             label.label.toLowerCase().contains("brand") ||
//             label.label.toLowerCase().contains("intuitions")) {
//           return true; // ✅ Logo detected!
//         }
//       }
//       return false; // ❌ No logo detected
//     } catch (e) {
//       print("🔥 Error detecting logo: $e");
//       return false;
//     }
//   }

//   /// **✅ Step 4: Validate Poster**
//   Future<bool> validatePoster(File imageFile) async {
//     bool hasLogo = await detectMatizLogo(imageFile); // Detect Logo
//     print("hasLogo $hasLogo");
//     final extractedText = await extractTextFromImage(imageFile); // Extract Text

//     // 🔥 **Validation Logic** (Custom Rules)
//     bool hasBarcode = extractedText != null &&
//         extractedText.contains("spotify.com"); // Check for Spotify barcode

//     return hasLogo && hasBarcode;
//   }

//   /// **♻️ Free ML Resources**
//   void dispose() {
//     _textRecognizer.close();
//     _imageLabeler.close();
//   }
// }
