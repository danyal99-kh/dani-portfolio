import 'package:web/web.dart' as web;

Future<bool> downloadAssetFile({
  required String assetPath,
  required String fileName,
}) async {
  try {
    final href = Uri.base.resolve('assets/$assetPath').toString();
    final anchor = web.HTMLAnchorElement()
      ..href = href
      ..download = fileName
      ..target = '_blank'
      ..rel = 'noopener';
    web.document.body?.append(anchor);
    anchor.click();
    anchor.remove();
    return true;
  } catch (_) {
    return false;
  }
}
