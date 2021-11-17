import 'dart:typed_data';

import 'package:http/http.dart' as http;

/// Returns the image provided by the [imageUrl] as a byte list
Future<Uint8List> urlImageToBytes(Uri imageUrl) async {
  http.Response response = await http.get(imageUrl);

  return (response.bodyBytes);
}
