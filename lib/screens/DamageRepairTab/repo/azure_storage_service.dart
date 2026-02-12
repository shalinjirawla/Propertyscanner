import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:property_scan_pro/Environment/Config/azure_config.dart';

class AzureStorageService {
  static const String _accountName = AzureConfig.accountName;
  static const String _accountKey = AzureConfig.accountKey;
  static const String _container = AzureConfig.containerName;

  static Future<String?> uploadVideo(File file) async {
    try {
      final fileName =
          'video_${DateTime.now().millisecondsSinceEpoch}.mp4'; // Customize as needed
      final url =
          'https://$_accountName.blob.core.windows.net/$_container/$fileName';
      final uri = Uri.parse(url);

      final now = DateTime.now().toUtc();
      final date = HttpDate.format(now);

      final bytes = await file.readAsBytes();
      final contentLength = bytes.length;
      final type = 'BlockBlob';

      // Construct the canonicalized headers
      final canonicalizedHeaders =
          'x-ms-blob-type:$type\nx-ms-date:$date\nx-ms-version:2020-04-08';

      // Construct the canonicalized resource
      final canonicalizedResource = '/$_accountName/$_container/$fileName';

      // Construct the signature string
      final stringToSign =
          'PUT\n'
          '\n' // Content-Encoding
          '\n' // Content-Language
          '$contentLength\n' // Content-Length
          '\n' // Content-MD5
          'video/mp4\n' // Content-Type
          '\n' // Date
          '\n' // If-Modified-Since
          '\n' // If-Match
          '\n' // If-None-Match
          '\n' // If-Unmodified-Since
          '\n' // Range
          '$canonicalizedHeaders\n'
          '$canonicalizedResource';

      final signature = _generateSignature(stringToSign, _accountKey);
      final authorization = 'SharedKey $_accountName:$signature';

      final response = await http.put(
        uri,
        headers: {
          'x-ms-blob-type': type,
          'x-ms-date': date,
          'x-ms-version': '2020-04-08',
          'Authorization': authorization,
          'Content-Length': contentLength.toString(),
          'Content-Type': 'video/mp4',
        },
        body: bytes,
      );

      if (response.statusCode == 201) {
        return url;
      } else {
        print('Azure Upload Failed: ${response.statusCode} - ${response.body}');
        return null; // Handle error appropriately
      }
    } catch (e) {
      print('Azure Upload Error: $e');
      return null;
    }
  }

  static String _generateSignature(String stringToSign, String accountKey) {
    final keyBytes = base64Decode(accountKey);
    final hmacSha256 = Hmac(sha256, keyBytes);
    final digest = hmacSha256.convert(utf8.encode(stringToSign));
    return base64Encode(digest.bytes);
  }
}
