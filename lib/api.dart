import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'post.dart';

Future<Post> fetchPost() async {

  final String DOMAIN = 'www.woo.local';
  final String PATH = '/index.php/wp-json/wp/v2/posts/1';

  bool _certificateCheck(X509Certificate cert, String host, int port) =>
      host == 'www.woo.local';

  http.Client wooClient() {
    var ioClient = new HttpClient()
      ..badCertificateCallback = _certificateCheck;

    return new http.IOClient(ioClient);
  }

  var client = wooClient();

  final uri = Uri.https(DOMAIN, PATH);

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
