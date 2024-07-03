import 'package:first_project/screens/pdf_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DownloadedBooksPage extends StatefulWidget {

  DownloadedBooksPage({Key? key}) : super(key: key);

  @override
  _DownloadedBooksPageState createState() => _DownloadedBooksPageState();
}

class _DownloadedBooksPageState extends State<DownloadedBooksPage> {
  List<FileSystemEntity> downloadedBooks = [];
  bool filesIsLoading = true;
  List<String> booksId = [];
  List<Map> booksList = [];

  @override
  void initState() {
    super.initState();
    fetchDownloadedBooks();
  }

  String extractBookId(String filePath) {
    final fileName = filePath.split('/').last; // Get the file name
    return fileName;
  }

  Future<void> fetchDownloadedBooks() async {
    final dir = await getApplicationDocumentsDirectory();
    final downloadDir = Directory("${dir.path}/downloadedBooks");

    if (await downloadDir.exists()) {
      final files = downloadDir.listSync();
      setState(() {
        downloadedBooks = files;
        booksId = files.map((file) => extractBookId(file.path)).toList();
        filesIsLoading = false;
      });
    } else {
      setState(() {
        filesIsLoading = false;
      });
    }

    if (booksId.isNotEmpty) {
      for (String id in booksId) {
        await fetchBooks(id); // Await each book fetch
      }
    }
  }

  Future<void> fetchBooks(String _id) async {
    try {
      final response = await http.get(Uri.parse("http://192.168.29.145:8888/fetchbook?book_id=$_id"));
      if (response.statusCode == 200) {
        setState(() {
          var book = json.decode(response.body);
          booksList.add(book);
        });
      } else {
        // Handle server errors
        print('Server error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle network errors
      print('Network error: $e');
    }
  }

  Future<void> deleteBook(String bookId) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final filePath = "${dir.path}/downloadedBooks/$bookId";
      final file = File(filePath);

      if (await file.exists()) {
        await file.delete();
        setState(() {
          downloadedBooks.removeWhere((file) => extractBookId(file.path) == bookId);
          booksId.remove(bookId);
          booksList.removeWhere((book) => book['_id'] == bookId);
        });
      }
    } catch (e) {
      print('Error deleting book: $e');
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context, String bookId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("Are you sure you want to delete this book?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () async {
                await deleteBook(bookId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Downloaded Books'),
      ),
      body: filesIsLoading
          ? Center(child: CircularProgressIndicator())
          :Wrap(
        spacing: 15.0,
        runSpacing: 15.0,
        children: List.generate(booksList.length, (index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PDFScreen(bookId: booksList[index]['_id']),
                ),
              );
            },
            child: Stack(
              children: [
                Container(
                  height: 200, // Set your desired height
                  width: 140, // Set your desired width
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                  ),
                  child: ClipRRect(
                    child: Image.network(
                      booksList[index]['image_url'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: 40,
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white.withOpacity(0.4),
                        child: IconButton(
                          icon: Icon(Icons.delete),
                            onPressed: () => _showDeleteConfirmationDialog(context, booksList[index]['_id']),
                          iconSize: 18,
                          color: Colors.black,
                        ),
                      ),

                    ],
                  ),
                ),

              ],
            ),
          );
        }),
      ),
    );
  }

}
