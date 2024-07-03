import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class PDFManager {
  Future<String?> loadPDF(String bookId) async {
    final downloadDir = await getApplicationDocumentsDirectory();
    final downloadedFilePath = '${downloadDir.path}/downloadedBooks/$bookId.pdf';
    final downloadedFile = File(downloadedFilePath);

    if (await downloadedFile.exists()) {
      return downloadedFilePath;
    } else {
      return null;
    }
  }

  Future<String?> fetchTemporaryPDF(String bookId) async {
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$bookId.pdf');

      // Download the file
      final url = 'http://192.168.29.145:8888/bookpdf?book_id=$bookId';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        await file.writeAsBytes(bytes, flush: true);
        return file.path;
      } else {
        throw Exception('Failed to load PDF');
      }
    } catch (e) {
      print('Error fetching PDF: $e');
      return null;
    }
  }

  Future<void> downloadPDF(String pdfPath, String bookId) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final downloadDir = Directory('${dir.path}/downloadedBooks');

      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }

      final file = File(pdfPath);
      final newFile = File('${downloadDir.path}/$bookId.pdf');
      await newFile.writeAsBytes(await file.readAsBytes());
    } catch (e) {
      print('Error downloading PDF: $e');
    }
  }

  Future<bool> deleteDownloadedPDF(String bookId) async {
    try {
      final downloadDir = await getApplicationDocumentsDirectory();
      final downloadedFilePath = '${downloadDir.path}/downloadedBooks/$bookId.pdf';
      final downloadedFile = File(downloadedFilePath);

      if (await downloadedFile.exists()) {
        await downloadedFile.delete();
        print('Deleted downloaded PDF: $downloadedFilePath');
        return true;
      } else {
        print('No downloaded PDF found for bookId: $bookId');
        return false;
      }
    } catch (e) {
      print('Error deleting downloaded PDF: $e');
      return false;
    }
  }
}
