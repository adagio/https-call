import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'post.dart';

class Api {
  
  final String DOMAIN = 'www.woo.local';

  bool _certificateCheck(X509Certificate cert, String host, int port) =>
        host == DOMAIN;

  http.Client wooClient() {
    var ioClient = new HttpClient()
      ..badCertificateCallback = _certificateCheck;
    return new http.IOClient(ioClient);
  }

  Future<Post> fetchPost(int id) async {

    final String PATH = '/index.php/wp-json/wp/v2/posts/${id}';

    final uri = Uri.https(DOMAIN, PATH);

    var client = wooClient();

    final response =
    await client.get(uri,
      //headers: {HttpHeaders.authorizationHeader: "Basic your_api_token_here"},
    );

    if (response.statusCode == 200) {
      // If the call to the server was successful, parse the JSON
      return Post.fromJson(json.decode(response.body));
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }

  }

}