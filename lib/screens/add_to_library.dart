import 'dart:convert';
import 'package:http/http.dart' as http;

class AddToLibrary{

  Future addBook(String book_id, String user_id) async {

    final response = await http.post(
      Uri.parse('http://192.168.29.145:8888/login'),
      body: jsonEncode(<String, String>{
        'book_id': book_id,
        'user_id' : user_id,
      }),
    );

  }
}