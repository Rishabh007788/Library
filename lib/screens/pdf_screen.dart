import 'package:first_project/screens/handle_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PDFScreen extends StatefulWidget {
  final String bookId;

  PDFScreen({required this.bookId});

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  String? pdfPath;
  String? tempPdfPath;
  bool isDownloading = false;
  bool isDownloaded = false;
  PDFManager pdfManager = new PDFManager();

  @override
  void initState() {
    super.initState();
    loadPDF();
  }

  Future<void> loadPDF() async {
    final loadedPdfPath = await pdfManager.loadPDF(widget.bookId);
    if (loadedPdfPath != null) {
      setState(() {
        pdfPath = loadedPdfPath;
        isDownloaded = true;
      });
    } else {
      await fetchTemporaryPDF();
    }
  }

  Future<void> fetchTemporaryPDF() async {
    try {
      setState(() {
        isDownloading = true;
      });
      final tempPath = await pdfManager.fetchTemporaryPDF(widget.bookId);
      if (tempPath != null) {
        setState(() {
          pdfPath = tempPath;
          tempPdfPath = tempPath;
        });
      } else {
        throw Exception('Failed to load temporary PDF');
      }
    } catch (e) {
      print('Error fetching PDF: $e');
      // Handle error appropriately here, like showing an error message to the user
    } finally {
      setState(() {
        isDownloading = false;
      });
    }
  }

  Future<void> downloadPDF() async {
    try {
      if (pdfPath == null) return;
      setState(() {
        isDownloading = true;
      });
      await pdfManager.downloadPDF(pdfPath!, widget.bookId);
      setState(() {
        isDownloaded = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Book Downloaded')));
    } catch (e) {
      print('Error downloading PDF: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to download Book')));
    } finally {
      setState(() {
        isDownloading = false;
      });
    }
  }


  Future<void> deleteDownloadedPDF() async {
    final success = await pdfManager.deleteDownloadedPDF(widget.bookId);
    if (success) {
      setState(() {
        pdfPath = null;
        isDownloaded = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Book Deleted')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete Book')));
    }
  }

  @override
  void dispose() {
    if (tempPdfPath != null && !isDownloaded) {
      File(tempPdfPath!).delete().then((_) {
        print("Temporary PDF deleted successfully####################################");
      }).catchError((error) {
        print("Error deleting temporary PDF: $error");
      });
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book PDF'),
        actions: [
          IconButton(
            icon: Icon(
              isDownloaded ? Icons.delete : Icons.download,
              color: isDownloaded ? Colors.green : null,
            ),
            onPressed: isDownloaded ? deleteDownloadedPDF : downloadPDF,
          ),
        ],
      ),
      body: isDownloading
          ? Center(child: CircularProgressIndicator())
          : pdfPath != null
          ? PDFView(filePath: pdfPath!)
          : Center(child: CircularProgressIndicator()),
    );
  }
}
