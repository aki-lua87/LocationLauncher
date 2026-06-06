import 'dart:typed_data';
import 'package:http/http.dart' as http;

Future<Uint8List?> fetchFavicon(String url) async {
  try {
    final uri = Uri.parse(url);
    final domain = '${uri.scheme}://${uri.host}';
    final faviconUrl =
        'https://www.google.com/s2/favicons?domain=$domain&sz=128';
    final response = await http
        .get(Uri.parse(faviconUrl))
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200 && response.bodyBytes.isNotEmpty) {
      return response.bodyBytes;
    }
  } catch (_) {}
  return null;
}
