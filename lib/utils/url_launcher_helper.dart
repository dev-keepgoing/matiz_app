import 'package:url_launcher/url_launcher.dart';

class UrlLauncherHelper {
  /// Launches a given URL in the default browser.
  static Future<void> openUrl(String url) async {
    final Uri uri = Uri.parse(url); // Parse the string into a Uri object
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
