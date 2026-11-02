import 'package:url_launcher/url_launcher.dart';

Future<bool> downloadAssetFile({
  required String assetPath,
  required String fileName,
}) async {
  final uri = Uri.parse('assets/$assetPath');
  return launchUrl(uri, mode: LaunchMode.externalApplication);
}
